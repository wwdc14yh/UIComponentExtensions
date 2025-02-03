import UIKit
import UIComponent

private nonisolated(unsafe) var alphaStore = NSMapTable<UIView, NSNumber>(keyOptions: .weakMemory,
                                                                          valueOptions: .strongMemory)
private nonisolated(unsafe) var backupBackgroundColorStore = NSMapTable<UIView, UIColor>(keyOptions: .weakMemory,
                                                                                         valueOptions: .strongMemory)

public extension TappableViewConfig {
    static var none: TappableViewConfig { .init() }

    @MainActor
    static func rubberScale(_ minimumScale: CGFloat = 0.9) -> TappableViewConfig {
        TappableViewConfig { view, isHighlighted in
            let scale: CGFloat = isHighlighted ? minimumScale : 1.0
            let propertyAnimator = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.6)
            propertyAnimator.addAnimations {
                view.transform = .identity.scaledBy(x: scale, y: scale)
            }
            propertyAnimator.startAnimation()
        }
    }

    private static func minAlpha(_ targetAlpha: CGFloat) -> CGFloat {
        max(0.6, targetAlpha)
    }

    @MainActor
    static func translucent() -> TappableViewConfig {
        TappableViewConfig(onHighlightChanged: { view, isHighlighted in
            let originalAlpha = alphaStore.object(forKey: view)?.doubleValue ?? view.alpha
            if alphaStore.object(forKey: view) == nil {
                alphaStore.setObject(NSNumber(value: originalAlpha), forKey: view)
            }
            let alpha: CGFloat = isHighlighted ? minAlpha(originalAlpha - 0.2) : originalAlpha
            UIView.animate(withDuration: 0.25) {
                view.alpha = alpha
            } completion: { completion in
                if completion, !isHighlighted {
                    alphaStore.removeObject(forKey: view)
                }
            }
        })
    }

    @MainActor
    static func fillHighlightedColor(_ highlightedColor: UIColor) -> TappableViewConfig {
        TappableViewConfig(onHighlightChanged: { view, isHighlighted in
            if isHighlighted, let backgroundColor = view.backgroundColor {
                backupBackgroundColorStore.setObject(backgroundColor, forKey: view)
            }
            let backupBackgroundColor: UIColor? = backupBackgroundColorStore.object(forKey: view)
            let color = isHighlighted ? highlightedColor : backupBackgroundColor
            UIView.animate(withDuration: 0.25) {
                view.backgroundColor = color
            } completion: { completion in
                if completion, !isHighlighted {
                    backupBackgroundColorStore.removeObject(forKey: view)
                }
            }
        })
    }
}

