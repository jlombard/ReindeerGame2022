//
//  Utilities.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 01/06/2022.
//

import MediaPlayer
import UIKit

// MARK: - MPVolumeView extensions

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}

