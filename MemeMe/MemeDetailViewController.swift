//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Anirudh Ramanan on 29/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    weak var editMeme: UIBarButtonItem!
    var meme: Meme?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeme()
    }
    
    func loadMeme() {
        if let meme = meme {
            memeImage.image = meme.memeImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editSavedMeme(sender: UIBarButtonItem) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "EditMeme":
            let navigationController = segue.destination as! UINavigationController
            let memeViewController = navigationController.viewControllers[0] as! MemeViewController
            memeViewController.meme = meme
            break
        default:
            break
        }
    }
}
