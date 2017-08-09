//
//  MemoryGameController.swift
//  MemoryGame
//
//  Created by Daniel Tsirulnikov on 19.3.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import Foundation
import UIKit.UIImage

// MARK: - MemoryGameDelegate

protocol MemoryGameDelegate {
    func memoryGameDidStart(_ game: MemoryGame)
    func memoryGame(_ game: MemoryGame, showCards cards: [Card])
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card])
    func memoryGameDidEnd(_ game: MemoryGame, elapsedTime: TimeInterval)
}

// MARK: - MemoryGame

class MemoryGame {
    
    // MARK: - Properties

    static var defaultCardImages:[UIImage] = [
        UIImage(named: "brand1")!,
        UIImage(named: "brand2")!,
        UIImage(named: "brand3")!,
        UIImage(named: "brand4")!,
        UIImage(named: "brand5")!,
        UIImage(named: "brand6")!,
        UIImage(named: "brand7")!,
        UIImage(named: "brand8")!
    ];

    var cards:[Card] = [Card]()
    var delegate: MemoryGameDelegate?
    var isPlaying: Bool = false

    fileprivate var cardsShown:[Card] = [Card]()
    fileprivate var startTime:Date?

    var numberOfCards: Int {
        get {
            return cards.count
        }
    }
    
    var elapsedTime : TimeInterval {
        get {
            guard startTime != nil else {
                return -1
            }
            return Date().timeIntervalSince(startTime!)
        }
    }
    
    // MARK: - Methods

    func newGame(_ cardsData:[UIImage]) {
        cards = randomCards(cardsData)
        startTime = Date.init()
        isPlaying = true
        delegate?.memoryGameDidStart(self)
    }

    func stopGame() {
        isPlaying = false
        cards.removeAll()
        cardsShown.removeAll()
        startTime = nil
    }
    
    func didSelectCard(_ card: Card?) {
        guard let card = card else { return }
        
        delegate?.memoryGame(self, showCards: [card])

        if unpairedCardShown() {
            let unpaired = unpairedCard()!
            if card.equals(unpaired) {
                cardsShown.append(card)
            } else {
                let unpairedCard = cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.memoryGame(self, hideCards:[card, unpairedCard])
                }
            }
        } else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {
            finishGame()
        }
    }
    
    func cardAtIndex(_ index: Int) -> Card? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }
    
    func indexForCard(_ card: Card) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }
    
    fileprivate func finishGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self, elapsedTime: elapsedTime)
    }

    fileprivate func unpairedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    fileprivate func unpairedCard() -> Card? {
        let unpairedCard = cardsShown.last
        return unpairedCard
    }
    
    fileprivate func randomCards(_ cardsData:[UIImage]) -> [Card] {
        var cards = [Card]()
        for i in 0...cardsData.count-1 {
            let card = Card.init(image: cardsData[i])
            cards.append(contentsOf: [card, Card.init(card: card)])
        }
        cards.shuffle()
        return cards
    }
    
}
