//
//  GreenViewController.swift
//  FindNumberClone
//
//  Created by Аскар Назмутдинов on 22.03.2023.
//

import UIKit

class GreenViewController: UIViewController {

    var textForLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func goToMainMenu() {
        //self.navigationController?.popToRootViewController(animated: true)
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc is YellowViewController {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }
}
