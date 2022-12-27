//
//  ARViewExtension.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 15/09/2022.
//

import RealityKit

extension ARView {
    
    func snapshot(saveToHDR: Bool) async -> ARView.Image? {
        return await withCheckedContinuation { continuation in
            snapshot(saveToHDR: saveToHDR) { image in
                continuation.resume(returning: image)
            }
        }
    }
}
