//
//  ViewController.swift
//  PeliculasProyecto
//
//  Created by Arantxa Emanth Cuellar Torres on 09/09/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var typeMoviesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contentPrincipalView: UIView!
    @IBOutlet weak var generosCollectionView: UICollectionView!
    @IBOutlet weak var peliculasCollectionView: UICollectionView!
    
    var generos: Generos?
    var peliculas: resultados?
    var cambiaGeneros: Int = 28
    var infoMovies: Movies?
    var noGenero = Generos.init(genres: [Genre]())
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View All Init")
        
        //MARK: Atributos para el segmentControl
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextSelected = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        let titleTextDisable = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        
        typeMoviesSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        typeMoviesSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        typeMoviesSegmentedControl.setTitleTextAttributes(titleTextSelected, for: .selected)
        typeMoviesSegmentedControl.setTitleTextAttributes(titleTextDisable, for: .disabled)
        typeMoviesSegmentedControl.backgroundColor = UIColor(hexString: "1E1F28")
        
        homeView.layer.cornerRadius = homeView.frame.size.height / 25.5
        homeView.layer.masksToBounds = true
        
        //MARK: Generos de películas
        self.generosCollectionView.register(UINib(nibName: "GenerosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
        
        self.generosCollectionView.delegate = self
        self.generosCollectionView.dataSource = self
        
        //MARK: Muestra Películas
        self.peliculasCollectionView.register(UINib(nibName: "PeliculasCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCellPeli")
        self.peliculasCollectionView.delegate = self
        self.peliculasCollectionView.dataSource = self
        
        
        //MARK: Obtiene todas las peliculas
        allGeneros {
            respuesta in
            self.generos = respuesta
            self.generosCollectionView.reloadData()
        }
        
        allMovies(genero: String(cambiaGeneros)) {
            respuesta in
            self.peliculas = respuesta
            DispatchQueue.main.async {
                () -> Void in
                self.peliculasCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func typeMoviesSegmentedControl(_ sender: Any) {
        switch typeMoviesSegmentedControl.selectedSegmentIndex {
        case 0:
            allMovies(genero: "28") {
                respuesta in
                self.peliculas = respuesta
                let ninosInfo = self.peliculas?.results[0]
                
                self.homeImageView.image = UIImage(named: "batman")
                
                DispatchQueue.main.async {
                    () -> Void in
                    self.peliculasCollectionView.reloadData()
                }
                
                allGeneros(completion: {
                    resultados in
                    self.generos = resultados
                    DispatchQueue.main.async {
                        () -> Void in
                        self.generosCollectionView.reloadData()
                    }
                })
            }
        case 1:
            allMovies(genero: "16") {
                respuesta in
                self.peliculas = respuesta
                let ninosInfo = self.peliculas?.results[0]
                
                if let poster = ninosInfo?.poster_path {
                    let imageString = "https://image.tmdb.org/t/p/original" + poster
                    let cacheString = NSString(string: imageString)
                    if let cacheImage = self.cache.object(forKey: cacheString) {
                        self.homeImageView.image = cacheImage
                    } else {
                        self.loadImage(from: URL(string: imageString)) {
                            [weak self] (image) in
                            guard let self = self, let image = image else { return }
                            self.homeImageView.image = image
                            self.cache.setObject(image, forKey: cacheString)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    () -> Void in
                    self.peliculasCollectionView.reloadData()
                }
                
                self.generos = self.noGenero
                DispatchQueue.main.async {
                    () -> Void in
                    self.generosCollectionView.reloadData()
                }
            }
        default:
            break
        }
    }
    
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: (url ?? URL(string: "404"))!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == generosCollectionView {
            return generos?.genres.count ?? 0
        }
        
        return peliculas?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellMovie = self.peliculasCollectionView.dequeueReusableCell(withReuseIdentifier: "customCellPeli", for: indexPath) as? PeliculasCollectionViewCell

        let current = peliculas?.results[indexPath.row]
        
        if let poster = current?.poster_path {
            let imageString = "https://image.tmdb.org/t/p/original" + poster
            let cacheString = NSString(string: imageString)
            
            cellMovie?.peliculasCargaActivityIndicator.startAnimating()

            if let cacheImage = self.cache.object(forKey: cacheString) {
                cellMovie?.peliculasImageView.image = cacheImage
                cellMovie?.peliculasCargaActivityIndicator.stopAnimating()
                cellMovie?.peliculasCargaActivityIndicator.hidesWhenStopped = true
            } else {
                self.loadImage(from: URL(string: imageString)) {
                    [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    cellMovie?.peliculasImageView.image = image
                    self.cache.setObject(image, forKey: cacheString)
                    cellMovie?.peliculasCargaActivityIndicator.stopAnimating()
                    cellMovie?.peliculasCargaActivityIndicator.hidesWhenStopped = true
                }
            }
        }
        
        cellMovie?.peliculasNameLabel.text = current?.original_title
        cellMovie?.peliculasEdadLabel.text = current?.release_date

        cellMovie?.peliculasTipeLabel.text = String(current?.vote_average ?? 0.0)
        cellMovie?.peliculasTipeSalaLabel.text = String(current?.popularity ?? 0.0)
        
        if collectionView == generosCollectionView {
            let cellGeneros = self.generosCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? GenerosCollectionViewCell
            let generosMuestra = generos?.genres[indexPath.row]
            cellGeneros?.generosLabel.text = generosMuestra?.name
            return cellGeneros!
        }
        
        return cellMovie!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == generosCollectionView {
            let current = generos!.genres[indexPath.row]
            cambiaGeneros = current.id
            let nothing = generosId(x: cambiaGeneros)
            
            allMovies(genero: nothing) {
                respuesta in
                self.peliculas = respuesta
                DispatchQueue.main.async {
                    () -> Void in
                    self.peliculasCollectionView.reloadData()
                }
            }
        }
        
        if collectionView == peliculasCollectionView {
            infoMovies = peliculas!.results[indexPath.row]
            performSegue(withIdentifier: "cellInfo", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetallePeliculaViewController {
            detailsVC.detallePelicula = infoMovies
        }
    }
}
