import Foundation
import SwiftUI
import UIKit

struct CanvasWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return Canvas()
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.backgroundColor = .clear
    }
}

class Canvas: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        paths.forEach { path in
            switch path.type {
            case .move:
                context.move(to: path.point)
                break
            case .line:
                context.addLine(to: path.point)
                break
            }
        }

        context.setLineWidth(8)
        context.setLineCap(.square)
        context.strokePath()
    }

    @Published var paths = [Path]()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        paths.append(Path(type: .move, point: point))
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        paths.append(Path(type: .line, point: point))
        setNeedsDisplay()
    }
    
    func resetPaths() {
        paths = [Path]()
    }
}

struct Path {
    let type: PathType
    let point: CGPoint

    init(type: PathType, point: CGPoint) {
        self.type = type
        self.point = point
    }

    enum PathType {
        case move
        case line
    }
}
