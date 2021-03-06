//
//  MemeViewController+Helper.swift
//  MemeMe
//
//  Created by Anirudh Ramanan on 28/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import UIKit

extension MemeViewController {
    
    func save(memeImage: UIImage) {
        // Create and save the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imageView.image!, memeImage: memeImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        performSegue(withIdentifier: "unwindToList", sender: self)
    }
    
    func setupTextFieldDelegate() {
        //first set the delegates for both text fields
        memeTextFieldDelegate.view = self.view
        topText.delegate = memeTextFieldDelegate
        bottomText.delegate = memeTextFieldDelegate
    }
    
    func loadSavedMeme(meme : Meme?) {
        if let meme = meme {
            topText.text = meme.topText
            bottomText.text = meme.bottomText
            imageView.image = meme.image
            imageView.contentMode = .scaleAspectFit
            enableShareButton()
        }
    }
    
    func enableShareButton() {
        shareButton.isEnabled = true
    }
    
    func getMemeImage() -> UIImage {
        
        navigationController?.toolbar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationController?.toolbar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        return memeImage
    }
    
    func openImagePickerController(_ sender : Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        switch (sender as AnyObject).tag {
        case 0:
            imagePicker.sourceType = .camera
            break
        case 1:
            imagePicker.sourceType = .photoLibrary
            break
        default:
            break
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getFontsList() -> [String] {
        var listOfFonts = [String]()
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            let names = UIFont.fontNames(forFamilyName: familyName)
            for name in names {
                if name.contains("-Bold") {
                    listOfFonts.append(name)
                }
            }
        }
        
        return listOfFonts
    }
    
    func getMemeTextAttributes(fontName: String) -> [String: Any] {
        let memeTextAttributes:[String: Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: fontName, size: 40)!,
            NSStrokeWidthAttributeName: NSNumber(value: -1.0)
        ]
        return memeTextAttributes
    }
}
