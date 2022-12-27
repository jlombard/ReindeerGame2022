//
//  VolumeInterface.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 29/08/2022.
//

import MediaPlayer

final class Volume {
    
    class func restrainVolume(_ volume: Float) {
        switch volume {
        case 1.0:
            MPVolumeView.setVolume(0.9375)
        case 0.0:
            MPVolumeView.setVolume(0.0625)
        default:
            // Everything is fine
            break
        }
    }
}
