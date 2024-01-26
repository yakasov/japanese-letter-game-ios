import Foundation
import SwiftUI
import UIKit

struct CanvasWrapper: UIViewRepresentable {
    @Binding var canvas: Canvas
    
    func makeUIView(context: Context) -> UIView {
        return canvas
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.backgroundColor = .clear
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CanvasWrapper

        init(_ parent: CanvasWrapper) {
            self.parent = parent
        }
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
    public var onTouchesBegan: (() -> Void)?
    public var onTouchesEnded: (() -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        paths.append(Path(type: .move, point: point))
        setNeedsDisplay()
        
        onTouchesBegan?()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        paths.append(Path(type: .line, point: point))
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        onTouchesEnded?()
    }
    
    func resetPaths() {
        paths = [Path]()
        setNeedsDisplay()
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
