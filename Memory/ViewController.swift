//
//  ViewController.swift
//  Memory
//
//  Created by Patrick Kalkman on 15/01/2018.
//  Copyright © 2018 SimpleTechture. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private lazy var memoryGame = MemoryGame(numberOfCardPairs: (cardButtons.count + 1) / 2)
    private var randomThemeIndex = 0;
    
    @IBAction private func flipCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            memoryGame.chooseCard(at: cardNumber)
            updateViewFromModel()
            updateScoreLabel()
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(memoryGame.score)"
    }
    
    override func viewDidLoad() {
        newGame()
    }
    
    @IBAction private func newGame() {
        memoryGame.newGame()
        updateViewFromModel()
        emoji = [Card:String]()
        randomThemeIndex = emojiThemes.count.arc4random
        if let theme = emojiThemes[randomThemeIndex] {
            currentEmojiTheme = theme
        } else {
            currentEmojiTheme = [String]()
        }
        updateScoreLabel()
    }
    
    private func updateViewFromModel() {
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
    
    private var emojiThemes =
        [0: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸", "🏒", "🏏"],
         1: ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑"],
         2: ["😍", "😂", "😜", "😎", "😇", "😤", "🤩", "😡", "🙄", "😈", "👹", "🤡"],
         3: ["👌🏻", "👏🏽", "💪🏻", "👋🏼", "✊🏿", "👇", "🤟🏻", "👎🏾", "🤜🏻", "🙏", "👌🏻", "☝🏾"],
         4: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🚚", "🚜"],
         5: ["🇦🇽", "🇦🇹", "🇧🇹", "🇮🇴", "🇧🇧", "🇨🇦", "🇯🇵", "🇵🇷", "🇧🇱", "🇱🇨", "🇵🇳", "🇭🇺"],
         6: ["♚", "♛", "♜", "♝", "♞", "♟", "♠︎", "♣︎", "♥︎", "♦︎", "⚅", "★", "⚂", "⚧"]]
    
    private var currentEmojiTheme = [String]()
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, currentEmojiTheme.count > 0 {
            emoji[card] = currentEmojiTheme.remove(at: currentEmojiTheme.count.arc4random)
        }
        if let selectedEmoji = emoji[card] {
            return selectedEmoji
        }
        return "?"
    }
}



