import MLKit

func convertCanvasToImage(view: UIView) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    return renderer.image { ctx in
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
}

func runMLKitRecognition(canvas: Canvas) {

    NSLog("Start runMLKitRecognition")
    let uiImage = convertCanvasToImage(view: canvas)

    let image = VisionImage(image: uiImage)
    image.orientation = uiImage.imageOrientation
    let options = TextRecognizerOptions()
    let textRecognizer = TextRecognizer.textRecognizer(options: options)
    textRecognizer.process(image) { result, error in
        guard error == nil, let result = result else {
            // Error handling...
            return
        }

        // Recognized text
        print(result.self, result.description, result.blocks, result.text)
        let resultText = result.text
        print("Recognized text: \(resultText)")
    }
}
