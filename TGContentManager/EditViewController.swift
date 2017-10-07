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
        editmodelVC.mode = mode
        editmodelVC.completion = completion
        return editmodelVC
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageUrlLabel: UILabel!
    
    var completion: ((EditViewController?) -> Void)?
    var imagePicker: UIImagePickerController!
    var model: Model!
    var mode: ViewControllerMode!
    
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
                           "Copy imageURL",
                           "Upload current Image on server",
                           "Apply changes",
                           "Discard changes",
                           "Cancel"],
            actions: [
                { [unowned self] in self.save(sender) },
                { [unowned self] in let pb = UIPasteboard.general; pb.string = self.imageUrlLabel.text },
                { [unowned self] in self.uploadImageIfNeeded(for: self.model){} },
                { [unowned self] in self.save(){} },
                { [unowned self] in self.discardChanges() },
                {}
            ],
            styles: [.default, .default, .default, .default, .default, .cancel], owner: self)
    }
    func configure() {
        initialName = model.name ?? ""
        initialImageUrl = model.url
        imageUrlLabel.text = model.url
        if let url = URL(string: model.url ?? "") {
            imageView.setImage(withURL: url) { [unowned self] in
                self.initialImage = self.imageView.image
            }
        }
        identifierTextField.text = model.name ?? kEmptyStringValue
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(didTapChangeImageButton), for: .touchUpInside)
    }
    
    var idChanged: Bool {
        return identifierTextField.text != initialName
    }
    
    var imageChanged: Bool {
        return imageView.image != initialImage
    }
    
    var imageUrlChanged: Bool {
        return imageUrlLabel.text != initialImageUrl
    }
    
    var changed: Bool {
        return idChanged || imageChanged || imageUrlChanged
    }
    
    @IBAction func didTapChangeImageButton(_ sender: UIButton) {
        MultiActionAlert(
            style: .actionSheet,
            title: "Change image?",
            buttonTitles: ["From Camera Roll", "Paste URL", "Cancel"],
            actionStyles: [.default, .default, .cancel],
            actions: [{ [weak self] in self?.showImagePicker() },
                      { [weak self] in self?.pasteFromClipBoard() },
                      {}],
            owner: self
            ).showAlert()
    }
    
    func pasteFromClipBoard() {
        let pasteBoard = UIPasteboard.general
        imageUrlLabel.text = pasteBoard.string
    }
    
    func save(completion: @escaping () -> Void) {
        if idChanged {
            if let newName = identifierTextField.text, !newName.isEmpty {
                model.name = newName
                FirebaseHelper.store(models: [model])
                switch mode! {
                case .newItemIds: FirebaseHelper.removeUnknownRecordForMode(model: model, isItemStatsId: true)
                case.newGameModes: FirebaseHelper.removeUnknownRecordForMode(model: model)
                default: break
                }
            }
        }
        if imageUrlChanged {
            model.url = imageUrlLabel.text
            FirebaseHelper.store(models: [model])
        }
        uploadImageIfNeeded(for: model, completion: completion)
    }
    
    func uploadImageIfNeeded(for model: Model, completion: @escaping () -> Void) {
        if imageChanged {
            guard let image = imageView.image else {
                completion()
                
                return }
            FirebaseHelper.update(image: image, for: model, progressHandler: { [unowned self] progress in
                self.progressView.progress = progress
            }) { [unowned self] in
                FirebaseHelper.removeUnknownRecordForMode(model: model)
                Spitter.showOk(vc: self, completion: {
                    completion()
                })
            }
        } else {
            completion()
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
            if imageUrlChanged {
                imageUrlLabel.text = initialImageUrl
            }
        }
    }
    
    func close() {
        if changed {
            Spitter.showAlert("You have changes", message: nil, buttonTitles: ["Apply", "Discard", "Cancel"], actions: [
                { [unowned self] in
                    //apply
                self.save() {
                    self.shutDown()
                }
                }, { [unowned self] in
                    //discard
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

    func showImagePicker() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }

}
