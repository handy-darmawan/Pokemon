//
//  PokemonListDTO.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import Foundation

struct PokemonListsDTO: Decodable {
    let results: [PokemonListDTO]
}

struct PokemonListDTO: Decodable {
    let name: String
    let url: String
}

extension PokemonListDTO {
    static func map(_ dto: Self) -> PokemonList {
        return PokemonList(
            id: UUID().uuidString,
            name: dto.name,
            url: dto.url
        )
    }
}
