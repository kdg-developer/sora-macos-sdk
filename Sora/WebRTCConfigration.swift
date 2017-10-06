import Foundation
import WebRTC

public struct MediaConstraints {
    
    public var mandatory: [String: String] = [:]
    public var optional: [String: String] = [:]
    
    var nativeValue: RTCMediaConstraints {
        get {
            return RTCMediaConstraints(mandatoryConstraints: mandatory,
                                       optionalConstraints: optional)
        }
    }
    
}

public struct WebRTCConfiguration {
    
    // MARK: メディア制約に関する設定
    
    public var constraints: MediaConstraints = MediaConstraints()
    
    // MARK: ICE サーバーに関する設定
    
    public var iceServerInfos: [ICEServerInfo]
    public var iceTransportPolicy: ICETransportPolicy = .none

    // MARK: - 初期化
    
    public init() {
        iceServerInfos = [
            ICEServerInfo(urls: [URL(string: "stun:stun.l.google.com:19302")!],
                          userName: nil,
                          credential: nil,
                          tlsSecurityPolicy: .secure)]
    }
    
    var nativeValue: RTCConfiguration {
        get {
            let config = RTCConfiguration()
            config.iceServers = iceServerInfos.map { info in
                return info.nativeValue
            }
            config.iceTransportPolicy = iceTransportPolicy.nativeValue
            return config
        }
    }
    
    var nativeConstraints: RTCMediaConstraints {
        get { return constraints.nativeValue }
    }
    
}
