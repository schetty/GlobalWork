//
//  HostTableViewCell.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class HostTableViewCell: UITableViewCell {
    
    @IBOutlet private var hostProfilePhotoImageView: UIImageView!
    
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
    
    
    private func loadHostPhotoFromDatabase(fromProfile: Profile) {
        if let profileImageURL = fromProfile.profilePhotoURL {
            let url = NSURL(string: profileImageURL)!
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                self.hostProfilePhotoImageView.layer.borderWidth = 1.0
                self.hostProfilePhotoImageView.layer.masksToBounds = false
                self.hostProfilePhotoImageView.layer.borderColor = UIColor.white.cgColor
                self.hostProfilePhotoImageView.layer.cornerRadius = self.hostProfilePhotoImageView.frame.size.width/2
                self.hostProfilePhotoImageView.clipsToBounds = true
                DispatchQueue.main.async {
                    let hostImage = UIImage(data: data!)
                    self.hostProfilePhotoImageView.image = hostImage
                }
                
                
            }).resume()
            
        }
    }

    func configureWithHostProfile(profile: Profile) {
        self.taglineLabel.text = profile.tagline
        self.descriptionTextView.text = profile.userDescription
        self.loadHostPhotoFromDatabase(fromProfile: profile)


    }
  }



