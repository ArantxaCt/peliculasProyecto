//
//  Generos.swift
//  PeliculasProyecto
//
//  Created by Arantxa Emanth Cuellar Torres on 12/09/22.
//

import Foundation

// MARK: - Generos
struct Generos: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
