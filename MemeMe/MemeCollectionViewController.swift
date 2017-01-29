//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Anirudh Ramanan on 28/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var sentMemes: [Meme] = []
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       reloadCollectionView()
    }
    
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        if sender.source is MemeViewController {
            reloadCollectionView()
        } else{
            fatalError("Unidentified segue")
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = sentMemes[(indexPath as NSIndexPath).row]
        cell.memeImage.image = meme.memeImage
        return cell
    }
    
    func reloadCollectionView() {
        sentMemes = SentMemes.allSentMemes()
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "ShowMeme":
            guard let memeDetailViewController = segue.destination as? MemeDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMemeCell = sender as? MemeCollectionViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = collectionView?.indexPath(for: selectedMemeCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeme = sentMemes[indexPath.row]
            memeDetailViewController.meme = selectedMeme
            break
        default:
            break
        }
    }
}
