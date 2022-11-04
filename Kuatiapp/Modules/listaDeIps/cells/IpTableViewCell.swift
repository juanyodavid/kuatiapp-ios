//
//  IpTableViewCell.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-10.
//

import UIKit

class IpTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(nombre: String, direction: String){
        nameLabel.text = nombre
        directionLabel.text = direction
    }
}
