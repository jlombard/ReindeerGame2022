//
//  PreviewViewController.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 24/11/2022.
//

import UIKit

final class PreviewViewController: UIViewController {
    
    // MARK: - UI Elements
    lazy var image = UIImage()
    private lazy var imageView = UIImageView()
    private let locationManager: LocationManager
    
    // MARK: - Object Life Cycle
    required init(image: UIImage = UIImage(), imageView: UIImageView = UIImageView(), locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.title = "Preview Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Constraints
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: margins.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = image
    }
    
    // MARK: - Methods
    @objc func saveButtonTapped() {
        let photoLibraryManager = PhotoLibraryManager(locationManager: locationManager)

        // Get the image data that you want to save to the Photos library.
        Task {
            do {
                try await photoLibraryManager.saveImage(image.pngData()!)
                presentingViewController?.dismiss(animated: true)
            } catch {
                print("Could not save to the Photos library: \(error.localizedDescription)")
                showErrorAlert(error: error)
            }
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alertController = UIAlertController(title: "Could not save to Photos", message: "\(error.localizedDescription)", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
