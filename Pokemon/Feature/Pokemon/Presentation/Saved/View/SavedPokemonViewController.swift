//
//  SavedPokemonViewController.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import UIKit
import SDWebImage


class SavedPokemonViewController: UIViewController {
    //make tableview to show it from core data
    private let tableView = UITableView(frame: .zero)
    let viewModel = SavedPokemonViewModel()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await viewModel.onLoad()
            DispatchQueue.main.async { [ weak self ] in
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: - Action
extension SavedPokemonViewController {
    func setup() {
        title = "Saved Pokemon"
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource
extension SavedPokemonViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedPokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.identifier, for: indexPath) as? PokemonTableViewCell else { return UITableViewCell() }
        
        let pokemon = viewModel.savedPokemons[indexPath.row]
        cell.configure(with: pokemon)
        
        return cell
    }
    
    //swipe right -> delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Release") { [ weak self ] (_, _, _) in
            guard let self = self else { return }
            let pokemon = self.viewModel.savedPokemons[indexPath.row]
            var message = ""
            var title = ""
            
            self.viewModel.deletePokemon(with: pokemon) { isTrue in
                if isTrue {
                    title = "Success"
                    message = "Pokemon has been released"
                    DispatchQueue.main.async {
                        self.viewModel.savedPokemons.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                }
                else {
                    title = "Failed"
                    message = "Failed to release pokemon"
                }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    //swipe left -> rename
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rename = UIContextualAction(style: .normal, title: "Rename") { [ weak self ] (_, _, _) in
            guard let self = self else { return }
            let pokemon = self.viewModel.savedPokemons[indexPath.row]
            var message = ""
            var title = ""
            
            self.viewModel.renamePokemonName(from: pokemon) { isTrue, updatedName in
                if isTrue {
                    title = "Success"
                    message = "Pokemon has been renamed"
                    DispatchQueue.main.async {
                        self.viewModel.savedPokemons[indexPath.row].name = updatedName
                        self.tableView.reloadData()
                    }
                }
                else {
                    title = "Failed"
                    message = "Failed to rename pokemon"
                }
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [rename])
    }
}
