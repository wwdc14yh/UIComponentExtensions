import UIKit
import UIComponent

public extension ComponentEngine {
    @MainActor
    func findView<T: UIView>(_ path: String) -> T? {
        return findView([path])
    }

    @MainActor
    func findView<T: UIView>(_ paths: [String]) -> T? {
        var value: T?
        guard !paths.isEmpty else { return nil }
        func findNext(_ index: Int, nextEngine: ComponentEngine) {
            if index == paths.count - 1 {
                value = nextEngine.visibleView(id: paths[index]) as? T
                return
            }
            guard let _nextRootView = nextEngine.visibleView(id: paths[index]) else {
                return
            }
            let componentEngine: ComponentEngine
            if let nextRootView = nextEngine.visibleView(id: paths[index]) as? ComponentDisplayableView {
                componentEngine = nextRootView.componentEngine
            } else if let nextRootView = nextEngine.visibleView(id: paths[index]), let view = nextRootView.subviews.compactMap({ $0 as? ComponentDisplayableView }).first {
                componentEngine = view.componentEngine
            } else {
                componentEngine = _nextRootView.componentEngine
            }
            findNext(index + 1, nextEngine: componentEngine)
        }
        findNext(0, nextEngine: self)
        return value
    }
}
