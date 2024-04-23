//
//  PokemonDetailViewController.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    private let imageView = UIImageView(frame: .zero)
    private let catchButton = UIButton(frame: .zero)
    private let types = UILabel(frame: .zero)
    private let moves = UITableView(frame: .zero)
    
    let viewModel = PokemonDetailViewModel()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        setup()
        Task {
            await viewModel.onLoad()
            DispatchQueue.main.async { [ weak self ] in
                self?.moves.reloadData()
                self?.configure()
            }
        }
    }
}

//MARK: - Action
extension PokemonDetailViewController {
    func configure() {
        guard let pokemon = viewModel.pokemon else { return }
        imageView.sd_setImage(with: pokemon.imageURL)
        types.text = "Types: \(pokemon.types.map { $0.name.capitalized }.joined(separator: ", "))"
    }
    
    @objc func catchPokemon() {
        viewModel.fetchProbability { [weak self] result in
            DispatchQueue.main.async {
                var message = ""
                var title = ""
                if result {
                    message = "You've caught a Pokémon!"
                    title = "Congratulations!"
                    Task {
                        guard let pokemon = self?.viewModel.pokemon else { return }
                        let pokemonList = PokemonList(with: pokemon)
                        await self?.viewModel.savePokemon(with: pokemonList)
                    }
                }
                else {
                    title = "Oh no!"
                    message = "Uh-oh! Looks like Pikachu couldn't be caught."
                }
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - Setup
private extension PokemonDetailViewController {
    func setup() {
        setupImage()
        setupCatchButton()
        setupTypes()
        setupMoves()
    }
    
    func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func setupCatchButton() {
        catchButton.translatesAutoresizingMaskIntoConstraints = false
        catchButton.setTitle("Catch", for: .normal)
        catchButton.configuration = .bordered()
        catchButton.addTarget(self, action: #selector(catchPokemon), for: .touchUpInside)
        view.addSubview(catchButton)
        
        NSLayoutConstraint.activate([
            catchButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            catchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            catchButton.widthAnchor.constraint(equalToConstant: 100),
            catchButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupTypes() {
        types.translatesAutoresizingMaskIntoConstraints = false
        types.numberOfLines = 0
        view.addSubview(types)
        
        NSLayoutConstraint.activate([
            types.topAnchor.constraint(equalTo: catchButton.bottomAnchor, constant: 16),
            types.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            types.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupMoves() {
        moves.translatesAutoresizingMaskIntoConstraints = false
        moves.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        moves.delegate = self
        moves.dataSource = self
        view.addSubview(moves)
        
        NSLayoutConstraint.activate([
            moves.topAnchor.constraint(equalTo: types.bottomAnchor, constant: 16),
            moves.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moves.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            moves.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: Delegate
extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemon?.moves.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.pokemon?.moves[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Moves"
    }
}
