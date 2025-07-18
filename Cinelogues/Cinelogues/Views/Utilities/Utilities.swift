//
//  Utilities.swift
//  Cinelogues
//
//  Created by AJ on 18/07/25.
//

import UIKit

extension UIButton {
    func updateFavoriteAppearance(isFavorited: Bool) {
        let imageName = isFavorited ? "heart.fill" : "heart"
        setImage(UIImage(systemName: imageName), for: .normal)
        tintColor = isFavorited ? .systemRed : .lightGray
      
    }
}


extension UIImageView {
    func loadImage(from path: String?, placeholder: UIImage? = nil) {
        guard let path = path else {
            self.image = placeholder
            return
        }
        let urlString = "https://image.tmdb.org/t/p/w500\(path)"
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        self.image = placeholder

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

