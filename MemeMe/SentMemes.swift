//
//  SentMemes.swift
//  MemeMe
//
//  Created by Anirudh Ramanan on 28/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import UIKit

class SentMemes {
    
    static func allSentMemes() -> [Meme] {
        return getAppDelegate().memes
    }
    
    private static func getAppDelegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    static func removeMeme(index: Int) {
        getAppDelegate().memes.remove(at: index)
    }
}
