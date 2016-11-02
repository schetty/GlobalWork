//
//  MessageCell.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-11-01.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var message: Message? {
        didSet {
            
           
            if let toId = message?.toId {
                let ref = FIRDatabase.database().reference().child("data/users/hosts").child(toId)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : AnyObject] {
                        self.nameText.text = dictionary["displayName"] as? String
                        
                    }
                })
                if let seconds = message?.timeStamp?.doubleValue {
                    let timestampDate = Date(timeIntervalSince1970: seconds)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm:ss a"
                    timeLabel.text = dateFormatter.string(from: timestampDate)

                }
                detailText.text = message?.text
                
            }
        }
        
        
    }
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
