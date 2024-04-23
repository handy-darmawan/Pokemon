//
//  PokemonList.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import Foundation
import CoreData

struct PokemonList {
    let id: String?
    var name: String
    let url: String
    
    init(id: String?, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
    
    init(with pokemon: PokemonModel) {
        let id = pokemon.imageURL.lastPathComponent
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        
        self.id = String(pokemon.id)
        self.name = pokemon.name
        self.url = urlString
    }
}

extension PokemonList {
    func toEntity(context: NSManagedObjectContext) -> Pokemon {
        let pokemon = Pokemon(context: context)
        pokemon.id = id
        pokemon.name = name
        pokemon.url = url
        return pokemon
    }
    
    static func toModel(_ entity: Pokemon) -> PokemonList {
        return PokemonList(
            id: entity.id,
            name: entity.name ?? "",
            url: entity.url ?? ""
        )
    }
}
