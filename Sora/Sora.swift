import Foundation
import AVFoundation
import WebRTC

/// `Sora` オブジェクトのイベントハンドラです。
public final class SoraHandlers {
    
    /// このプロパティは onConnect に置き換えられました。
    @available(*, deprecated, renamed: "onConnect",
    message: "このプロパティは onConnect に置き換えられました。")
    public var onConnectHandler: ((MediaChannel?, Error?) -> Void)? {
        get { onConnect }
        set { onConnect = newValue }
    }
    
    /// このプロパティは onDisconnect に置き換えられました。
    @available(*, deprecated, renamed: "onDisconnect",
    message: "このプロパティは onDisconnect に置き換えられました。")
    public var onDisconnectHandler: ((MediaChannel, Error?) -> Void)? {
           get { onDisconnect }
           set { onDisconnect = newValue }
       }
    
    /// このプロパティは onAddMediaChannel に置き換えられました。
    @available(*, deprecated, renamed: "onAddMediaChannel",
    message: "このプロパティは onAddMediaChannel に置き換えられました。")
    public var onAddMediaChannelHandler: ((MediaChannel) -> Void)? {
           get { onAddMediaChannel }
           set { onAddMediaChannel = newValue }
       }
    
    /// このプロパティは onRemoveMediaChannel に置き換えられました。
    @available(*, deprecated, renamed: "onRemoveMediaChannel",
    message: "このプロパティは onRemoveMediaChannel に置き換えられました。")
    public var onRemoveMediaChannelHandler: ((MediaChannel) -> Void)? {
           get { onRemoveMediaChannel }
           set { onRemoveMediaChannel = newValue }
       }
    
    /// 接続成功時に呼ばれるクロージャー
    public var onConnect: ((MediaChannel?, Error?) -> Void)?
    
    /// 接続解除時に呼ばれるクロージャー
    public var onDisconnect: ((MediaChannel, Error?) -> Void)?
    
    /// メディアチャネルが追加されたときに呼ばれるクロージャー
    public var onAddMediaChannel: ((MediaChannel) -> Void)?
    
    /// メディアチャネルが除去されたときに呼ばれるクロージャー
    public var onRemoveMediaChannel: ((MediaChannel) -> Void)?

    /// 初期化します。
    public init() {}
    
}

/**
 サーバーへのインターフェースです。
 `Sora` オブジェクトを使用してサーバーへの接続を行います。
 */
public final class Sora {
    
    // MARK: - SDK の操作
    
    private static let isInitialized: Bool = {
        initialize()
        return true
    }()
    
    private static func initialize() {
        Logger.debug(type: .sora, message: "initialize SDK")
        RTCInitializeSSL()
        RTCEnableMetrics()
    }
    
    /**
     SDK の終了処理を行います。
     アプリケーションの終了と同時に SDK の使用を終了する場合、
     この関数を呼ぶ必要はありません。
     */
    public static func finish() {
        Logger.debug(type: .sora, message: "finish SDK")
        RTCShutdownInternalTracer()
        RTCCleanupSSL()
    }
    
    /**
     ログレベル。指定したレベルより高いログは出力されません。
     デフォルトは `info` です。
     */
    public static var logLevel: LogLevel {
        get {
            return Logger.shared.level
        }
        set {
            Logger.shared.level = newValue
        }
    }
    
    /// スポットライトレガシー機能を有効化する
    @available(*, deprecated,
    message: "Sora のスポットライトレガシー機能は 2021 年 12 月のリリースにて廃止予定です。")
    public static func useSpotlightLegacy() {
        isSpotlightLegacyEnabled = true
    }
    
    // MARK: - プロパティ
    
    /// 接続中のメディアチャネルのリスト
    public private(set) var mediaChannels: [MediaChannel] = []
    
    /// イベントハンドラ
    public let handlers: SoraHandlers = SoraHandlers()
    
    internal static var isSpotlightLegacyEnabled: Bool = false
    
    // MARK: - インスタンスの生成と取得
    
    /// シングルトンインスタンス
    public static let shared: Sora = Sora()
    
    /**
     初期化します。
     大抵の用途ではシングルトンインスタンスで問題なく、
     インスタンスを生成する必要はないでしょう。
     メディアチャネルのリストをグループに分けたい、
     または複数のイベントハンドラを使いたいなどの場合に
     インスタンスを生成してください。
     */
    public init() {
        // This will guarantee that `Sora.initialize()` is called only once.
        // - It works even if user initialized `Sora` directly
        // - It works even if user directly use `Sora.shared`
        // - It guarantees `initialize()` is called only once thanks to the `static let` https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html#//apple_ref/doc/uid/TP40014097-CH14-ID254
        let initialized = Sora.isInitialized
        // This looks silly, but this will ensure `Sora.isInitialized` is not be omitted,
        // no matter how clang optimizes compilation.
        // If we go for `let _ = Sora.isInitialized`, clang may omit this line,
        // which is fatal to the initialization logic.
        // The following line will NEVER fail.
        if !initialized { fatalError() }
    }
    
    // MARK: - メディアチャネルの管理
    
    func add(mediaChannel: MediaChannel) {
        DispatchQueue.global().sync {
            if !mediaChannels.contains(mediaChannel) {
                Logger.debug(type: .sora, message: "add media channel")
                mediaChannels.append(mediaChannel)
                handlers.onAddMediaChannel?(mediaChannel)
            }
        }
    }
    
    func remove(mediaChannel: MediaChannel) {
        DispatchQueue.global().sync {
            if mediaChannels.contains(mediaChannel) {
                Logger.debug(type: .sora, message: "remove media channel")
                mediaChannels.remove(mediaChannel)
                handlers.onRemoveMediaChannel?(mediaChannel)
            }
        }
    }
    
    // MARK: - 接続
    
    /**
     サーバーに接続します。
     
     - parameter configuration: クライアントの設定
     - parameter webRTCConfiguration: WebRTC の設定
     - parameter handler: 接続試行後に呼ばれるクロージャー。
     - parameter mediaChannel: (接続成功時のみ) メディアチャネル
     - parameter error: (接続失敗時のみ) エラー
     - returns: 接続試行中の状態
     */
    public func connect(configuration: Configuration,
                        webRTCConfiguration: WebRTCConfiguration = WebRTCConfiguration(),
                        handler: @escaping (_ mediaChannel: MediaChannel?,
        _ error: Error?) -> Void) -> ConnectionTask {
        Logger.debug(type: .sora, message: "connecting \(configuration.url.absoluteString)")
        let mediaChan = MediaChannel(manager: self, configuration: configuration)
        mediaChan.internalHandlers.onDisconnect = { [weak self, weak mediaChan] error in
            guard let weakSelf = self else {
                return
            }
            guard let mediaChan = mediaChan else {
                return
            }
            weakSelf.remove(mediaChannel: mediaChan)
            weakSelf.handlers.onDisconnect?(mediaChan, error)
        }

        // MediaChannel.connect() の引数のハンドラが実行されるまで
        // 解放されないように先にリストに追加しておく
        // ただ、 mediaChannels を weak array にすべきかもしれない
        add(mediaChannel: mediaChan)

        return mediaChan.connect(webRTCConfiguration: webRTCConfiguration) { [weak self, weak mediaChan] error in
            guard let weakSelf = self else {
                return
            }
            guard let mediaChan = mediaChan else {
                return
            }

            if let error = error {
                handler(nil, error)
                weakSelf.handlers.onConnect?(nil, error)
                return
            }

            handler(mediaChan, nil)
            weakSelf.handlers.onConnect?(mediaChan, nil)
        }
    }
}

/**
 サーバーへの接続試行中の状態を表します。
 `cancel()` で接続をキャンセル可能です。
 */
public final class ConnectionTask {
    
    /**
     接続状態を表します。
     */
    public enum State {
        
        /// 接続試行中
        case connecting
        
        /// 接続済み
        case completed
        
        /// キャンセル済み
        case canceled
    }
    
    weak var peerChannel: PeerChannel?
    
    /// 接続状態
    public private(set) var state: State
    
    init() {
        state = .connecting
    }
    
    /**
     * 接続試行をキャンセルします。
     * すでに接続済みであれば何もしません。
     */
    public func cancel() {
        if state == .connecting {
            Logger.debug(type: .mediaChannel, message: "connection task cancelled")
            peerChannel?.disconnect(error: SoraError.connectionCancelled)
            state = .canceled
        }
    }
    
    func complete() {
        if state != .completed {
            Logger.debug(type: .mediaChannel, message: "connection task completed")
            state = .completed
        }
    }
    
}
