//
//  EditHostProfileViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class EditHostProfileViewController: UIViewController, /*UICollectionViewDelegate,*/ UIImagePickerControllerDelegate, UINavigationControllerDelegate, SSRadioButtonControllerDelegate, UITextViewDelegate {
    
    
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
    
    var monthsNeeded = Set<String>()
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
        }
            
        else {
            
            let currentButton = self.radioButtonController?.selectedButton()
            
            
            self.setDatesHelpNeeded(aButton: currentButton)
            print(self.monthsNeeded)
            
            let dobStr = dateOfBirthTextField.text!
            let loc = locationTextField.text!
            let enteredTag = tagLineTextField.text!
            let monthsHelpNeeded = Array(self.monthsNeeded)
            
            
            let userProfile = Profile(isHost: true, displayName: displayNameTextField.text!,  countriesVisiting: ["none"], userDescription: descriptionTextView.text, languagesSpoken: languagesTextField.text!, tagline: enteredTag, dateOfBirth: dobStr, /*userFeedbacks: [""],*/ profilePhotoURL: "URL", datesHelpNeeded: monthsHelpNeeded, location: loc)
            
            let setDisplayName = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/displayName")
            
            let setDOB = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/DOB")
            
            let setLangsSpoken = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/langsSpoken")
            
            let setDesciption = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/userDescription")
            
            let setTagline = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/tagline")
            
            let setMonthsHelpNeeded = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/monthsHelpNeeded")
            
            let setUserLocation = self.ref.child("data/users/" + "\(FIRAuth.auth()!.currentUser!.uid)/userLocation")
            
            if (userProfile.displayName != nil) {
                setDisplayName.setValue(userProfile.displayName)
            }
            
            if (userProfile.languagesSpoken != nil) {
                setLangsSpoken.setValue(userProfile.languagesSpoken)
            }
            
            if (userProfile.userDescription != nil) {
                setDesciption.setValue(userProfile.userDescription)
            }
            
            if (userProfile.tagline != nil) {
                setTagline.setValue(userProfile.tagline)
            }
            
            if (userProfile.location != nil) {
                setUserLocation.setValue(userProfile.location)
            }
            
            if (userProfile.dateOfBirth != nil) {
                setDOB.setValue(userProfile.dateOfBirth)
            }
                
            else {
                print ("filled out nada")
            }
            
            setMonthsHelpNeeded.setValue(userProfile.datesHelpNeeded)
            
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
        //descriptionTextView.addSubview(placeholderLabel)
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
        
        print("PICKED")
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func setDatesHelpNeeded(aButton:UIButton?) {
        if (janurary.isSelected) {
            self.monthsNeeded.insert("Janurary")
        }
        
        if (february.isSelected) {
            self.monthsNeeded.insert("February")
        }
        
        if (march.isSelected) {
            self.monthsNeeded.insert("March")
        }
        
        if (april.isSelected) {
            self.monthsNeeded.insert("April")
        }
        
        if (may.isSelected) {
            self.monthsNeeded.insert("May")
        }
        
        if (june.isSelected) {
            self.monthsNeeded.insert("June")
        }
        
        if (july.isSelected) {
            self.monthsNeeded.insert("July")
        }
        
        if (august.isSelected) {
            self.monthsNeeded.insert("August")
        }
        
        if (september.isSelected) {
            self.monthsNeeded.insert("September")
        }
        
        if (october.isSelected) {
            self.monthsNeeded.insert("October")
        }
        
        if (november.isSelected) {
            self.monthsNeeded.insert("November")
        }
        if (december.isSelected) {
            self.monthsNeeded.insert("December")
        }
        else if (aButton == nil) {
            self.monthsNeeded.insert("Your months are empty")
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
