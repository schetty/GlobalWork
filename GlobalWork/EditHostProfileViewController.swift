//
//  EditHostProfileViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit

class EditHostProfileViewController: UIViewController, /*UICollectionViewDelegate,*/ UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: StoryBoard Outlet Properties
        //images
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
        // MARK: Image Picker Controller
    let imagePicker = UIImagePickerController()
    var currentProfileImage = UIImage()
        // end
    
    
        //text fields
    
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var dateOfBirthTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var tagLineTextField: UITextField!
    @IBOutlet var languagesTextField: UITextField!
    
        //text view
    
    @IBOutlet var descriptionTextView: UITextView!
    
        // collection view
    
//    @IBOutlet var collectionViewHostPhotos: UICollectionView!
    
    
    // MARK: StoryBoard Action Functions
    
    
    @IBAction func didPressChangeProfilePic(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!

        
        present(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func didPressSaveChanges(_ sender: UIButton) {
    }
    
    @IBAction func didPressUploadPhoto(_ sender: UIButton) {
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
//        collectionViewHostPhotos.delegate = self
    
    }

    
    //MARK: - Delegate Methods for Image Picking
        ////// NOT WORKING COME BACK TO THIS
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePhotoImageView.contentMode = .scaleAspectFit
        profilePhotoImageView.image = chosenImage
        
        print("PICKED")
        
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Collection View Delegate Methods
//
//   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    
//    return 0
//    }
//    
//    
//
//    @nonobjc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionViewHostPhotos.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as!HostSitePictureCollectionViewCell
//        cell.backgroundColor = UIColor.cyan
//        
//        return cell
//    }
//    
//    
//
//   func numberOfSections(in collectionView: UICollectionView) -> Int {
//    
//    return 0
//    }
    
}
