//
//  MemoryGame.swift
//  Memory
//
//  Created by Patrick Kalkman on 15/01/2018.
//  Copyright © 2018 SimpleTechture. All rights reserved.
//

import Foundation

class MemoryGame {
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    var score = 0
    
    init(numberOfCardPairs: Int) {
        for _ in 1...numberOfCardPairs {
            let card = Card()
            cards.append(card)
            cards.append(card)
        }
        
        shuffleCards()
    }
    
    func shuffleCards() {
        for _ in cards.indices {
            let cardIndex1 = getRandomCardIndex()
            let cardIndex2 = getRandomCardIndex()
            swapCards(first: cardIndex1, with: cardIndex2)
        }
    }
    
    func swapCards(first cardIndex1: Int, with cardIndex2: Int) {
        let temporaryCard = cards[cardIndex1]
        cards[cardIndex1] = cards[cardIndex2]
        cards[cardIndex2] = temporaryCard
    }
    
    func getRandomCardIndex() -> Int {
        return Int(arc4random_uniform(UInt32(cards.count)))
    }
    
    func chooseCard(at index: Int) {
        if (!cards[index].isMatch) {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatch = true
                    cards[index].isMatch = true
                    score += 2
                } else {
                    //mark cards that they are seen
                    if (cards[matchIndex].isSeen) {
                        score -= 1
                    } else {
                        cards[matchIndex].isSeen = true
                    }
                    if (cards[index].isSeen) {
                        score -= 1
                    } else {
                        cards[index].isSeen = true
                    }
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                //either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func newGame() {
        for flipDownIndex in cards.indices {
            cards[flipDownIndex].isFaceUp = false
            cards[flipDownIndex].isMatch = false
            cards[flipDownIndex].isSeen = false
        }
        indexOfOneAndOnlyFaceUpCard = nil
        shuffleCards()
        score = 0
    }
}

struct Card {
    
    var isFaceUp = false
    var isMatch = false
    var isSeen = false
    var identifier: Int
    
    static var currentIdentifier: Int = 0
    
    static func generateIdentifier() -> Int {
        currentIdentifier += 1
        return currentIdentifier;
    }
    
    init() {
        self.identifier = Card.generateIdentifier()
    }
}
