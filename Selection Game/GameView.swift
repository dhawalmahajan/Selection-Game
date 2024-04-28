//
//  GameView.swift
//  Selection Game
//
//  Created by Dhawal Mahajan on 28/04/24.
//

import SwiftUI

struct GameView: View {
    
    @State private var userInput: String = ""
    @State private var showAlert: Bool = false
    @State private var collection: [[Cell]] = []
    @State private var gameOver: Bool = false
    
    struct Cell {
        var color: Color
    }
    
    init() {
        collection = Array(repeating: Array(repeating: Cell(color: .gray), count: 3), count: 3)
    }
    
    func isSquareNumber(_ number: Int) -> Bool {
        let sqrtNumber = Int(sqrt(Double(number)))
        return sqrtNumber * sqrtNumber == number
    }
    
    func generateRandomRedCell() {
        let randomRow = Int.random(in: 0..<3)
        let randomCol = Int.random(in: 0..<3)
        collection[randomRow][randomCol].color = .red
    }
    
    func cellTapped(row: Int, col: Int) {
        if collection[row][col].color == .red {
            collection[row][col].color = .green
            generateRandomRedCell()
            if collection.allSatisfy({ row in row.allSatisfy({ cell in cell.color == .green }) }) {
                gameOver = true
            }
        }
    }
    
    
    var body: some View {
        VStack {
            TextField("Enter a perfect square number", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)
            
            Button("Submit") {
                guard let number = Int(userInput), !userInput.isEmpty else {
                    showAlert = true
                    return
                }
                
                if !isSquareNumber(number) {
                    showAlert = true
                    return
                }
                
                collection = Array(repeating: Array(repeating: Cell(color: .gray), count: 3), count: 3)
                generateRandomRedCell()
            }
            
            if gameOver {
                Text("Game Over!")
                    .font(.title)
                    .foregroundColor(.red)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                    ForEach(0..<3) { row in
                        ForEach(0..<3) { col in
                            Rectangle()
                                .fill(collection[row][col].color)
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                    cellTapped(row: row, col: col)
                                }
                        }
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Input"), message: Text("Please enter a perfect square number"), dismissButton: .default(Text("OK")))
        }
    }
    
}

#Preview {
    GameView()
}
