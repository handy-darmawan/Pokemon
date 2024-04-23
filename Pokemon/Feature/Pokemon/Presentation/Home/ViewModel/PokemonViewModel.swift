//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import Foundation

class PokemonViewModel {
    var pokemon: [PokemonList] = []
}

//MARK: Action
extension PokemonViewModel {
    func onLoad() async {
        await fetchPokemon()
    }
    
    private func fetchPokemon() async {
        await APICaller.shared.getPokemonList { [weak self] result in
            switch result {
            case .success(let model):
                self?.pokemon = model
            case .failure(let error):
                print("Failed to get pokemon: \(error)")
            }
        }
    }

}
