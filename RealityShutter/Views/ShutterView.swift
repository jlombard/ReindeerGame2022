//
//  ShutterView.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 02/06/2022.
//

import UIKit

final class ShutterView: UIView {
    /// A superview that hosts all the user interface elements displayed on top of the ARView.
    /// Includes a shutter button, a countdown label and a flashing view.
    
    // MARK: - UI Elements
    private lazy var counterLabel = UILabel()
    
    // MARK: - Initialization
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        addSubview(counterLabel)
        counterLabel.textColor = .white
        counterLabel.textAlignment = .center
        counterLabel.font = .systemFont(ofSize: 150, weight: .medium)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Methods
    
    func flash() {
        backgroundColor = .white
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       options: .curveEaseOut) { [weak self] in
            self?.backgroundColor = .clear
        }
    }
    
    func setCountdownLabel(_ count: Int) {
        counterLabel.text = "\(count)"
        
        if count == 0 {
            counterLabel.text = ""
        }
    }
}
