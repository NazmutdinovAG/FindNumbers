//
//  BlueViewController.swift
//  FindNumberClone
//
//  Created by Аскар Назмутдинов on 22.03.2023.
//

import UIKit

class BlueViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    var textForLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = textForLabel
    }
    

    @IBAction func goToGreenController(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let greenVC = storyboard.instantiateViewController(withIdentifier: "greenVC") as? GreenViewController {
            greenVC.textForLabel = "Text String"
            greenVC.title = "Green"
            self.navigationController?.pushViewController(greenVC, animated: true)
        }
    }
    
}
