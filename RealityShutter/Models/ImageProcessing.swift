//
//  StyleTransfer.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 24/08/2022.
//

import CoreML
import UIKit

final class ImageProcessing {
    
    // MARK: - Properties
    private let styleTransferSize = CGSize(width: 512, height: 512)
    private let ciContext = CIContext()
    
    // MARK: - Class Functions
    /// Performs all the desired image processing operations.
    func process(_ inputImage: UIImage) async -> UIImage {
        
        let frameImage = UIImage(named: "frame")!
        let blendBackground = UIImage(named: "blend-background")!
        
        let shrunkImage = scale(inputImage, to: styleTransferSize)
        let styledImage = await applyStyleTransfer(shrunkImage)!
        //let styledImage = shrunkImage.ciImage
        
        let blendedImage = blendImages(mode: "CILightenBlendMode", background: styledImage, foreground: blendBackground.ciImage!)!
        let framedImage = blendImages(mode: "CISourceOverCompositing", background: blendedImage, foreground: frameImage.ciImage!)!
        
        
        let aspectRatio = calculateStretchAspectRatio(inputImage)
        let stretchedImage = bicubicScale(framedImage, aspectRatio: aspectRatio)!
        
        let cgImage = ciContext.createCGImage(stretchedImage, from: stretchedImage.extent)!
        let uiImage = UIImage(cgImage: cgImage)
        
        return uiImage
    }
    
    /// Crops a given image to a square. The square is centered to the image, and has a side length equal to the shortest side of the original image.
    func cropToCenter(_ inputImage: UIImage, aspectRatio: Double) -> UIImage {
        let image = inputImage.cgImage!
        
        let refWidth = CGFloat((image.width))
        let refHeight = CGFloat((image.height))
        
        let shortEdge = refWidth > refHeight ? refHeight : refWidth
        let longEdge = shortEdge * aspectRatio
        
        let x = (refWidth - shortEdge) / 2.0
        let y = (refHeight - shortEdge) / 2.0
        
        let cropRect = CGRect(x: x, y: y, width: shortEdge, height: longEdge)
        let imageRef = image.cropping(to: cropRect)!
        let cropped = UIImage(cgImage: imageRef)
        
        return cropped
    }
    
    /// Scales a given image to a given size.
    /// Uses UIGraphicsImageRenderer instead of Core Image due to performance reasons.
    func scale(_ image: UIImage, to size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// Applies a Core Image blend filter.
    /// - Parameters:
    ///     - name: The name of the blend filter.
    func blendImages(mode: String, background: CIImage, foreground: CIImage) -> CIImage? {
        /// Auto-scales the foreground image to the same size as the background.
        /// Requires us to convert CGImage to UIImage (and back), since doing it with CIIImage methods (paradoxically) results in significantly lower performance.
        let renderedForeground = UIImage(cgImage: ciContext.createCGImage(foreground, from: foreground.extent)!)
        let scaledForeground = scale(renderedForeground, to: background.extent.size).ciImage
        
        let blendFilter = CIFilter(name: mode)
        blendFilter?.setValue(scaledForeground, forKey: kCIInputImageKey)
        blendFilter?.setValue(background, forKey: kCIInputBackgroundImageKey)
        return blendFilter?.outputImage
    }
    
    func calculateStretchAspectRatio(_ image: UIImage) -> Double {
        let width = image.size.width
        let height = image.size.height
        
        return width / height
    }
    
    /// Applies the Core Image bicubic scale filter.
    /// - Parameters:
    ///     - _ inputImage: The image to apply the filter.
    ///     - aspectRatio: The additional horizontal scaling factor to use on the image.
    func bicubicScale(_ inputImage: CIImage, aspectRatio: Double) -> CIImage? {
        let scaleFilter = CIFilter(name: "CIBicubicScaleTransform")
        
        scaleFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        scaleFilter?.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        scaleFilter?.setValue(0.5, forKey: "inputB")
        scaleFilter?.setValue(0.5, forKey: "inputC")
        scaleFilter?.setValue(3, forKey: "inputScale")
        
        return scaleFilter?.outputImage
    }
    
    /// Applies a specified Core ML style transfer.
    func applyStyleTransfer(_ inputImage: UIImage) async -> CIImage? {
        let configuration = MLModelConfiguration()
        
        /// The style transfer model is initialized here. To use a different style, change the type of this initializer.
        guard let model = try? JohnWhite(configuration: configuration) else { return nil }
        
        let styleArray = try? MLMultiArray(shape: [1] as [NSNumber], dataType: .double)
        styleArray?[0] = 1.0
        
        // let scaledImage = scale(inputImage, targetSize: CGSize(width: 512, height: 512))
        
        if let pixelBuffer = inputImage.pixelBuffer(size: 512) {
            do {
                let predictionOutput = try model.prediction(image: pixelBuffer)
                let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
                
                print("Style transfer applied.")
                return ciImage
            } catch let error as NSError {
                print("CoreML Model Error: \(error)")
            }
        }
        // In case of an error
        return nil
    }
}
