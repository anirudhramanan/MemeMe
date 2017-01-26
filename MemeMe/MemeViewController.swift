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
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeTextFieldDelegate.view = self.view
        self.topText.delegate = memeTextFieldDelegate
        self.bottomText.delegate = memeTextFieldDelegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.memeTextFieldDelegate.subscribeToKeyboardNotifications()
        self.topText.text = "TOP"
        self.bottomText.text = "BOTTOM"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.memeTextFieldDelegate.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickFromGallery(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func captureImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imageView.image!, memeImage: getMemeImage())
    }
    
    func getMemeImage() -> UIImage {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        return memeImage
    }
}
