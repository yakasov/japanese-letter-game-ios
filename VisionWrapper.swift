import UIKit
import Vision

func convertCanvasToImage(view: UIView) -> UIImage {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

func runVisionRecognition(canvas: Canvas) {
    NSLog("Start runVisionRecognition")
    let uiImage = convertCanvasToImage(view: canvas)
    guard let cgImage = uiImage.cgImage else { return }

    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
    request.recognitionLevel = .accurate
    request.minimumTextHeight = 0.2
    
    do {
        try requestHandler.perform([request])
    } catch {
        NSLog("Uh oh! \(error).")
    }

    // request.recognitionLevel = VNRequestTextRecognitionLevel.fast
    // request.recognitionLanguages = ["en-US"]
}

func recognizeTextHandler(request: VNRequest, error: Error?) {
    guard let observations =
            request.results as? [VNRecognizedTextObservation] else {
        NSLog("Whoops, observations like \(request.results)")
        return
    }
    let recognizedStrings = observations.compactMap { observation in
        return observation.topCandidates(1).first?.string
    }
    
    NSLog("Observation: \(observations)")
    NSLog("Recognised Strings: \(recognizedStrings)")
}

