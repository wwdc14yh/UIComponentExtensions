// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
import UIComponent

public extension Component where R.View == UIImageView {
    func aspectFit(to targetSize: CGSize) -> AnyComponentOfView<R.View> {
        func aspectFit(orgSize: CGSize, to boundingSize: CGSize) -> CGSize {
            let minRatio = min(boundingSize.width / orgSize.width, boundingSize.height / orgSize.height)
            return CGSize(width: orgSize.width * minRatio, height: orgSize.height * minRatio)
        }
        let render = layout(Constraint(minSize: .constraintMinSize, maxSize: .constraintMaxSize))
        let size = aspectFit(orgSize: render.size, to: targetSize)
        return self.size(width: size.width, height: size.height)
            .eraseToAnyComponentOfView()
    }
}
