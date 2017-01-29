//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Anirudh Ramanan on 28/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var sentMemes: [Meme] = []
    let textSeperator: String = "..."
   
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDataForTableView()
        //enable edit option only if we have memes in our list
        if sentMemes.count > 0 {
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as? MemeTableViewCell else {
            fatalError("The cell is not an instance of MemeTableViewCell")
        }
        let meme = sentMemes[indexPath.row]
        cell.memeImage.image = meme.memeImage
        cell.memeLabel.text = meme.topText + textSeperator + meme.bottomText
        return cell
    }
    
    func removeAndUpdateMemes(index: Int) {
        sentMemes.remove(at: index)
        SentMemes.removeMeme(index: index)
    }
    
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        if sender.source is MemeViewController {
            loadDataForTableView()
        } else{
            fatalError("Unidentified segue")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            removeAndUpdateMemes(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "ShowMeme":
            guard let memeDetailViewController = segue.destination as? MemeDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMemeCell = sender as? MemeTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedMemeCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeme = sentMemes[indexPath.row]
            memeDetailViewController.meme = selectedMeme
            break
        default:
            break
        }
    }
    
    func loadDataForTableView() {
        sentMemes = SentMemes.allSentMemes()
        tableView.reloadData()
    }
}
