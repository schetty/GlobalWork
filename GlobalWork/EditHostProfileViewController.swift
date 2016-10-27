//
//  EditHostProfileViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EditHostProfileViewController: UIViewController, /*UICollectionViewDelegate,*/ UIImagePickerControllerDelegate, UINavigationControllerDelegate, SSRadioButtonControllerDelegate, UITextViewDelegate {
    
    
    // MARK: Firebase Ref
    var ref: FIRDatabaseReference!
    var userProfile: Profile!
//    var imageName:String!
    
    
    
    // MARK: StoryBoard Outlet Properties
    //images
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    // MARK: Image Picker Controller
    let imagePicker = UIImagePickerController()
    var currentProfileImage = UIImage()
    
    // MARK: Label
    
    @IBOutlet var savedLabel: UILabel!
    
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
    
    var monthsNeeded = Array<String>()
    /// public method below
    
    
    //text fields
    
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var dateOfBirthTextField: UITextField!
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var tagLineTextField: UITextField!
    @IBOutlet var languagesTextField: UITextField!
    
    //text view
    
    @IBOutlet var descriptionTextView: UITextView!
    var placeholderLabel : UILabel!
    
    
    // collection view
    
    //    @IBOutlet var collectionViewHostPhotos: UICollectionView!
    
    
    // MARK: StoryBoard Action Functions
    
    
    @IBAction func didPressChangeProfilePic(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet var saveChangesButton: UIButton!
    
    
    @IBAction func didPressSaveChanges(_ sender: UIButton) {
        
        if (self.dateOfBirthTextField.text == "" || self.locationTextField.text == "") {
            
            let alert = UIAlertController(title: "Oops!",
                                          message: "You left your D.O.B or location field blank. We need that info",
                                          preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let image = profilePhotoImageView.image else {
            return
        }
            
        let currentButton = self.radioButtonController?.selectedButton()
        
        
        self.setDatesHelpNeeded(aButton: currentButton)
        print(self.monthsNeeded)
        
        let dobStr = dateOfBirthTextField.text!
        let loc = locationTextField.text!
        let enteredTag = tagLineTextField.text!
        let monthsHelpNeededString = self.monthsNeeded.joined(separator: " ")
        let monthsHelpNeeded = monthsHelpNeededString
        
        upload(image: image) { urlString in
            
            guard let url = urlString else {
                
                return
            }
            
            
            
            //MARK:setValue(profile.firebaseData)

            let setProfile = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/profile")
            
            self.userProfile = Profile(isHost: true, displayName: self.displayNameTextField.text!,  countriesVisiting: "none", userDescription: self.descriptionTextView.text, languagesSpoken: self.languagesTextField.text!, tagline: enteredTag, dateOfBirth: dobStr, /*userFeedbacks: [""],*/ profilePhotoURL: url, datesHelpNeeded: monthsHelpNeeded, location: loc)
            
           let profileForFireBase = self.userProfile.firbaseFormatted
            
            setProfile.setValue(profileForFireBase)
            
            
            self.savedLabel.isHidden = false
            self.savedLabel.fadeIn()
            self.savedLabel.fadeOut()

            
        }
    }

    
    
    // MARK : programatically adding placeholder text and radio buttons
    
    let placeholderText = "enter a description about yourself & your opportunity for travelers"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.savedLabel.isHidden = true
        self.savedLabel.alpha = 0.0
        
        radioButtonController = SSRadioButtonsController(buttons: janurary, february, march, april, may, june, july, august, september, october, november, december)
        
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        radioButtonController!.shouldBeAbleToSelectMoreThanOne = true
        
        
        descriptionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        //        collectionViewHostPhotos.delegate = self
        descriptionTextView.text = placeholderText
        descriptionTextView.textColor = UIColor(white: 0, alpha: 0.3)
        
        ref = FIRDatabase.database().reference()
        
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (descriptionTextView.text == placeholderText) {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (descriptionTextView.text == "") {
            descriptionTextView.text = placeholderText
            descriptionTextView.textColor = UIColor(white: 0, alpha: 0.3)
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        if !descriptionTextView.frame.contains(sender.location(in: view)) {
            descriptionTextView.resignFirstResponder()
        }
    }
    
    //MARK: - Delegate Methods for Image Picking
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePhotoImageView.contentMode = .scaleAspectFit
        profilePhotoImageView.image = chosenImage
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://globalwork-fe6cf.firebaseio.com")
        let usersReference = ref.child("data/users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
        })
    }
    
    private func upload(image: UIImage, imageCompletion: @escaping (String?)->()) {
        if let uploadPic = UIImagePNGRepresentation(image) {
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            
            storageRef.put(uploadPic, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    imageCompletion(nil)
                    print(error)
                    return
                    
                }
                
                if let profilePicURL =  metadata?.downloadURL()?.absoluteString {
                    imageCompletion(profilePicURL)
                    //self.sendProfilePhotoToDatabaseWithUID(uid: (FIRAuth.auth()!.currentUser!.uid))
//                    self.userProfile.profilePhotoURL = profilePicURL
//                    let values = ["profileImageUrl": profilePicURL]
                    
//                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                } else {
                    imageCompletion(nil)
                }
            })
            
        }
        
    }
    
    
    func setDatesHelpNeeded(aButton:UIButton?) {
        self.monthsNeeded.removeAll()
        
        if (janurary.isSelected) {
            self.monthsNeeded.append(Months.january.rawValue)
        }
        
        if (february.isSelected) {
            self.monthsNeeded.append(Months.february.rawValue)
        }
        
        if (march.isSelected) {
            self.monthsNeeded.append(Months.march.rawValue)
        }
        
        if (april.isSelected) {
            self.monthsNeeded.append(Months.april.rawValue)
        }
        
        if (may.isSelected) {
            self.monthsNeeded.append(Months.may.rawValue)
        }
        
        if (june.isSelected) {
            self.monthsNeeded.append(Months.june.rawValue)
        }
        
        if (july.isSelected) {
            self.monthsNeeded.append(Months.july.rawValue)
        }
        
        if (august.isSelected) {
            self.monthsNeeded.append(Months.august.rawValue)
        }
        
        if (september.isSelected) {
            self.monthsNeeded.append(Months.september.rawValue)
        }
        
        if (october.isSelected) {
            self.monthsNeeded.append(Months.october.rawValue)
        }
        
        if (november.isSelected) {
            self.monthsNeeded.append(Months.november.rawValue)
        }
        if (december.isSelected) {
            self.monthsNeeded.append(Months.december.rawValue)
        }
        else if (aButton == nil) {
            self.monthsNeeded.append("Your months are empty")
        }
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
