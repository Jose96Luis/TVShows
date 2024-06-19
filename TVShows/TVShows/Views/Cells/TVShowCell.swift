//
//  TVShowCell.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 18/06/24.
//

import Foundation
import UIKit

class TVShowCell: UITableViewCell {
    
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var isFavorite: Bool = false {
        didSet {
            updateFavoriteButton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleViewBase()
        styleImageView()
        styleBntFav()

    }
    
    private func styleViewBase() {
        viewBase.layer.cornerRadius = 20.0
        viewBase.layer.masksToBounds = false
        viewBase.layer.shadowColor = UIColor.purple.cgColor
        viewBase.layer.shadowOpacity = 0.2
        viewBase.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewBase.layer.shadowRadius = 8.0
        viewBase.layer.shadowPath = UIBezierPath(roundedRect: viewBase.bounds, cornerRadius: viewBase.layer.cornerRadius).cgPath
        
        // Cambiar el color de fondo a morado
        viewBase.backgroundColor = UIColor.purple
    }
    
    private func styleImageView() {
        showImageView.layer.cornerRadius = 20.0
        showImageView.layer.borderWidth = 5.0
        showImageView.layer.masksToBounds = true
        showImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func styleBntFav() {
        showImageView.layer.cornerRadius = 20.0
        
    }

    func configure(with show: TVShow, isFavorite: Bool) {
        nameLabel.text = show.name
        self.isFavorite = isFavorite

        // Cargar la imagen de manera asincrónica
        if let url = URL(string: show.image.medium) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.showImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        if isFavorite {
            favoriteButton.setTitle("Delete", for: .normal)
            favoriteButton.backgroundColor = .red
            favoriteButton.setTitleColor(.white, for: .normal)
        } else {
            favoriteButton.setTitle("Favorite", for: .normal)
            favoriteButton.backgroundColor = .green
            favoriteButton.setTitleColor(.white, for: .normal)
        }
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
        isFavorite.toggle()
        updateFavoriteButton()
        // Lógica para marcar o desmarcar como favorito
        print("favoriteTapped")
    }
}

