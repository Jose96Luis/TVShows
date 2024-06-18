//
//  TVShowsViewController.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 18/06/24.
//

import UIKit

class TVShowsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var shows: [TVShow] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadShows()
    }

    func loadShows() {
        // Lógica para cargar shows desde la API de TV Maze
        // Simulación de datos
        shows = [TVShow(name: "Breaking Bad", imageURL: URL(string: "https://example.com/image.jpg")!)]
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as! TVShowCell
        let show = shows[indexPath.row]
        cell.configure(with: show)
        return cell
    }
}

struct TVShow {
    let name: String
    let imageURL: URL
}

class TVShowCell: UITableViewCell {
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    func configure(with show: TVShow) {
        nameLabel.text = show.name
        // Cargar la imagen desde show.imageURL
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
        // Lógica para marcar como favorito
        print("favoriteTapped")
    }
}
