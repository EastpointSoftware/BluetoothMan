//
//  BluetoothTableViewCell.swift
//  BlueToothMan
//
//  Created by Jeeva on 18/12/2015.
//  Copyright © 2015 Jeeva. All rights reserved.
//

import UIKit

class BluetoothTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var rssiLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
