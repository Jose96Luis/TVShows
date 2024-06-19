//
//  TVShowsViewController.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 18/06/24.
//

import UIKit
import Foundation

class TVShowsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var shows: [TVShow] = []
    var favorites: [String: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Registrar la celda desde el archivo NIB
        let nib = UINib(nibName: "TVShowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShowCell")
        loadFavorites()
        loadShows()
        
        self.title = "TV Shows"
    }
    
    func loadShows() {
        TVShowsManager.shared.loadShows() { result in
            switch result {
            case .success(let shows):
                DispatchQueue.main.async {
                    self.shows = shows
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Ocurrió un error al consultar el servicio. ¿Quieres intentar nuevamente?")
                }
                print("Error fetching shows: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as! TVShowCell
        let show = shows[indexPath.row]
        let isFavorite = favorites[show.name] ?? false
        cell.configure(with: show, isFavorite: isFavorite)
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = shows[indexPath.row]
        navigateToShowDetail(with: show)
        print("Navegando al detalle de la pelicula: \(show.name)")
        
    }
    
    func navigateToShowDetail(with show: TVShow) {
        let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as? ShowDetailViewController {
            detailVC.showId = show.id
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        let show = shows[sender.tag]
        let isFavorite = favorites[show.name] ?? false
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        if isFavorite {
            alert.title = "Confirmación"
            alert.message = "¿Estás seguro de que quieres eliminar este show de tus favoritos?"
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { _ in
                self.favorites[show.name] = false
                self.updateLocalStorage()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
        } else {
            alert.title = "Agregar a Favoritos"
            alert.message = "¿Quieres agregar este show a tus favoritos?"
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { _ in
                self.favorites[show.name] = true
                self.updateLocalStorage()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    func updateLocalStorage() {
        // Actualizar el almacenamiento local con los favoritos
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }
    
    func loadFavorites() {
        // Cargar favoritos del almacenamiento local
        if let savedFavorites = UserDefaults.standard.dictionary(forKey: "favorites") as? [String: Bool] {
            favorites = savedFavorites
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops, algo salió mal!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Intentar nuevamente", style: .default, handler: { _ in
            self.loadShows()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
