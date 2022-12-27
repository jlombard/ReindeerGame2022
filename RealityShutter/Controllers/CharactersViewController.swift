//
//  CharactersViewController.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 21/12/2022.
//

import UIKit

final class CharactersViewController: UIViewController {
    
    private let characters = [
        Character(name: "Blossom", image: #imageLiteral(resourceName: "Blossom")),
        Character(name: "Clover", image: #imageLiteral(resourceName: "clover")),
        Character(name: "Papa Deer", image: #imageLiteral(resourceName: "Papa Deer")),
        Character(name: "Fall", image: #imageLiteral(resourceName: "Fall")),
        Character(name: "Winter", image: #imageLiteral(resourceName: "Winter"))
    ]
    
    @IBInspectable var cellsDisplayed: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

extension CharactersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsDisplayed == 0 ? characters.count : cellsDisplayed
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let character = characters[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as? CharacterCollectionViewCell {
            cell.imageView.image = character.image
            cell.titleLabel.text = character.name
            return cell
        } else {
            fatalError("Could not dequeue reusable cell: check if the identifier string is correct.")
        }
    }
}

extension CharactersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = characters[indexPath.row]
        
        var cameraViewController: ARCameraViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ARCameraViewController") as! ARCameraViewController
            viewController.character = selectedCharacter
            return viewController
        }
        
        navigationController?.pushViewController(cameraViewController, animated: true)
        // present(cameraViewController, animated: true)
    }
}
