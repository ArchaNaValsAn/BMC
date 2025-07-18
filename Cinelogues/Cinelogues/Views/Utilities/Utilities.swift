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
    func loadImage(from urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: "https://image.tmdb.org/t/p/w500\(urlString)") else {
            self.image = UIImage(named: "placeholder") // fallback image
            return
        }

        // ✅ Use URLCache or custom in-memory cache here
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }

        // async load
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                ImageCache.shared.setImage(image, forKey: urlString)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}

extension UIViewController {
    func showAlert(title: String = "Oops!", message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

