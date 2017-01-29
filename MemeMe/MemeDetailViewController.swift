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
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(hide: true)
        loadMeme()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        configureUI(hide: false)
    }
    
    private func configureUI(hide: Bool) {
        self.tabBarController?.tabBar.isHidden = hide
    }
    
    private func loadMeme() {
        if let meme = meme {
            memeImage.image = meme.memeImage
        }
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
