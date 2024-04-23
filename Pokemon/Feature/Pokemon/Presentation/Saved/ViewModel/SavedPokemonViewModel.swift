//
//  SavedPokemonViewModel.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import Foundation

class SavedPokemonViewModel {
    var savedPokemons: [PokemonList] = []
    private var randomInt = 0
    
}

//MARK: Action
extension SavedPokemonViewModel {
    func onLoad() async {
        await fetchPokemons()
    }
    
    private func fetchPokemons() async {
        await CoreDataManager.shared.fetchPokemons { [ weak self ] in
            guard let self = self else { return }
            switch $0 {
            case .success(let pokemons):
                self.savedPokemons = pokemons
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deletePokemon(with pokemon: PokemonList, completion: @escaping (Bool) -> Void) {
        Task {
            //check if random prime
            await APICaller.shared.getPrime { [weak self] result in
                switch result {
                case .success(let randomInt):
                    self?.randomInt = randomInt
                    
                    if self?.isPrime(randomInt) == true {
                        Task {
                            await CoreDataManager.shared.deletePokemon(pokemon: pokemon)
                            print("deleted: \(randomInt)")
                            completion(true)
                        }
                    }
                    else {
                        print("failed to delete: \(randomInt)")
                        completion(false)
                    }
                    
                case .failure(let error):
                    print("Failed to get prime: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func renamePokemonName(from pokemon: PokemonList, completion: @escaping (Bool, String) -> Void) {
        Task {
            await APICaller.shared.getFibonacciLastName(name: pokemon.name) { result in
                switch result {
                case .success(let newName):
                    print("new name: \(newName)")
                    Task {
                        await CoreDataManager.shared.updatePokemon(pokemon: pokemon, name: newName) { result in
                            if result {
                                completion(true, newName)
                            }
                            else {
                                completion(false, "")
                            }
                        }
                    }
                case .failure(let error):
                    print("Failed to rename: \(error)")
                    completion(false, "")
                }
            }
        }
    }
    
}

//MARK: Helper
private extension SavedPokemonViewModel {
    func isPrime(_ number: Int) -> Bool {
        if number <= 1 { return false }
        for i in 2..<number {
            if number % i == 0 { return false }
        }
        return true
    }
}
