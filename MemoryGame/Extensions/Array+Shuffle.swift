//
//  Array+Shuffle.swift
//  MemoryGame
//
//  Created by Vishwas Mukund on 8/8/2017.
//  
//

import Foundation

extension Array {
    //Randomizes the order of the array elements
    mutating func shuffle() {
        for _ in 1...self.count {
            self.sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
