//
//  StoryViewController.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 25/12/2022.
//

import UIKit

class StoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func readViewTapped(_ sender: Any) {
        if let url = URL(string: "https://books.apple.com/us/book/reindeer-games/id6444491052") {
            UIApplication.shared.open(url)
        }
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
