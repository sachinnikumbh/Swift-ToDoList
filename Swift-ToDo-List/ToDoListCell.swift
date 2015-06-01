//
//  ToDoListCell.swift
//  Swift-ToDo-List
//
//  Created by Sachin Nikumbh on 28/05/15.
//  Copyright (c) 2015 SN. All rights reserved.
//

import UIKit

class ToDoListCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var switchAlart: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
