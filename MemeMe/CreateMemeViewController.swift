//
//  CreateMemeViewController.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 2/11/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    
    var memes:[Meme] {
        get {
            return Model.sharedInstance().getAllMemes()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imageViewAspectRatioConstraint: NSLayoutConstraint!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe To keyboard Notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Unsubscribe from keyboard Notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            showImagePicker(type: .camera)
        case 1:
            showImagePicker(type: .photoLibrary)
        default:
            break
        }
    }

    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                Model.sharedInstance().addMeme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: UIImagePNGRepresentation(self.imageView.image!)!, memedImage: UIImagePNGRepresentation(memedImage)!)
                self.dismiss(animated: true)
            }
        }
        
        // Specify the anchor point of the UIActivityViewController popover on iPad
        activityVC.popoverPresentationController?.barButtonItem = shareButton
        
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI Configuration
    
    func configureUI() {
        // Disable Share Button
        shareButton.isEnabled = false
        
        // Determine Camera Button Status
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Determine Cancel Button Status
        if memes.count == 0 {
            cancelButton.isEnabled = false
        }
        
        // Updating Text Fields text attributes
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: GeneralConstants.MemeFont, size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3,
            NSAttributedStringKey.paragraphStyle.rawValue: style]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    func updateConstarintWithMultiplier(constarint: NSLayoutConstraint, multiplier: CGFloat) {
        let newConstraint = NSLayoutConstraint(item: constarint.firstItem!,
                                               attribute: constarint.firstAttribute,
                                               relatedBy: constarint.relation,
                                               toItem: constarint.secondItem,
                                               attribute: constarint.secondAttribute,
                                               multiplier: multiplier,
                                               constant: constarint.constant)
        imageView.removeConstraint(constarint)
        imageViewAspectRatioConstraint = newConstraint
        imageView.addConstraint(imageViewAspectRatioConstraint)
    }
    
    // MARK: - Meme image generation
    
    func generateMemedImage() -> UIImage {
        
        func setToolBarsHidden(isHidden:Bool) {
            topToolbar.isHidden = isHidden
            bottomToolbar.isHidden = isHidden
        }
        
        setToolBarsHidden(isHidden: true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        var memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        setToolBarsHidden(isHidden: false)
        
        // Crop the screen shot to the imageView frame
        if let croppedImage = memedImage.cgImage!.cropping(to: imageView.frame) {
            memedImage = UIImage(cgImage: croppedImage)
        }
        
        return memedImage
    }
}

// MARK: - ImagePicker delegate

extension CreateMemeViewController: UIImagePickerControllerDelegate {
    
    func showImagePicker(type: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = type
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            let imageAspectRatio = image.size.width / image.size.height
            updateConstarintWithMultiplier(constarint: imageViewAspectRatioConstraint, multiplier: imageAspectRatio)
            shareButton.isEnabled = true
            picker.dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - TextField delegate

extension CreateMemeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            if textField == topTextField {
                textField.text = GeneralConstants.DefaultTopText
            } else if textField == bottomTextField {
                textField.text = GeneralConstants.DefaultBottomText
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - Keyboard Notifications

extension CreateMemeViewController {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

