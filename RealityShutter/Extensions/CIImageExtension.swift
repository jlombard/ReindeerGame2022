//
//  CIImageExtension.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 25/09/2022.
//

import CoreImage

extension CIImage {
    
    private func pixelBuffer(context: CIContext) -> CVPixelBuffer? {
        // based on https://stackoverflow.com/questions/54354138/how-can-you-make-a-cvpixelbuffer-directly-from-a-ciimage-instead-of-a-uiimage-in
        
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferWidthKey: Int(extent.width),
            kCVPixelBufferHeightKey: Int(extent.height)
        ] as CFDictionary
        
        var pixelBuffer : CVPixelBuffer?
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(extent.width),
                                         Int(extent.height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs, &pixelBuffer)
        
        guard (status == kCVReturnSuccess) else {
            print(status)
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        context.render(self, to: pixelBuffer!)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
