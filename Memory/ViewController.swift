//
//  ViewController.swift
//  Memory
//
//  Created by Patrick Kalkman on 15/01/2018.
//  Copyright © 2018 SimpleTechture. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    lazy var memoryGame = MemoryGame(numberOfCardPairs: (cardButtons.count + 1) / 2)
    var randomThemeIndex = 0;
    
    @IBAction func flipCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            memoryGame.chooseCard(at: cardNumber)
            updateViewFromModel()
            updateScore()
        }
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(memoryGame.score)"
    }
    
    override func viewDidLoad() {
        newGame()
    }
    
    @IBAction func newGame() {
        memoryGame.newGame()
        updateViewFromModel()
        emoji = [Int:String]()
        randomThemeIndex = Int(arc4random_uniform(UInt32(emojiThemes.count)))
        if let theme = emojiThemes[randomThemeIndex] {
            currentEmojiTheme = theme
        } else {
            currentEmojiTheme = [String]()
        }
        updateScore()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = memoryGame.cards[index]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                button.setTitle(emoji(for: card), for: UIControlState.normal)
            } else {
                button.backgroundColor = card.isMatch ? #colorLiteral(red: 1, green: 0.5768225789, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                button.setTitle("", for: UIControlState.normal)
            }
        }
    }
    
    var emojiThemes = [0: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸", "🏒", "🏏"],
                       1: ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑"],
                       2: ["😍", "😂", "😜", "😎", "😇", "😤", "🤩", "😡", "🙄", "😈", "👹", "🤡"],
                       3: ["👌🏻", "👏🏽", "💪🏻", "👋🏼", "✊🏿", "👇", "🤟🏻", "👎🏾", "🤜🏻", "🙏", "👌🏻", "☝🏾"],
                       4: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🚚", "🚜"],
                       5: ["🇦🇽", "🇦🇹", "🇧🇹", "🇮🇴", "🇧🇧", "🇨🇦", "🇯🇵", "🇵🇷", "🇧🇱", "🇱🇨", "🇵🇳", "🇭🇺"],
                       6: ["♚", "♛", "♜", "♝", "♞", "♟", "♠︎", "♣︎", "♥︎", "♦︎", "⚅", "★", "⚂", "⚧"]]
    
    var currentEmojiTheme = [String]()
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, currentEmojiTheme.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(currentEmojiTheme.count)))
            emoji[card.identifier] = currentEmojiTheme.remove(at: randomIndex)
        }
        if let selectedEmoji = emoji[card.identifier] {
            return selectedEmoji
        }
        return "?"
    }
}

