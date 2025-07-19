//
//  CineloguesUITests.swift
//  CineloguesUITests
//
//  Created by AJ on 17/07/25.
//

import XCTest

final class CineloguesUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testAddAndRemoveFromFavoritesFlow() {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5), "Movie collection view not found")

        // Tap on first movie cell
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "First movie cell not found")
        firstCell.tap()
        
        // Wait for movie title to ensure detail screen is shown
           let titleLabel = app.staticTexts["movieTitleLabel"]
           XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "Movie title not found")

        // Go back to movie list
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.exists, "Back button not found")
        backButton.tap()

        // Check if the favorited movie exists in the favorites collection view
        let favoritesCollection = app.collectionViews.firstMatch
        XCTAssertTrue(favoritesCollection.waitForExistence(timeout: 5), "Favorites collection view not found")

        let favoritedCell = favoritesCollection.cells.element(boundBy: 0)
        XCTAssertTrue(favoritedCell.exists, "Favorited movie not found in favorites list")

        // Tap on the movie again in favorites to go to details
        favoritedCell.tap()

        // Go back
        backButton.tap()
    }
}

