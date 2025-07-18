//
//  FavoriteMovieManager.swift
//  Cinelogues
//
//  Created by AJ on 19/07/25.
//

//
//  FavoriteMovieManager.swift
//  Cinelogues
//
//  Created by AJ on 19/07/25.
//

import Foundation
import CoreData
import UIKit

class FavoriteMovieManager {
    static let shared = FavoriteMovieManager()

    private init() {}

    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate for Core Data context")
        }
        return appDelegate.persistentContainer.viewContext
    }

    func addToFavorites(movie: Movie) {
        // Avoid duplicates
        if isFavorite(movieID: String(movie.id)) {
            return
        }

        let favorite = FavoriteMoviesEntity(context: context)
        favorite.id = String(movie.id)
        favorite.title = movie.title
        favorite.overview = movie.overview
        favorite.posterPath = movie.posterPath
        favorite.backdropPath = movie.backdropPath
        favorite.releaseDate = movie.releaseDate
        favorite.voteAverage = movie.voteAverage
        favorite.genreIDS = movie.genreIDS.map { String($0) }.joined(separator: ",")
        favorite.originalLanguage = movie.originalLanguage

        do {
            try context.save()
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        } catch {
            print("❌ Error saving favorite movie: \(error.localizedDescription)")
        }
    }

    func removeFromFavorites(movieID: String) {
        let fetchRequest: NSFetchRequest<FavoriteMoviesEntity> = FavoriteMoviesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", movieID)

        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                try context.save()
                NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
            }
        } catch {
            print("❌ Error removing favorite movie: \(error.localizedDescription)")
        }
    }

    func isFavorite(movieID: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteMoviesEntity> = FavoriteMoviesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", movieID)

        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count > 0
    }

    func fetchAllFavorites() -> [FavoriteMoviesEntity] {
        let fetchRequest: NSFetchRequest<FavoriteMoviesEntity> = FavoriteMoviesEntity.fetchRequest()
        return (try? context.fetch(fetchRequest)) ?? []
    }
}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}


