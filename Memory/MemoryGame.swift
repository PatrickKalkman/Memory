//
//  MemoryGame.swift
//  Memory
//
//  Created by Patrick Kalkman on 15/01/2018.
//  Copyright © 2018 SimpleTechture. All rights reserved.
//

import Foundation

class MemoryGame {
    
    private(set) var cards = [Card]()
    
    var score = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpIndices.count == 1 ? faceUpIndices.first : nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    init(numberOfCardPairs: Int) {
        assert(numberOfCardPairs > 0, "init(numberOfCardPairs: \(numberOfCardPairs)): must be greater than zero")
        for _ in 1...numberOfCardPairs {
            let card = Card()
            cards.append(card)
            cards.append(card)
        }
        
        shuffleCards()
    }
    
    private func shuffleCards() {
        for _ in cards.indices {
            let cardIndex1 = getRandomCardIndex()
            let cardIndex2 = getRandomCardIndex()
            swapCards(first: cardIndex1, with: cardIndex2)
        }
    }
    
    private func swapCards(first cardIndex1: Int, with cardIndex2: Int) {
        let temporaryCard = cards[cardIndex1]
        cards[cardIndex1] = cards[cardIndex2]
        cards[cardIndex2] = temporaryCard
    }
    
    private func getRandomCardIndex() -> Int {
        return cards.count.arc4random
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "MemoryGame.chooseCard(at: \(index)): chosen index not valid in the cards")
        if (!cards[index].isMatch) {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
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
            } else {
                //either no cards or 2 cards are face up
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

struct Card: Hashable {
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatch = false
    var isSeen = false
    private var identifier: Int
    
    private static var currentIdentifier: Int = 0
    
    private static func generateIdentifier() -> Int {
        currentIdentifier += 1
        return currentIdentifier;
    }
    
    init() {
        self.identifier = Card.generateIdentifier()
    }
}
