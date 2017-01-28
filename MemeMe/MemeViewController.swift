//
//  ViewController.swift
//  MemeMe
//
//  Created by Anirudh Ramanan on 26/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    var memeImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.memeTextFieldDelegate.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.memeTextFieldDelegate.unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickFromGallery(_ sender: Any) {
        openImagePickerController(sender)
    }
    
    @IBAction func captureImage(_ sender: Any) {
        openImagePickerController(sender)
    }
    
    @IBAction func chooseFont(_ sender: Any) {
        let fontController = UIAlertController(title: "Choose Font", message: "Select your favourite font", preferredStyle: .actionSheet)
        for fontName in getFontsList() {
            fontController.addAction(UIAlertAction(title: fontName, style: .default, handler: updateSelectedFont))
        }
        present(fontController, animated: true, completion: nil)
    }
    
    private func updateSelectedFont(action: UIAlertAction){
        let fontName = action.title ?? ""
        //make sure that the font has a title, else do not execute this block
        if fontName != "" {
            self.topText.defaultTextAttributes = getMemeTextAttributes(fontName: fontName)
            self.bottomText.defaultTextAttributes = getMemeTextAttributes(fontName: fontName)
        }
    }
    
    private func setupTextField() {
        //first set the delegates for both text fields
        memeTextFieldDelegate.view = self.view
        self.topText.delegate = memeTextFieldDelegate
        self.bottomText.delegate = memeTextFieldDelegate
        
        //sent fonts
        self.topText.defaultTextAttributes = getMemeTextAttributes(fontName: "HelveticaNeue-CondensedBlack")
        self.bottomText.defaultTextAttributes = getMemeTextAttributes(fontName: "HelveticaNeue-CondensedBlack")
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareMemeImage(_ sender: Any) {
        memeImage = getMemeImage()
        let shareController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        self.present(shareController, animated: true, completion: nil)
        shareController.completionWithItemsHandler = {
            (a, success, i, e) in ()
            if success {
                self.save(memeImage: self.memeImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
        self.shareButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
