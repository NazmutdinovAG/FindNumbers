//
//  GameViewController.swift
//  FindNumberClone
//
//  Created by Аскар Назмутдинов on 12.03.2023.
//
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var timerLable: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    lazy var game = Game() { [weak self] status, seconds in
        guard let self = self else { return }
        self.timerLable.text = seconds.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        setupScreen()
        tableView.reloadData()
    }
    
    private func setupScreen() {
        nextDigit.text = game.nextItem
    }
    
    private func updateUI() {
        nextDigit.text = game.nextItem
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            statusLabel.text = "Game start"
            statusLabel.textColor = .black
        case .win:
            statusLabel.text = "You win"
            statusLabel.textColor = .green
            newGameButton.isHidden = false
            if game.isNewRecord {
                showAlert()
            } else {
                showAlertActionSheet()
            }
        case .lose:
            statusLabel.text = "You loose"
            statusLabel.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Congratulations!", message: "New record!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showAlertActionSheet() {
        let alert = UIAlertController(title: "What you want to do next?", message: nil, preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: "Start new game", style: .default) { [weak self] _ in
            self?.game.newGame()
            self?.setupScreen()
            self?.tableView.reloadData()
        }
        
        let showRecord = UIAlertAction(title: "See the record", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        
        let menuAction = UIAlertAction(title: "Go to the main menu", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = statusLabel
        }
        present(alert, animated: true)
    }
    

}

extension GameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        game.countItems / 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell", for: indexPath) as! ButtonsCell
        cell.prepareForReuse()
        let firstIndex = indexPath.row * cell.buttons.count
        let lastIndex = firstIndex + 2
        let numbersInCell = Array(game.items[firstIndex...lastIndex])
        cell.prepare(numbers: numbersInCell, delegate: self)
        return cell
    }
    
}

extension GameViewController: ButtonsCellDelegate {
    
    func tapped(button: UIButton) {
        guard let buttonLabel = button.titleLabel?.text else { return }
        
        let defaultbackgroundColor = button.backgroundColor
        var isFound = false
        if buttonLabel == nextDigit.text {
            isFound = true
            button.isEnabled = false
            game.numberIsFound = true
            game.check()
            print(game.items)
            updateUI()
        }
        
        UIView.animate(withDuration: 0.3) { [weak button] in
            guard let button = button else { return }
            if isFound {
                button.titleLabel?.text = ""
                button.backgroundColor = .green
                button.alpha = 0
            } else {
                button.backgroundColor = .red
            }
        } completion: { _ in
            button.backgroundColor = defaultbackgroundColor
        }
    }
    
}
    


