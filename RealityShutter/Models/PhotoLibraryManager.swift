//
//  PhotoLibraryManager.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 05/12/2022.
//

/// **
/// Written almost completely by OpenAI ChatGPT.
/// Literal magic! x9342785239457832423279
/// **

import Photos

enum PhotoLibraryManagerError: Error {
    case notAuthorized
}

extension PhotoLibraryManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return NSLocalizedString("Please grant access to the Photos library to save photos. You can change this in Settings.", comment: "Not authorized")
        }
    }
}


final class PhotoLibraryManager {
    
    private let locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    func saveImage(_ imageData: Data) async throws {
        
        let authorizationStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        
        if authorizationStatus != .authorized {
            throw PhotoLibraryManagerError.notAuthorized
        }
        
        try await PHPhotoLibrary.shared().performChanges {
            // Create a PHAssetCreationRequest object to hold the metadata for the image.
            let request = PHAssetCreationRequest.forAsset()
            
            // Set the location metadata for the image.
            if let location = self.locationManager.userLocation {
                request.location = location
                print("User location: \(location.coordinate)")
            }
            // Initiate the request.
            request.addResource(with: .photo, data: imageData, options: nil)
        }
    }
    
}
