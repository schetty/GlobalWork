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
        let monthsHelpNeeded = self.monthsNeeded
        
        upload(image: image)
        { urlString in
            guard let url = urlString else {
                return
            }
            
            self.userProfile = Profile(isHost: true, displayName: self.displayNameTextField.text!,  countriesVisiting: ["none"], userDescription: self.descriptionTextView.text, languagesSpoken: self.languagesTextField.text!, tagline: enteredTag, dateOfBirth: dobStr, /*userFeedbacks: [""],*/ profilePhotoURL: url, datesHelpNeeded: monthsHelpNeeded, location: loc)
            
        
            
            let setDisplayName = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/displayName")
            
            let setDOB = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/DOB")
            
            let setLangsSpoken = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/langsSpoken")
            
            let setDesciption = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/userDescription")
            
            let setTagline = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/tagline")
            
            let setMonthsHelpNeeded = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/monthsHelpNeeded")
            
            let setUserLocation = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/userLocation")
            
            let setUserPhoto = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/profileImageUrl")
            
            if (self.userProfile.displayName != nil) {
                setDisplayName.setValue(self.userProfile.displayName)
            }
            
            if (self.userProfile.languagesSpoken != nil) {
                setLangsSpoken.setValue(self.userProfile.languagesSpoken)
            }
            
            if (self.userProfile.userDescription != nil) {
                setDesciption.setValue(self.userProfile.userDescription)
            }
            
            if (self.userProfile.tagline != nil) {
                setTagline.setValue(self.userProfile.tagline)
            }
            
            if (self.userProfile.location != nil) {
                setUserLocation.setValue(self.userProfile.location)
            }
            
            if (self.userProfile.dateOfBirth != nil) {
                setDOB.setValue(self.userProfile.dateOfBirth)
            }
                
            if (self.userProfile.profilePhotoURL != nil) {
                setUserPhoto.setValue(self.userProfile.profilePhotoURL)
            }
            
//            if (imageName != nil) {
//                sendProfilePhotoToDatabaseWithUID(uid: (FIRAuth.auth()!.currentUser!.uid))
//            }
                
            else {
                print ("filled out nada")
            }
            
            setMonthsHelpNeeded.setValue(self.userProfile.datesHelpNeeded)
            
            self.registerUserIntoDatabaseWithUID(uid: FIRAuth.auth()!.currentUser!.uid, values: [String : AnyObject]())
        }
    }
    
    @IBAction func didPressUploadPhoto(_ sender: UIButton) {
        
    }
    
    
    
    
    let placeholderText = "enter a description about yourself & your opportunity for travelers"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radioButtonController = SSRadioButtonsController(buttons: janurary, february, march, april, may, june, july, august, september, october, november, december)
        
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        radioButtonController!.shouldBeAbleToSelectMoreThanOne = true
        
        
        descriptionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = "enter a description about yourself & your opportunity for travelers"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (descriptionTextView.font?.pointSize)! / 1.31)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 0, y: (descriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
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
    
    private func upload(image: UIImage, completion: @escaping (String?)->()) {
        if let uploadPic = UIImagePNGRepresentation(image) {
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            
            storageRef.put(uploadPic, metadata: nil) { (metadata, error) in
                if error != nil {
                    completion(nil)
                    print(error)
                    return
                    
                }
                
                if let profilePicURL =  metadata?.downloadURL()?.absoluteString {
                    completion(profilePicURL)
                    //self.sendProfilePhotoToDatabaseWithUID(uid: (FIRAuth.auth()!.currentUser!.uid))
//                    self.userProfile.profilePhotoURL = profilePicURL
//                    let values = ["profileImageUrl": profilePicURL]
                    
//                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                } else {
                    completion(nil)
                }
            }
            
        }
        
    }
    
    
    func setDatesHelpNeeded(aButton:UIButton?) {
        self.monthsNeeded.removeAll()
        
        if (janurary.isSelected) {
            self.monthsNeeded.append("Janurary")
        }
        
        if (february.isSelected) {
            self.monthsNeeded.append("February")
        }
        
        if (march.isSelected) {
            self.monthsNeeded.append("March")
        }
        
        if (april.isSelected) {
            self.monthsNeeded.append("April")
        }
        
        if (may.isSelected) {
            self.monthsNeeded.append("May")
        }
        
        if (june.isSelected) {
            self.monthsNeeded.append("June")
        }
        
        if (july.isSelected) {
            self.monthsNeeded.append("July")
        }
        
        if (august.isSelected) {
            self.monthsNeeded.append("August")
        }
        
        if (september.isSelected) {
            self.monthsNeeded.append("September")
        }
        
        if (october.isSelected) {
            self.monthsNeeded.append("October")
        }
        
        if (november.isSelected) {
            self.monthsNeeded.append("November")
        }
        if (december.isSelected) {
            self.monthsNeeded.append("December")
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
