//
//  HoTableViewCell.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/24.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class HoTableViewCell: UITableViewCell {

    @IBOutlet weak var displayTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
