//
//  ViewController.swift
//  MemeMe
//
//  Created by Bashayer  on 14/11/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        configureTextField(topTextField, defaultText: "TOP")
        configureTextField(bottomTextField, defaultText: "BOTTOM")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        configureToolbars(false)
        confifuteTopBarButtons(false)
        cancelButton.isEnabled = true

    }
    
    
    func configureTextField(_ textField: UITextField, defaultText: String) {
        let memeTextAttributes:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -3
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        navigationController?.isNavigationBarHidden = false
        
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if (bottomTextField.isFirstResponder){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save(_ meme: Meme) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        configureToolbars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        configureToolbars(false)
        return memedImage
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        let share = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(share, animated: true, completion: nil)
        
        share.completionWithItemsHandler = {
            activity, completed, returned, error in
            
            if completed {
                self.save(meme)
                self.dismiss(animated: true, completion: nil)
                let controller = self.navigationController!.viewControllers[0]
                let _ = self.navigationController?.popToViewController(controller, animated: true)
                
            }
        }
    }
    
    
    @IBAction func cancelImage(_ sender: Any) {
        configureTextField(topTextField, defaultText: "TOP")
        configureTextField(bottomTextField, defaultText: "BOTTOM")
        imageView.image = UIImage()
        shareButton.isEnabled = false
        let controller = self.navigationController!.viewControllers[0]
        let _ = self.navigationController?.popToViewController(controller, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            dismiss(animated: true, completion: nil)
            shareButton.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = false
        
    }
    
    @IBAction func fromAlbum(_ sender: Any) {
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        confifuteTopBarButtons(true)
    }
    @IBAction func fromCamera(_ sender: Any) {
        self.imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
        confifuteTopBarButtons(true)
    }
    
    func configureToolbars(_ isHidden: Bool) {
        topToolbar.isHidden = isHidden
        bottomToolbar.isHidden = isHidden
    }
    
    func confifuteTopBarButtons(_ enabled: Bool) {
        shareButton.isEnabled = enabled
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            if textField.restorationIdentifier == "topTextField" {
                configureTextField(topTextField, defaultText: "TOP")
            } else if textField.restorationIdentifier == "bottomTextField" {
                configureTextField(bottomTextField, defaultText: "BOTTOM")
            }
        }
        
        return true
    }
    
    
}

