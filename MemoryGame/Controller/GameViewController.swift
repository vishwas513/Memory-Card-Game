//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Daniel Tsirulnikov on 19.3.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MemoryGameDelegate {

    // MARK: Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!

    let gameController = MemoryGame()
    var timer:Timer?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameController.delegate = self
        resetGame()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if gameController.isPlaying {
            resetGame()
        }
    }
    
    // MARK: - Methods

    func resetGame() {
        gameController.stopGame()
        if timer?.isValid == true {
            timer?.invalidate()
            timer = nil
        }
        collectionView.isUserInteractionEnabled = false
        collectionView.reloadData()
        timerLabel.text = String(format: "%@: ---", NSLocalizedString("TIME", comment: "time"))
        playButton.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
    }
    
    @IBAction func didPressPlayButton() {
        if gameController.isPlaying {
            resetGame()
            playButton.setTitle(NSLocalizedString("Play", comment: "play"), for: UIControlState())
        } else {
            setupNewGame()
            playButton.setTitle(NSLocalizedString("Stop", comment: "stop"), for: UIControlState())
        }
    }
    
    func setupNewGame() {
        let cardsData:[UIImage] = MemoryGame.defaultCardImages
        gameController.newGame(cardsData)
    }
    
    func gameTimerAction() {
        timerLabel.text = String(format: "%@: %.0fs", NSLocalizedString("TIME", comment: "time"), gameController.elapsedTime)
    }
    
    
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16 //gameController.numberOfCards > 0 ? gameController.numberOfCards : 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCVC
        cell.showCard(false, animted: false)

        guard let card = gameController.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card

        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCVC

        if cell.shown { return }
        gameController.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let numberOfColumns:Int = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        
        let itemWidth: CGFloat = collectionView.frame.width / 4.0 - 15.0 //numberOfColumns as CGFloat - 10 //- (minimumInteritemSpacing * numberOfColumns))

        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    // MARK: - MemoryGameDelegate

    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.gameTimerAction), userInfo: nil, repeats: true)

    }

    func memoryGame(_ game: MemoryGame, showCards cards: [Card]) {
        for card in cards {
            guard let index = gameController.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCVC
            cell.showCard(true, animted: true)
        }
    }
    
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = gameController.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCVC
            cell.showCard(false, animted: true)
        }
    }

    
    func memoryGameDidEnd(_ game: MemoryGame, elapsedTime: TimeInterval) {
        timer?.invalidate()

        let elapsedTime = gameController.elapsedTime
        
        let alertController = UIAlertController(
            title: NSLocalizedString("Hurrah!", comment: "title"),
            message: String(format: "%@ %.0f seconds", NSLocalizedString("You finished the game in", comment: "message"), elapsedTime),
            preferredStyle: .alert)
        
        let saveScoreAction = UIAlertAction(title: NSLocalizedString("Save Score", comment: "save score"), style: .default) { [weak self] (_) in
            let nameTextField = alertController.textFields![0] as UITextField
            guard let name = nameTextField.text else { return }
         //   self?.savePlayerScore(name, score: elapsedTime)
            self?.resetGame()
        }
        saveScoreAction.isEnabled = false
        alertController.addAction(saveScoreAction)

        alertController.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Your name", comment: "your name")
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange,
                object: textField,
                queue: OperationQueue.main) { (notification) in
                saveScoreAction.isEnabled = textField.text != ""
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "dismiss"), style: .cancel) { [weak self] (action) in
            self?.resetGame()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) { }
    }
    


}

