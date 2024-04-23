//
//  APICaller.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    func getPokemonList(completion: @escaping (Result<[PokemonList], Error>) -> Void) async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=50") else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(PokemonListsDTO.self, from: data)
            let lists = result.results.map { PokemonListDTO.map($0) }
            completion(.success(lists))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getPokemonDetail(with id: Int, completion: @escaping (Result<PokemonModel, Error>) -> Void) async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/") else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(PokemonDTO.self, from: data)
            completion(.success(PokemonDTO.map(result)))
        } catch {
            completion(.failure(error))
        }
    }
}


struct BooleanResponse: Decodable {
    let message: Bool
}

struct IntegerResponse: Decodable {
    let message: Int
}

struct StringResponse: Decodable {
    let message: String
}


//MARK: 3 REST API
extension APICaller {
    func getProbability(completion: @escaping (Result<Bool, Error>) -> Void) async {
        guard let url = URL(string: "http:localhost:8080/catch") else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(BooleanResponse.self, from: data)
            completion(.success(result.message))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getPrime(completion: @escaping (Result<Int, Error>) -> Void) async {
        guard let url = URL(string: "http:localhost:8080/prime") else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(IntegerResponse.self, from: data)
            completion(.success(result.message))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getFibonacciLastName(name: String, completion: @escaping (Result<String, Error>) -> Void) async {
        guard let url = URL(string: "http:localhost:8080/rename") else {
            return
        }
        
        //add query param
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems = [URLQueryItem(name: "name", value: name)]
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(StringResponse.self, from: data)
            completion(.success(result.message))
        } catch {
            completion(.failure(error))
        }
    }
    
}
