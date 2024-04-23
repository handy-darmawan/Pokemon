//
//  CoreDataManager.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pokemon")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    lazy var context = persistentContainer.viewContext

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

//MARK: Fetch
extension CoreDataManager {
    func fetchPokemons(completion: @escaping (Result<[PokemonList], Error>) -> Void) async {
        let request = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        do {
            let results = try context.fetch(request)
            let pokemons = results.map { PokemonList.toModel($0) }
            completion(.success(pokemons))
        } catch {
            print("Failed to fetch pokemons: \(error)")
            completion(.failure(error))
        }
    }
    
    func savePokemon(pokemon: PokemonList) async {
        //check id if exists
        guard let id = pokemon.id else { return }
        let request = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        let results = try? context.fetch(request)
        guard results?.isEmpty == true else { return }
        
        let _ = pokemon.toEntity(context: context)
        
        do {
            try context.save()
        } catch {
            print("Failed to save pokemon: \(error)")
        }
    }
    
    func deletePokemon(pokemon: PokemonList) async {
        guard let id = pokemon.id else { return }
        let request = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let pokemons = try context.fetch(request)
            pokemons.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Failed to delete pokemon: \(error)")
        }
    }
    
    func updatePokemon(pokemon: PokemonList, name: String, completion: @escaping (Bool) -> Void) async {
        guard let id = pokemon.id else { return }
        let request: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let pokemons = try context.fetch(request)
            pokemons.forEach {
                $0.name = name
            }
            try context.save()
            completion(true)
        } catch {
            print("Failed to update pokemon: \(error)")
            completion(false)
        }
    }
}
