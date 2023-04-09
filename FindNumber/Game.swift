//
//  Game.swift
//  FindNumberClone
//
//  Created by Аскар Назмутдинов on 12.03.2023.
//

import Foundation

enum StatusGame {
    case start
    case win
    case lose
}

class Game {
    
    var item: String = ""
    
    private var data = Array(1...99)
    
    var items: [String] = []
    
    var nextItem: String?
    
    var numberIsFound = false
    
    var isNewRecord = false
    
    var status: StatusGame = .start {
        didSet {
            if status != .start {
                if status == .win {
                    let newRecord = timeForGame - secondsGame
                    
                    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
                    
                    if record == 0 || newRecord < record{
                        UserDefaults.standard.set(newRecord, forKey: KeysUserDefaults.recordGame)
                        isNewRecord = true
                    }
                    
                }
                stopGame()
            }
        }
    }
    
    private var timeForGame: Int
    
    private var secondsGame: Int {
        didSet {
            if secondsGame == 0 {
                status = .lose
            }
            updateTime(status,secondsGame)
        }
    }
    
    private var timer: Timer?
    
    private var updateTime: ((StatusGame, Int) -> ())
    
    let countItems = 15
    
    init(updateTimer: @escaping (_ status: StatusGame, _ seconds: Int) -> ()) {
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.secondsGame = self.timeForGame
        self.updateTime = updateTimer
        setupGame()
    }
    
    private func setupGame() {
        isNewRecord = false
        var digits = data.shuffled()
        items.removeAll()
        while items.count < countItems {
            let item = String(digits.removeFirst())
            items.append(item)
        }
        nextItem = items.first
        
        if Settings.shared.currentSettings.timerState {
            timer = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                self?.secondsGame -= 1
            })
        }
        updateTime(status,secondsGame)
    }
    
    func newGame() {
        status = .start
        self.secondsGame = self.timeForGame
        setupGame()
    }
    
    func check() {
        guard status == .start else { return }
        if numberIsFound {
            items.removeFirst()
            items = items.shuffled()
            nextItem = items.first
            numberIsFound = false
        }
        if items.isEmpty {
            status = .win
        }
    }
    
    func stopGame() {
        timer?.invalidate()
    }
    
}

extension Int {
    func secondsToString() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
