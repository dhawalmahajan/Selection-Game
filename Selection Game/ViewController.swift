//
//  ViewController.swift
//  Selection Game
//
//  Created by Dhawal Mahajan on 28/04/24.
//

import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    let vm = GameViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        startTimer()

//        submitButton.isEnabled = false // Initially disabled
        collectionView.isHidden = true // Initially hidden
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    func startTimer() {
        vm.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(changeRandomCell), userInfo: nil, repeats: true)
        }
    
    @objc func didTapSubmit() {
        guard let text = numberTextField.text, !text.isEmpty else {
            showAlert(message: "Please enter a number")
            return
        }
        
        guard let number = Int(text) else {
            showAlert(message: "Please enter a valid number")
            return
        }
        
        // Check if square root is available
        let sqrt = Int(sqrt(Double(number)))
        if sqrt * sqrt != number {
            showAlert(message: "Please enter a number whose square root is available")
            return
        }
        
        vm.gridSize = sqrt
        setupGridView()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    @objc func changeRandomCell() {
        guard !vm.allCellsGreen() else {
            vm.timer?.invalidate() // Stop timer if all cells are green
               return
           }

           var newRedIndex: Int!
           repeat {
               newRedIndex = Int.random(in: 0..<vm.cells.count)
           } while newRedIndex == vm.currentRedIndex // Ensure different red cell

        vm.cells[vm.currentRedIndex] = false // Turn previous red to green
        vm.cells[newRedIndex] = true // Make a new random cell red
        vm.currentRedIndex = newRedIndex
           collectionView.reloadData()
       }

    func setupGridView() {
        vm.cells = Array(repeating: false, count: vm.grid)
        vm.currentRedIndex = Int.random(in: 0..<vm.cells.count)
        vm.cells[vm.currentRedIndex] = true // Make one cell red
        
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.grid
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = indexPath.row * vm.gridSize + indexPath.item
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell()}
//        cell.backgroundColor = .gray
        cell.backgroundColor = vm.cells[vm.safeIndex(index: index)] ? .green : .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.item * vm.gridSize + indexPath.item) < vm.cells.count {
            if vm.cells[indexPath.row * vm.gridSize + indexPath.item] {
                return // Don't handle tap on green cells
            }
            
            vm.cells[indexPath.row * vm.gridSize + indexPath.item] = true // Turn clicked cell green
            vm.currentRedIndex = vm.findNewRedIndex(excluding: indexPath.row * vm.gridSize + indexPath.item)
            vm.cells[vm.currentRedIndex] = false // Make a new random cell red
            
            collectionView.reloadData()
            
            // Check if all cells are green (game over)
            if !vm.cells.contains(false) {
                showAlert(message: "Congratulations! You won!")
            }
        }
        changeRandomCell()
        
    }
    
    
}
