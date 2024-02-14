import MLKit
import SwiftUI

func convertCanvasToImage(view: UIView) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    return renderer.image { ctx in
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
}

func convertToBase64(image: UIImage) -> String {
  return image.jpegData(compressionQuality: 0.2)!.base64EncodedString()
}

func runMLKitRecognition(canvas: Canvas) {

    NSLog("Start runMLKitRecognition")
    // let renderer = ImageRenderer(content: canvas)
    // let uiImage = renderer.uiImage
//    let uiImage = canvas.frame(width: 300, height: 300).snapshot()
    // let uiImage = convertCanvasToImage(view: canvas)
    // let uiImage : UIImage = UIImage(named: "IMG_4747")!
    let uiImage = canvas.toImage()!
    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)

    let image = VisionImage(image: canvas.toImage()!)
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
