//
//  ShowDetailViewController.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 18/06/24.
//

import UIKit
import Foundation

class ShowDetailViewController: UIViewController {
    var showId: Int?
    var show: TVShow?
    
    
    @IBOutlet weak var viewBaseDetail: UIView!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleViewBase()
        
        if let showId = showId {
            APIService.shared.fetchShowDetails(showId: showId) { result in
                switch result {
                case .success(let show):
                    self.show = show
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                case .failure(let error):
                    print("Error fetching show details: \(error)")
                }
            }
        }
    }
    
    private func styleViewBase() {
        viewBaseDetail.layer.cornerRadius = 20.0
        viewBaseDetail.layer.masksToBounds = false
        viewBaseDetail.layer.shadowColor = UIColor.purple.cgColor
        viewBaseDetail.layer.shadowOpacity = 0.2
        viewBaseDetail.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewBaseDetail.layer.shadowRadius = 8.0
        viewBaseDetail.layer.shadowPath = UIBezierPath(roundedRect: viewBaseDetail.bounds, cornerRadius: viewBaseDetail.layer.cornerRadius).cgPath
        viewBaseDetail.layer.borderColor = UIColor.purple.cgColor
        viewBaseDetail.layer.borderWidth = 2.0 
    }

    func updateUI() {
        guard let show = show else { return }
        nameLabel.text = show.name
        summaryLabel.text = show.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) // Removing HTML tags
        if let url = URL(string: show.image.original) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.showImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
