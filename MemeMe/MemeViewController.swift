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
    var meme : Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldDelegate()
        configureTextField(textField: topText, fontName: "HelveticaNeue-CondensedBlack")
        configureTextField(textField: bottomText, fontName: "HelveticaNeue-CondensedBlack")
        loadSavedMeme(meme : meme)
    }

    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        memeTextFieldDelegate.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        memeTextFieldDelegate.unsubscribeFromKeyboardNotifications()
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
            configureTextField(textField: topText, fontName: fontName)
            configureTextField(textField: bottomText, fontName: fontName)
        }
    }

    private func configureTextField(textField: UITextField, fontName: String) {
        textField.defaultTextAttributes = getMemeTextAttributes(fontName: fontName)
        textField.textAlignment = NSTextAlignment.center
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareMemeImage(_ sender: Any) {
        memeImage = getMemeImage()
        let shareController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
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
        enableShareButton()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
