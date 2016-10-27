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
    
    @IBOutlet var hostProfilePhotoImageView: UIImageView!
    
    @IBOutlet var taglineLabel: UILabel!
    
    @IBOutlet var descriptionTextView: UITextView!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
