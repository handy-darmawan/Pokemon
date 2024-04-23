//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import Foundation

struct PokemonModel {
    let id: Int
    let name: String
    let imageURL: URL
    let moves: [Species]
    let types: [Species]
    let weight: Int
}


struct PokemonDTO: Decodable {
    let id: Int
    let name: String
    let moves: [Move]
    let sprites: Sprites
    let types: [TypeElement]
    let weight: Int
}

extension PokemonDTO {
   static func map(_ dto: Self) -> PokemonModel {
       return PokemonModel(
        id: dto.id,
        name: dto.name,
        imageURL: URL(string: dto.sprites.frontShiny) ?? URL(string: "https://placehold.co/100x100")!,
        moves: dto.moves.map { $0.move },
        types: dto.types.map { $0.type },
        weight: dto.weight
       )
    }
}

// MARK: - Move
struct Move: Decodable {
    let move: Species
}

// MARK: - TypeElement
struct TypeElement: Decodable {
    let slot: Int
    let type: Species
}
// MARK: - Species
struct Species: Decodable {
    let name: String
    let url: String
}

struct Sprites: Decodable {
    let frontShiny: String
}
