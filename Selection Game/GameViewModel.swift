//
//  GameViewModel.swift
//  Selection Game
//
//  Created by Dhawal Mahajan on 28/04/24.
//

import Foundation
class GameViewModel {
    var timer: Timer?
    var gridSize: Int = 0
    var cells: [Bool] = [] // True - green, False - grey
    var currentRedIndex: Int = 0
    
    var grid: Int {
        return gridSize * gridSize
    }
    func allCellsGreen() -> Bool {
           return !cells.contains(false)
       }
   @objc func changeRandomCell() {
           guard !allCellsGreen() else {
               timer?.invalidate() // Stop timer if all cells are green
               return
           }

           var newRedIndex: Int!
           repeat {
               newRedIndex = Int.random(in: 0..<cells.count)
           } while newRedIndex == currentRedIndex // Ensure different red cell

           cells[currentRedIndex] = false // Turn previous red to green
           cells[newRedIndex] = true // Make a new random cell red
           currentRedIndex = newRedIndex
//           collectionView.reloadData()
       }
     func findNewRedIndex(excluding excludedIndex: Int) -> Int {
        var newRedIndex: Int!
        repeat {
            newRedIndex = Int.random(in: 0..<cells.count)
        } while newRedIndex == excludedIndex
        return newRedIndex
    }
    
     func safeIndex(index: Int) -> Int {
        return (index >= 0 && index < cells.count) ? index : 0
    }
}
