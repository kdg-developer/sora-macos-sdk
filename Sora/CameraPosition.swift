import Foundation

private var descriptionTable: PairTable<String, CameraPosition> =
    PairTable(pairs: [("front", .front),
                      ("back", .back)])

/**
 カメラの位置を表します。
 */
public enum CameraPosition {
    
    /// 前面
    case front
    
    /// 背面
    case back
    
    /**
     カメラの位置の前面と背面を反転します。
     
     - returns: 反転後のカメラ位置
     */
    public func flip() -> CameraPosition {
        switch self {
        case .front:
            return .back
        case .back:
            return .front
        }
    }
    
}

extension CameraPosition: CustomStringConvertible {
    
    public var description: String {
        return descriptionTable.left(other: self)!
    }
    
}
