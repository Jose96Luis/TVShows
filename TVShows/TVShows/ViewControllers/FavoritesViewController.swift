//
//  FavoritesViewController.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 18/06/24.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteShows: [TVShow] = []
    var favorites: [String: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Registrar la celda desde el archivo NIB
        let nib = UINib(nibName: "TVShowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShowCell")
        loadFavorites()
        
        self.title = "Favoritos"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
        tableView.reloadData()
    }
    
    func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.dictionary(forKey: "favorites") as? [String: Bool] {
            favorites = savedFavorites
            favoriteShows = TVShowsManager.shared.getFavoriteShows()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as! TVShowCell
        let show = favoriteShows[indexPath.row]
        let isFavorite = favorites[show.name] ?? false
        cell.configure(with: show, isFavorite: isFavorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = favoriteShows[indexPath.row]
        navigateToShowDetail(with: show)
        print("Navegando al detalle de la película: \(show.name)")
    }
    
    func navigateToShowDetail(with show: TVShow) {
        let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as? ShowDetailViewController {
            detailVC.showId = show.id
            
            // Asegúrate de que el ViewController actual esté dentro de un UINavigationController
            if let navigationController = self.navigationController {
                navigationController.pushViewController(detailVC, animated: true)
            } else {
                print("Error: No se pudo encontrar el UINavigationController")
            }
        } else {
            print("Error: No se pudo instanciar ShowDetailViewController")
        }
    }
    
    //Método para manejar las acciones de deslizar
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if #available(iOS 13.0, *) {
            let show = favoriteShows[indexPath.row]
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { (action, view, completionHandler) in
                self.favorites[show.name] = false
                self.updateLocalStorage()
                self.loadFavorites()
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
                completionHandler(true)
            }
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        } else {
            return nil
        }
    }
    
    //Método para manejar las acciones de deslizar en iOS 10-12
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if #available(iOS 13.0, *) {
            return nil
        } else {
            let show = favoriteShows[indexPath.row]
            
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
                self.favorites[show.name] = false
                self.updateLocalStorage()
                self.loadFavorites()
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
            
            return [deleteAction]
        }
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        let show = favoriteShows[sender.tag]
        
        let alert = UIAlertController(title: "Confirmación", message: "¿Estás seguro de que quieres eliminar este show de tus favoritos?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { _ in
            self.favorites[show.name] = false
            self.updateLocalStorage()
            self.loadFavorites()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func updateLocalStorage() {
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }
}
