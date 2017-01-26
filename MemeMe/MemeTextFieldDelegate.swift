//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Anirudh Ramanan on 26/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate{
 
    var view: UIView!
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       return textField.resignFirstResponder()
    }
    
    func shiftScreenUp(_ notification:Notification){
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func shiftScreenDown(_ notification:Notification){
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(shiftScreenUp(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shiftScreenDown(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
