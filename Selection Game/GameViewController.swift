//
//  GameViewController.swift
//  Selection Game
//
//  Created by Dhawal Mahajan on 28/04/24.
//

import UIKit
import SwiftUI

class GameViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionData: [[UIColor]] = []
    var redCellIndexPath: IndexPath?
    var gameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        
        // Do any additional setup after loading the view.
    }
    
    func isSquareNumber(_ number: Int) -> Bool {
        let sqrtNumber = Int(sqrt(Double(number)))
        return sqrtNumber * sqrtNumber == number
    }
    
    func generateRandomRedCell() -> IndexPath {
        var randomIndexPath: IndexPath
        repeat {
            let randomRow = Int.random(in: 0..<collectionData.count)
            let randomCol = Int.random(in: 0..<collectionData[0].count)
            randomIndexPath = IndexPath(row: randomCol, section: randomRow)
            print("Function: \(#function), line: \(#line)",randomIndexPath)
        }while /*randomIndexPath == redCellIndexPath*/  collectionData[randomIndexPath.section][randomIndexPath.row] == .green
       
        
        redCellIndexPath = randomIndexPath
        collectionData[randomIndexPath.section][randomIndexPath.row] = .red
        return randomIndexPath
    }
    
   
    
    func checkGameStatus() {
        if collectionData.allSatisfy({ $0.allSatisfy({ $0 == .green }) }) {
            gameOver = true
            let alertController = UIAlertController(title: "Game Over!", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let inputText = numberTextField.text, let number = Int(inputText), !inputText.isEmpty else {
            showAlert(message: "Please enter a valid perfect square number.")
            return
        }
        
        if !isSquareNumber(number) {
            showAlert(message: "Please enter a valid perfect square number.")
            return
        }
        
        let gridSize = Int(sqrt(Double(number)))
        collectionData = Array(repeating: Array(repeating: UIColor.gray, count: gridSize), count: gridSize)
        
        redCellIndexPath = nil
        gameOver = false
        let _ = generateRandomRedCell()
        updateCollectionView()
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell()}
        cell.backgroundColor = collectionData[indexPath.section][indexPath.row]
//        if indexPath == redCellIndexPath {
//            cell.backgroundColor = .red
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !gameOver else { return }
        
        if indexPath == redCellIndexPath {
            collectionData[indexPath.section][indexPath.row] = .green
            collectionView.reloadItems(at: [indexPath])
            checkGameStatus()
            if !gameOver {
                let index = generateRandomRedCell()
                collectionView.reloadItems(at: [index])
            }
        }
        
        
    }
}
