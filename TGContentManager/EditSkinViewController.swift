//
//  EditSkinViewController.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class EditSkinViewController: UIViewController {
    class func deploy(with skin: Skin, completion: ((EditSkinViewController?) -> Void)? = nil) -> EditSkinViewController {
        let editSkinVC = EditSkinViewController.instantiateFromStoryboardId(.main)
        editSkinVC.skin = skin
        editSkinVC.completion = completion
        return editSkinVC
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var completion: ((EditSkinViewController?) -> Void)?
    var imagePicker: UIImagePickerController!
    var skin: Skin!
    
    var initialImageUrl: String?
    var initialName: String?
    var initialImage: UIImage?
    
    override func viewDidLoad() {
        configure()
    }
    
    @IBAction func titReceiveLongTap(_ sender: UILongPressGestureRecognizer) {
        Spitter.showSheet(
            skin.id,
            message: nil,
            buttonTitles: ["Save current Image on device",
                           "Upload current Image on server",
                           "Apply changes",
                           "Discard changes",
                           "Cancel"],
            actions: [
                { [unowned self] in self.save(sender) },
                { [unowned self] in self.uploadImageIfNeeded(for: self.skin) },
                { [unowned self] in self.save() },
                { [unowned self] in self.discardChanges() },
                {}
            ],
            styles: [.default, .default, .default, .default, .cancel], owner: self)
    }
    func configure() {
        initialName = skin.name
        initialImageUrl = skin.url
        if let url = URL(string: skin.url ?? "") {
            imageView.setImage(withURL: url) { [unowned self] in
                self.initialImage = self.imageView.image
            }
        }
        identifierTextField.text = skin.name
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
    }
    
    var idChanged: Bool {
        return initialName != nil ? identifierTextField.text != initialName : false
    }
    
    var imageChanged: Bool {
        return imageView.image != initialImage
    }
    
    var changed: Bool {
        return idChanged || imageChanged
    }
    
    func save() {
        let skin = self.skin ?? Skin(id: self.skin.id ?? "")
        if idChanged {
            if let newName = identifierTextField.text, !newName.isEmpty {
                skin.name = newName
                FirebaseHelper.store(skins: [skin], completion: { 
                    
                })
            }
        }
        uploadImageIfNeeded(for: skin)
    }
    
    func uploadImageIfNeeded(for skin: Skin) {
        if imageChanged {
            guard let image = imageView.image else { return }
            FirebaseHelper.update(image: image, for: skin) {
                Spitter.showOk(vc: self, completion: {})
            }
        }
    }
    
    func discardChanges() {
        if changed {
            if imageChanged {
                imageView.image = initialImage
            }
            if idChanged {
                identifierTextField.text = initialName
            }
        }
    }
    
    func close() {
        if changed {
            Spitter.showAlert("You have changes", message: nil, buttonTitles: ["Apply", "Discard", "Cancel"], actions: [{ [unowned self] in
                self.save()
                self.shutDown()
                }, { [unowned self] in
                    self.discardChanges()
                    self.shutDown()
                }, {}], styles: [.default, .default, .cancel], owner: self)
        } else {
            self.shutDown()
        }
    }
    
    fileprivate func shutDown() {
        completion?(self)
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditSkinViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //MARK: - Take image
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    //MARK: - Add image to Library
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
//        FirebaseHelper.update(image: image, for: skin, completion: { 
//            Spitter.showOk {
//                
//            }
//        })
        }
    }

}
