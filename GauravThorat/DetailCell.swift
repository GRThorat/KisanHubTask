//
//  DetailCell.swift
//  GauravThorat
//
//  Created by Mindbowser on 26/06/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var yearlabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var maxTempValueLabel: UILabel!
    @IBOutlet weak var minTempValueLabel: UILabel!
    @IBOutlet weak var sunshineValueLabel: UILabel!
    @IBOutlet weak var rainfallValueLabel: UILabel!
    @IBOutlet weak var meanTempValueLabel: UILabel!
    var detailModel = DetailModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        yearlabel.text = detailModel.year
        monthLabel.text = detailModel.key
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func downloadAction(_ sender: UIButton) {
    }
    
    
}
