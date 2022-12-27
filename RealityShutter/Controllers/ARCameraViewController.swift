//
//  MainViewController.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 01/06/2022.
//

import UIKit
import ARKit
import RealityKit
import MediaPlayer

final class ARCameraViewController: UIViewController {
    
    // MARK: - Type Aliases
    // typealias ReindeerGameCameraLoadAsync<T: HasAnchoring> = (@escaping (Result<T, any Error>) -> Void) -> ()
    
    // MARK: - UI Elements
    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var coachingOverlay: ARCoachingOverlayView! 
    @IBOutlet weak var shutterButton: UIButton!
    
    private lazy var shutterView = ShutterView()
    private lazy var imageProcessor = ImageProcessing()
    
    // MARK: - Properties
    var character = Character()
    
    private var kvoToken: NSKeyValueObservation?
    private var countdownTimer: Timer?
    private let locationManager = LocationManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add coaching overlay
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        
        // Detect volume button presses (volume change)
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
        
        observeVolume(audioSession: audioSession)
        
        // Create shutter view
        view.addSubview(shutterView)
        shutterView.translatesAutoresizingMaskIntoConstraints = false
        
        // Enable people occlusion (without depth)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]

        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        } else {
            print("This device doesn't support person segmentation with depth")
        }
        
        arView.session.run(config)
        
        // Add scene entity
        switch character.sceneName {
        case "Blossom":
            ReindeerGameV2.loadBlossomAsync(completion: addEntityAnchor)
        case "Clover":
            ReindeerGameV2.loadCloverAsync(completion: addEntityAnchor)
        case "Papa Deer":
            ReindeerGameV2.loadPapaDeerAsync(completion: addEntityAnchor)
        case "Fall":
            ReindeerGameV2.loadFallAsync(completion: addEntityAnchor)
        case "Winter":
            ReindeerGameV2.loadWinterAsync(completion: addEntityAnchor)
        default:
            break
        }
        
        // Enable repositioning and scale gestures
        // arView.installGestures([.rotation, .translation], for: anchor.reindeer as! HasCollision)
        
        // Prepare location data
        locationManager.requestLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            shutterView.topAnchor.constraint(equalTo: view.topAnchor),
            shutterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shutterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shutterView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @IBAction func shutterButtonTapped(_ sender: UIButton) {
        countDownForPhoto()
    }
    
    // MARK: - Methods
    // MARK: Volume
    // Observe AVAudioSession.shared.outputVolume
    private func observeVolume(audioSession: AVAudioSession) {
        kvoToken = audioSession.observe(\.outputVolume, options: .new) { [weak self] (session, change) in
            guard let volume = change.newValue else { return }
            Volume.restrainVolume(volume)
            print("New volume is: \(volume)")
            self!.countDownForPhoto()
        }
    }
    
    func addEntityAnchor<T: Entity & HasAnchoring>(result: Result<T, Error>) {
        do {
            // Initialize entity
            let scene = try result.get()
            // Add entity anchor to scene
            arView.scene.anchors.append(scene)
            // ...
        } catch {
            // handle error
            fatalError("Could not add entity anchor to scene: \(error.localizedDescription)")
        }
    }
    
    // MARK: Photo-Taking
    private func saveSnapshot() {
        /// Save snapshot to Camera Roll
        /// No need to capture self at all! Yay, async Swift!
        shutterView.flash()
        
        Task {
            let image = await arView.snapshot(saveToHDR: false)
            guard let image = image else { return }
            
            let processedImage = await self.imageProcessor.process(image)
            
            let previewViewController = PreviewViewController(locationManager: locationManager)
            previewViewController.image = processedImage
            let navigationController = UINavigationController(rootViewController: previewViewController)
            present(navigationController, animated: true)
        }
    }
    
    private func countDownForPhoto(seconds: Int = 3) {
        var remainingRuns = seconds
        shutterView.setCountdownLabel(remainingRuns)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            
            print("Countdown timer: \(remainingRuns) seconds")
            remainingRuns -= 1
            self?.shutterView.setCountdownLabel(remainingRuns)
            
            // Takes photo.
            if remainingRuns == 0 {
                self?.saveSnapshot()
                timer.invalidate()
                return
            }
        }
    }
}
