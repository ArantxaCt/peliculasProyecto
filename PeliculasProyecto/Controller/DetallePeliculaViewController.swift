//
//  DetallePeliculaViewController.swift
//  PeliculasProyecto
//
//  Created by Arantxa Emanth Cuellar Torres on 19/09/22.
//

import UIKit

class DetallePeliculaViewController: UIViewController {

    @IBOutlet weak var detalleDescripciónTextView: UITextView!
    @IBOutlet weak var detalleTituloPeliculaLabel: UILabel!
    @IBOutlet weak var trailerPeliculaLabel: UILabel!
    @IBOutlet weak var tipoSalaDetalleLabel: UILabel!
    @IBOutlet weak var generoPeliculaLabel: UILabel!
    @IBOutlet weak var edadPermitidaLabel: UILabel!
    @IBOutlet weak var getTicketsButton: UIButton!
    @IBOutlet weak var detallePeliculaImageView: UIImageView!
    @IBOutlet weak var detallePeliculaActivityIndicator: UIActivityIndicatorView!
    
    var detallePelicula: Movies?
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Cambiamos el color de nuestro botón en el navigation controller
        navigationController?.navigationBar.tintColor = UIColor.white
        
        detallePeliculaActivityIndicator.startAnimating()
        
        edadPermitidaLabel.text = "13 +"
        edadPermitidaLabel.layer.cornerRadius = edadPermitidaLabel.frame.size.height / 4.5
        edadPermitidaLabel.layer.masksToBounds = true
        
        //generoPeliculaLabel.text = detallePelicula?.genre_ids[0]
        switch detallePelicula?.genre_ids[0] {
        case 28:
            generoPeliculaLabel.text = "Acción"
        case 12:
            generoPeliculaLabel.text = "Aventura"
        case 16:
            generoPeliculaLabel.text = "Animación"
        case 35:
            generoPeliculaLabel.text = "Comedia"
        case 80:
            generoPeliculaLabel.text = "Crimen"
        case 99:
            generoPeliculaLabel.text = "Documental"
        case 18:
            generoPeliculaLabel.text = "Drama"
        case 10751:
            generoPeliculaLabel.text = "Familia"
        case 14:
            generoPeliculaLabel.text = "Fantasia"
        case 36:
            generoPeliculaLabel.text = "Historia"
        case 27:
            generoPeliculaLabel.text = "Terror"
        case 10402:
            generoPeliculaLabel.text = "Música"
        case 9648:
            generoPeliculaLabel.text = "Misterio"
        case 10749:
            generoPeliculaLabel.text = "Romance"
        case 878:
            generoPeliculaLabel.text = "Ciencia Ficción"
        case 10770:
            generoPeliculaLabel.text = "Película de TV"
        case 53:
            generoPeliculaLabel.text = "Suspenso"
        case 10752:
            generoPeliculaLabel.text = "Bélica"
        case 37:
            generoPeliculaLabel.text = "Western"
        default:
            generoPeliculaLabel.text = "N/A"
        }
        generoPeliculaLabel.layer.cornerRadius = generoPeliculaLabel.frame.size.height / 4.5
        generoPeliculaLabel.layer.masksToBounds = true
        
        tipoSalaDetalleLabel.text = "IMAX"
        tipoSalaDetalleLabel.layer.cornerRadius = tipoSalaDetalleLabel.frame.size.height / 4.5
        tipoSalaDetalleLabel.layer.masksToBounds = true
        
        trailerPeliculaLabel.text = "2 Trailers"
        trailerPeliculaLabel.layer.cornerRadius = trailerPeliculaLabel.frame.size.height / 4.5
        trailerPeliculaLabel.layer.masksToBounds = true
        
        detalleTituloPeliculaLabel.adjustsFontSizeToFitWidth = true
        detalleTituloPeliculaLabel.text = detallePelicula?.original_title
        detalleDescripciónTextView.text = detallePelicula?.overview
        detalleDescripciónTextView.isEditable = false
        
        if let peliImage = detallePelicula?.poster_path {
            let nameImagePeli = "https://image.tmdb.org/t/p/original" + peliImage
            let cacheString = NSString(string: nameImagePeli)
            if let cacheImg = self.cache.object(forKey: cacheString) {
                detallePeliculaImageView.image = cacheImg
                detallePeliculaActivityIndicator.stopAnimating()
                detallePeliculaActivityIndicator.hidesWhenStopped = true
            } else {
                self.loadImage(from: URL(string: nameImagePeli)) {
                    [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    self.detallePeliculaImageView.image = image
                    
                    self.cache.setObject(image, forKey: cacheString)
                }
            }
        }
    }
    
    private func loadImage(from url: URL?, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

}
