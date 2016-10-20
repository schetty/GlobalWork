//
//  EditHostProfileViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class EditHostProfileViewController: UIViewController, /*UICollectionViewDelegate,*/ UIImagePickerControllerDelegate, UINavigationControllerDelegate, SSRadioButtonControllerDelegate {
    
    
    // MARK: Firebase Ref
    var ref: FIRDatabaseReference!

    
    
    // MARK: StoryBoard Outlet Properties
        //images
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
        // MARK: Image Picker Controller
    let imagePicker = UIImagePickerController()
    var currentProfileImage = UIImage()
        // end
    
    //buttons - RADIO BUTTONS
    var radioButtonController: SSRadioButtonsController?

    @IBOutlet var janurary: SSRadioButton!
    @IBOutlet var february: SSRadioButton!
    @IBOutlet var march: SSRadioButton!
    @IBOutlet var april: SSRadioButton!
    @IBOutlet var may: SSRadioButton!
    @IBOutlet var june: SSRadioButton!
    @IBOutlet var july: SSRadioButton!
    @IBOutlet var august: SSRadioButton!
    @IBOutlet var september: SSRadioButton!
    @IBOutlet var october: SSRadioButton!
    @IBOutlet var november: SSRadioButton!
    @IBOutlet var december: SSRadioButton!
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
//        
//        var userProfile = Profile(isHost: true, countriesVisiting: "", userDescription: descriptionTextView.text?, languagesSpoken: languagesTextField.text?, userFeedbacks: "", datesHelpNeeded: <#T##NSDateInterval#>, location: <#T##NSLocale#>)
//        userProfile.displayName = displayNameTextField.text?
//        let dobStr = dateOfBirthTextField.text!
//        let loc = locationTextField.text!
//        let tagline = tagLineTextField.text?
//        
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dob = dateFormatter.date(from: dobStr)
//        
//        var data: NSData = NSData()
//        
//        let base64String = data.base64EncodedStringWithOptions(NSData.Base64EncodingOptions.Encoding64CharacterLineLength)
//        
//        
        
        let profile = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/profileInfo")


        
    }
    
    @IBAction func didPressUploadPhoto(_ sender: UIButton) {
    }

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        radioButtonController = SSRadioButtonsController(buttons: janurary, february, march, april, may, june, july, august, september, october, november, december)
        
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        radioButtonController!.shouldBeAbleToSelectMoreThanOne = true

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
//        collectionViewHostPhotos.delegate = self
        
        
        ref = FIRDatabase.database().reference()


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
