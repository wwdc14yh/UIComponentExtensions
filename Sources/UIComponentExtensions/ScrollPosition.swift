import UIKit
import UIComponent

public extension UIScrollView {
    enum ScrollPosition {
        case top, centeredVertically, bottom, left, centeredHorizontally, right
    }

    @MainActor
    @discardableResult
    func scrollTo(_ id: String, at scrollPosition: ScrollPosition, animated: Bool) -> Bool {
        guard let idFrame = componentEngine.frame(id: id) else { return false }
        let targetRect: CGRect
        switch scrollPosition {
        case .top:
            targetRect = CGRect(origin: idFrame.origin, size: bounds.size)
        case .centeredVertically:
            let origin = CGPoint(x: idFrame.minX, y: idFrame.midY - (bounds.height / 2))
            targetRect = CGRect(origin: origin, size: CGSize(width: idFrame.width, height: bounds.height))
        case .bottom:
            targetRect = CGRect(origin: CGPoint(x: idFrame.minX, y: idFrame.maxY - bounds.height), size: CGSize(width: idFrame.width, height: bounds.height))
        case .left:
            targetRect = CGRect(origin: idFrame.origin, size: CGSize(width: bounds.width, height: idFrame.height))
        case .centeredHorizontally:
            let origin = CGPoint(x: idFrame.midX - (bounds.width / 2), y: idFrame.minY)
            targetRect = CGRect(origin: origin, size: CGSize(width: bounds.width, height: idFrame.height))
        case .right:
            targetRect = CGRect(origin: CGPoint(x: idFrame.maxX - bounds.width, y: idFrame.minY), size: CGSize(width: bounds.height, height: idFrame.height))
        }
        let offset = CGPoint(x: min(contentSize.width - adjustedSize.width, max(0, targetRect.origin.x)), y: min(contentSize.height - adjustedSize.height, targetRect.origin.y))
        setContentOffset(offset, animated: animated)
        return true
    }
}
