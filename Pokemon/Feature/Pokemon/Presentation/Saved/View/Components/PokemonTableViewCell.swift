//
//  PokemonTableViewCell.swift
//  Pokemon
//
//  Created by ndyyy on 23/04/24.
//

import UIKit
import SDWebImage

class PokemonTableViewCell: UITableViewCell {
    static let identifier = "PokemonTableViewCell"
    
    private let nameLabel = UILabel(frame: .zero)
    private let pokemonImageView = UIImageView(frame: .zero)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setup()
    }
}

//MARK: - Action
extension PokemonTableViewCell {
    func configure(with pokemon: PokemonList) {
        nameLabel.text = pokemon.name
        
        guard let url = URL(string: pokemon.url) else { return }
        let id = url.lastPathComponent
        guard let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(id)") else { return }
        pokemonImageView.sd_setImage(with: imageURL, completed: nil)
    }
}


//MARK: - Setup
extension PokemonTableViewCell {
    func setup() {
        setupImage()
        setupName()
    }
    
    func setupImage() {
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.contentMode = .scaleAspectFit
        
        addSubview(pokemonImageView)
        
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            pokemonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            pokemonImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setupName() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
