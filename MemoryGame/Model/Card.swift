//
//  Card.swift
//  MemoryGame
//
//  Created by Vishwas Mukund on 8/8/2017.
//  
//

import Foundation
import UIKit.UIImage

class Card : CustomStringConvertible {
    
    // MARK: - Properties

    var id:UUID = UUID.init()
    var shown:Bool = false
    var image:UIImage

    // MARK: - Lifecycle

    init(image:UIImage) {
        self.image = image
    }
    
    init(card:Card) {
        self.id = (card.id as NSUUID).copy() as! UUID
        self.shown = card.shown
        self.image = card.image.copy() as! UIImage
    }
    
    // MARK: - Methods

    var description: String {
        return "\(id.uuidString)"
    }
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
}
