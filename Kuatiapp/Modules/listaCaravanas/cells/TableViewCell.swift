//
//  TableViewCell.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-14.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var numberAnimal: UILabel!
    @IBOutlet weak var pesoLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if actualSelection != "pesaje" {
            pesoLabel.isHidden = true
            tagLabel.isHidden = true
//            print("actual selection is : \(actualSelection)")
        }
        // Configure the view for the selected state
    }
    func setupCell(numero: String,peso:Int){
        numberAnimal.text = numero
        pesoLabel.text = "\(peso) kg"
    }
    
}
