//
//  GenerosCollectionViewCell.swift
//  PeliculasProyecto
//
//  Created by Arantxa Emanth Cuellar Torres on 12/09/22.
//

import UIKit

class GenerosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var generosButton: UIButton!
    @IBOutlet weak var generosLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        generosLabel.adjustsFontSizeToFitWidth = true
    }

}
