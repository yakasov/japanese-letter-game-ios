import SwiftUI
import UIKit

struct TracingView: View {
    @State private var isDragging = false
    private var renderer = UIGraphicsImageRenderer(
        size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5))
    private var image: UIImage = UIImage()

    init() {
        image = renderer.image { (context) in
            UIColor.darkGray.setStroke()
            context.stroke(renderer.format.bounds)
            UIColor(red: 158 / 255, green: 215 / 255, blue: 245 / 255, alpha: 1).setFill()
            context.fill(CGRect(x: 1, y: 1, width: 140, height: 140))
        }
    }

    var drag: some Gesture {
        DragGesture()
            .onChanged { _ in self.isDragging = true }
            .onEnded { _ in self.isDragging = false }
    }

    public var body: some View {
        VStack {
            ZStack {
                Image(uiImage: image)
                CanvasWrapper()
            }

        }
    }
}

#Preview {
    TracingView()
}
