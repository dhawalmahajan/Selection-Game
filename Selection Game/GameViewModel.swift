//
//  GameViewModel.swift
//  Selection Game
//
//  Created by Dhawal Mahajan on 28/04/24.
//

import Foundation
class GameViewModel {
    func isSquareNumber(_ number: Int) -> Bool {
        let sqrtNumber = Int(sqrt(Double(number)))
        return sqrtNumber * sqrtNumber == number
    }
    
    
}
