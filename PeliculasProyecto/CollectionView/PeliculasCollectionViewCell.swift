//
//  PeliculasCollectionViewCell.swift
//  PeliculasProyecto
//
//  Created by Arantxa Emanth Cuellar Torres on 15/09/22.
//

import UIKit

class PeliculasCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var peliculasCargaActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var peliculasTipeSalaLabel: UILabel!
    @IBOutlet weak var peliculasTipeLabel: UILabel!
    @IBOutlet weak var peliculasEdadLabel: UILabel!
    @IBOutlet weak var peliculasNameLabel: UILabel!
    @IBOutlet weak var peliculasImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        peliculasTipeLabel.layer.cornerRadius = peliculasTipeLabel.frame.size.height/4.5
        peliculasTipeLabel.layer.masksToBounds = true
        
        peliculasEdadLabel.layer.cornerRadius = peliculasEdadLabel.frame.size.height/4.5
        peliculasEdadLabel.layer.masksToBounds = true
        
        peliculasTipeSalaLabel.layer.cornerRadius = peliculasTipeSalaLabel.frame.size.height/4.5
        peliculasTipeSalaLabel.layer.masksToBounds = true
    }

}
