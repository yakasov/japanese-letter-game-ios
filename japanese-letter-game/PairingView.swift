import SwiftUI
import UIKit

class PairingViewController: UIViewController {

    let colorList: [UIColor] = [.red, .green, .blue, .orange, .yellow, .purple]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupRectangles()
    }

    func setupRectangles() {
        for (index, color) in colorList.enumerated() {
            let rectangle = DraggableRectangle(
                frame: CGRect(
                    x: getRandomOffset(), y: CGFloat(index * 100 + 50), width: 200, height: 75))
            rectangle.backgroundColor = color
            rectangle.tag = index
            view.addSubview(rectangle)
        }
    }

    func getRandomOffset() -> CGFloat {
        return CGFloat(Int.random(in: 50..<150))
    }
}

class DraggableRectangle: UIView {
    var originalPosition: CGPoint?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = center
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let position = touch.location(in: superview)
        center = position
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let superview = superview else { return }
        var overlappingRectangle: DraggableRectangle?

        for view in superview.subviews where view is DraggableRectangle && view != self {
            let rectangle = view as! DraggableRectangle
            if rectangle.frame.intersects(frame) {
                overlappingRectangle = rectangle
                break
            }
        }

        if let overlappingRectangle = overlappingRectangle, overlappingRectangle.tag != tag {
            removeFromSuperview()
            overlappingRectangle.removeFromSuperview()
        } else {
            center = originalPosition ?? center
        }

        if superview.subviews.compactMap({ $0 as? DraggableRectangle }).isEmpty {
            if let viewController = superview.next as? PairingViewController {
                viewController.setupRectangles()
            }
        }
    }
}

struct PairingView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PairingViewController {
        return PairingViewController()
    }

    func updateUIViewController(_ uiViewController: PairingViewController, context: Context) {}
}

#Preview {
    PairingViewController()
}
