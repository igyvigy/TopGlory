//
//  EditViewController.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    class func deploy(with mode: ViewControllerMode, model: Model, completion: ((EditViewController?) -> Void)? = nil) -> EditViewController {
        let editmodelVC = EditViewController.instantiateFromStoryboardId(.main)
        editmodelVC.model = model
        editmodelVC.completion = completion
        return editmodelVC
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var completion: ((EditViewController?) -> Void)?
    var imagePicker: UIImagePickerController!
    var model: Model!
    
    var initialImageUrl: String?
    var initialName: String?
    var initialImage: UIImage?
    
    override func viewDidLoad() {
        configure()
    }
    
    @IBAction func titReceiveLongTap(_ sender: UILongPressGestureRecognizer) {
        Spitter.showSheet(
            model.id,
            message: nil,
            buttonTitles: ["Save current Image on device",
                           "Upload current Image on server",
                           "Apply changes",
                           "Discard changes",
                           "Cancel"],
            actions: [
                { [unowned self] in self.save(sender) },
                { [unowned self] in self.uploadImageIfNeeded(for: self.model) },
                { [unowned self] in self.save() },
                { [unowned self] in self.discardChanges() },
                {}
            ],
            styles: [.default, .default, .default, .default, .cancel], owner: self)
    }
    func configure() {
        initialName = model.name
        initialImageUrl = model.url
        if let url = URL(string: model.url ?? "") {
            imageView.setImage(withURL: url) { [unowned self] in
                self.initialImage = self.imageView.image
            }
        }
        identifierTextField.text = model.name
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
        let model = self.model!
        if idChanged {
            if let newName = identifierTextField.text, !newName.isEmpty {
                model.name = newName
                FirebaseHelper.store(models: [model], completion: { 
                    
                })
            }
        }
        uploadImageIfNeeded(for: model)
    }
    
    func uploadImageIfNeeded(for model: Model) {
        if imageChanged {
            guard let image = imageView.image else { return }
            FirebaseHelper.update(image: image, for: model) {
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

extension EditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
//        FirebaseHelper.update(image: image, for: model, completion: { 
//            Spitter.showOk {
//                
//            }
//        })
        }
    }

}
