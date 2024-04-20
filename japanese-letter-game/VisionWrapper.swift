import UIKit
import Vision

func convertCanvasToImage(view: UIView) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    return renderer.image { _ in
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
}

func runVisionRecognition(canvas: Canvas, completion: @escaping ((String?) -> Void)) {

    canvas.backgroundColor = .white
    let uiImage = convertCanvasToImage(view: canvas)
    canvas.backgroundColor = .clear
    guard let cgImage = uiImage.cgImage else { return }

    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    let request = VNRecognizeTextRequest { (request, _) in
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            print("No results:", request.results ?? "nil")
            completion(nil)
            return
        }

        let topCandidate = observations.compactMap({ $0.topCandidates(1).first?.string }).first
        completion(topCandidate)
    }

    let shouldSwap = UserDefaults.standard.bool(forKey: "swapLanguages")

    request.recognitionLevel = .accurate
    request.recognitionLanguages = shouldSwap ? ["en-US"] : ["ja-JP"]

    do {
        try requestHandler.perform([request])
    } catch {
        print("Error performing Vision request: \(error)")
    }
}
