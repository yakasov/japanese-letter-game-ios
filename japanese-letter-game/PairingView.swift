import SwiftUI
import UIKit

class PairingStrings: ObservableObject {
    @Published public var pair1: (String, String) = ("", "")
    @Published public var pair2: (String, String) = ("", "")
    @Published public var pair3: (String, String) = ("", "")
    @Published public var pairs: [(String, String)] = [("", ""), ("", ""), ("", "")]
    @Published public var idPairings: [Int: Int] = [:]

    init() {
        buildPairs()
    }

    func buildPairs() {
        pairs = [pair1, pair2, pair3]

        for (i, _) in pairs.enumerated() {
            let p1 = getCharacterPair()
            let p2 = getCharacterPair()
            let p3 = getCharacterPair()

            pairs[i].0 = "\(p1.0)\(p2.0)\(p3.0)"
            pairs[i].1 = "\(p1.1)\(p2.1)\(p3.1)"

            idPairings[i * 2] = i * 2 + 1
            idPairings[i * 2 + 1] = i * 2
        }
    }
}

class PairingViewController: UIViewController {

    let colorList: [UIColor] = [
            UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.6, green: 1.0, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.6, green: 0.6, blue: 1.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.85, blue: 0.65, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 0.65, alpha: 1.0),
            UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        ]
    public var pairingStrings: PairingStrings = PairingStrings()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupRectangles()
    }

    func setupRectangles() {
        let ids = Array(0...5).shuffled()
        for (index, color) in colorList.enumerated() {
            let i = ids[index]
            let rectangle = DraggableRectangle(
                frame: CGRect(
                    x: getRandomOffset(), y: CGFloat(index * 100 + 50), width: 200, height: 75))
            rectangle.backgroundColor = color
            rectangle.tag = i
            rectangle.viewController = self

            let pairIndex = i / 2
            let textIndex = i % 2
            let pair = pairingStrings.pairs[pairIndex]
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 75))
            label.textAlignment = .center
            label.text = [pair.0, pair.1][textIndex]  // This is because you can't index a tuple... so it's a bit dumb
            label.font = label.font.withSize(24)
            label.textColor = .black
            label.numberOfLines = 0

            rectangle.addSubview(label)
            view.addSubview(rectangle)
        }
    }

    func getRandomOffset() -> CGFloat {
        return CGFloat(Int.random(in: 25..<175))
    }
}

class DraggableRectangle: UIView {
    weak var viewController: PairingViewController?
    var originalPosition: CGPoint?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = center
        self.alpha = 0.5
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let position = touch.location(in: superview)
        center = position
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1
        guard let superview = superview else { return }
        var overlappingRectangle: DraggableRectangle?

        for view in superview.subviews where view is DraggableRectangle && view != self {
            let rectangle = view as! DraggableRectangle
            if rectangle.frame.intersects(frame) {
                overlappingRectangle = rectangle
                break
            }
        }

        if let overlappingRectangle = overlappingRectangle,
            overlappingRectangle.tag == viewController?.pairingStrings.idPairings[tag] {
            removeFromSuperview()
            overlappingRectangle.removeFromSuperview()
        } else {
            center = originalPosition ?? center
        }

        if superview.subviews.compactMap({ $0 as? DraggableRectangle }).isEmpty {
            if let viewController = superview.next as? PairingViewController {
                viewController.pairingStrings.buildPairs()
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
