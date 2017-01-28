//
//  SharedSavedMemes.swift
//  MemeMe
//
//  Created by Anirudh Ramanan on 28/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class SharedSavedMemes {
    
    func getAppDelegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    func getSharedMemes() -> [Meme] {
         return getAppDelegate().memes
    }
    
    func removeMemeAtIndex(index : Int) {
        getAppDelegate().memes.remove(at: index)
    }
}
