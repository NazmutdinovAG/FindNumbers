//
//  ButtonsCell.swift
//  FindNumber
//
//  Created by Аскар Назмутдинов on 02.04.2023.
//

import Foundation
import UIKit

protocol ButtonsCellDelegate: AnyObject {
    
    func tapped(button: UIButton)
    
}

class ButtonsCell: UITableViewCell {
    
    @IBOutlet var buttons: [UIButton]!
    
    weak var delegate: ButtonsCellDelegate?
    
    func prepare(numbers: [String], delegate: ButtonsCellDelegate) {
        self.selectionStyle = .none
        var tempArray = numbers.shuffled()
        self.delegate = delegate
        for button in buttons {
            if !tempArray.isEmpty {
                let number = tempArray.removeFirst()
                button.setTitle(number, for: .normal)
            }
            let action = UIAction { _ in delegate.tapped(button: button) }
            button.addAction(action, for: .touchUpInside)
            
        }
    }
    
    override func prepareForReuse() {
        for button in buttons {
            button.alpha = 1
            button.isEnabled = true
        }
    }
    
}

