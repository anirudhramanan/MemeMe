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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeTextFieldDelegate.view = self.view
        self.topText.delegate = memeTextFieldDelegate
        self.bottomText.delegate = memeTextFieldDelegate
        self.shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.memeTextFieldDelegate.subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
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
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            fatalError()
            break
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMemeImage(_ sender: Any) {
        let shareController = UIActivityViewController(activityItems: [getMemeImage()], applicationActivities: nil)
        shareController.completionWithItemsHandler = {
            (s, ok, items, error) in print(ok ? "SUCCESS!" : "FAILURE")
            self.save()
        }
        self.present(shareController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
        checkEnableShareButton()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topText.text ?? "", bottomText: bottomText.text ?? "", image: imageView.image!, memeImage: getMemeImage())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        performSegue(withIdentifier: "unwindToList", sender: self)
    }
    
    func getMemeImage() -> UIImage {
        self.navigationController?.toolbar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.navigationController?.toolbar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false

        return memeImage
    }
    
    func checkEnableShareButton() {
        if imageView.image != nil {
            self.shareButton.isEnabled = true
        }
    }
}
