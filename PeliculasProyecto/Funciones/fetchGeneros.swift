//
//  fetchGeneros.swift
//  PeliculasProyecto
//
//  Created by Arantxa Emanth Cuellar Torres on 12/09/22.
//

import Foundation

//MARK: Generos en espaniol
func allGeneros(completion: @escaping (Generos) -> Void) {
    let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=e861d1c0311a729b26c5101d0b6a788f&language=es-US")!
    
    URLSession.shared.dataTask(with: url) {
        data, response, error in
        if let data = data {
            if let generosData = try? JSONDecoder().decode(Generos.self, from: data) {
                DispatchQueue.main.async {
                    completion(generosData)
                    return
                }
            }
        }
    }.resume()
}

//MARK: Todas las películas
func allMovies(genero: String, completion: @escaping (resultados) -> Void) {
    let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=e861d1c0311a729b26c5101d0b6a788f&language=es-US&with_genres=" + genero)!
    
    URLSession.shared.dataTask(with: url) {
        data, response, error in
        if let data = data {
            if let movies = try? JSONDecoder().decode(resultados.self, from: data) {
                DispatchQueue.main.sync {
                    completion(movies)
                    return
                }
            }
        }
    }.resume()
}

func generosId(x: Int) -> String {
    
    var gen: String = "28"
    let generosId = [28,12,16,35,80,99,18,10751,14,36,27,10402,9648,10749,878,10770,53,10752,37]
    for genId in generosId {
        if x == genId {
            gen = String(genId)
        }
    }
    
    return gen
}
