//
//  TravelerTableViewCell.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit

class TravelerTableViewCell: UITableViewCell {

    @IBOutlet private var travelerProfilePhotoImageView: UIImageView!
    
    @IBOutlet private var taglineLabel: UILabel!
    
    @IBOutlet private var descriptionTextView: UITextView!
    
    var profile:Profile?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    private func loadTravelerPhotoFromDatabase(fromProfile: Profile) {
        if let profileImageURL = fromProfile.profilePhotoURL {
            let url = NSURL(string: profileImageURL)!
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                self.travelerProfilePhotoImageView.layer.borderWidth = 1.0
                self.travelerProfilePhotoImageView.layer.masksToBounds = false
                self.travelerProfilePhotoImageView.layer.borderColor = UIColor.white.cgColor
                self.travelerProfilePhotoImageView.layer.cornerRadius = self.travelerProfilePhotoImageView.frame.size.width/2
                self.travelerProfilePhotoImageView.clipsToBounds = true
                DispatchQueue.main.async {
                    let travelerImage = UIImage(data: data!)
                    self.travelerProfilePhotoImageView.image = travelerImage
                }
                
                
            }).resume()
            
        }
    }
    
    func configureWithTravelerProfile(profile: Profile) {
        self.taglineLabel.text = profile.tagline
        self.descriptionTextView.text = profile.userDescription
        self.loadTravelerPhotoFromDatabase(fromProfile: profile)
        
        
    }
}



