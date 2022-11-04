//
//  FilesTableViewCell.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-15.
//

import UIKit

class FilesTableViewCell: UITableViewCell {
    @IBOutlet weak var nombreArchivo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(nombre: String){
        nombreArchivo.text = nombre
    }
}
