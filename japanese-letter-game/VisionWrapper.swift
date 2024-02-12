import UIKit
import Vision

//func convertCanvasToImage(view: UIView) -> UIImage {
//    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
//    return renderer.image { ctx in
//        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//    }
//}

func runVisionRecognition(canvas: Canvas) {

    NSLog("Start runVisionRecognition")
    let uiImage = convertCanvasToImage(view: canvas)
    guard let cgImage = uiImage.cgImage else { return }

    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["en-US", "ja-JP"]
    request.usesLanguageCorrection = true
    
    do {
        try requestHandler.perform([request])
    } catch {
        print("Error performing Vision request: \(error)")
    }
}

func recognizeTextHandler(request: VNRequest, error: Error?) {
    guard let observations = request.results as? [VNRecognizedTextObservation] else {
        print("No results:", request.results ?? "nil")
        return
    }
    
    for observation in observations {
        print("Observation:", observation)
        let candidate = observation.topCandidates(1).first
        print("Top candidate: \(candidate?.string ?? "nil") with confidence \(candidate?.confidence ?? 0)")
    }
}
