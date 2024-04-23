//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import Foundation

class PokemonDetailViewModel {
    var pokemon: PokemonModel?
    private var id: Int?
}

//MARK: Action
extension PokemonDetailViewModel {
    func onLoad() async {
        await fetchPokemon()
    }
    
    func configure(with url: String) {
        guard 
            let url = URL(string: url),
            let id = Int(url.lastPathComponent)
        else { return }
        self.id = id
    }
    
    private func fetchPokemon() async {
        guard let id = id else { return }
        await APICaller.shared.getPokemonDetail(with: id) { [weak self] result in
            switch result {
            case .success(let model):
                self?.pokemon = model
            case .failure(let error):
                print("Failed to get pokemon: \(error)")
            }
        }
    }
    
    func savePokemon(with pokemon: PokemonList) async {
        await CoreDataManager.shared.savePokemon(pokemon: pokemon)
    }
    
    func fetchProbability(handler: @escaping (Bool) -> Void) {
        let disGroup = DispatchGroup()
        Task {
            disGroup.enter()
            await APICaller.shared.getProbability { result in
                switch result {
                case .success(let message):
                    handler(message)
                    disGroup.leave()
                case .failure(let error):
                    print("Failed to get catch probability: \(error)")
                    disGroup.leave()
                }
            }
        }
    }
}
