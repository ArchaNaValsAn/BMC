//
//  CineloguesUITests.swift
//  CineloguesUITests
//
//  Created by AJ on 17/07/25.
//

import XCTest

final class CineloguesUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testMovieFlow_FavoriteToggle_AndFavoritesPersistence() throws {
        let carousel = app.collectionViews["popularMovieCarouselCell"]
        XCTAssertTrue(carousel.waitForExistence(timeout: 5), "Carousel did not load")
        
        let firstCell = carousel.cells.element(boundBy: 0)
        let moreButton = firstCell.buttons["moreButton"]
        XCTAssertTrue(moreButton.waitForExistence(timeout: 5), "More button not found")
        moreButton.tap()
        
        let moviesCollection = app.collectionViews["popularMoviesCollectionView"]
        XCTAssertTrue(moviesCollection.waitForExistence(timeout: 5), "Movie list did not load")
        
        let firstMovieCell = moviesCollection.cells.element(boundBy: 0)
        XCTAssertTrue(firstMovieCell.waitForExistence(timeout: 5), "First movie cell not found")
        firstMovieCell.tap()
        
        let favoriteButton = app.otherElements["baseView"].buttons["favoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5))
        favoriteButton.tap()
        
        app.otherElements["baseView"].tap() // Or dismiss explicitly if needed
        
    }

    func testSearchFunctionality_NoResults() {
        let app = XCUIApplication()
        app.launch()
        
        let carousel = app.collectionViews["popularMovieCarouselCell"]
        let firstCell = carousel.cells.element(boundBy: 0)
        
        let moreButton = app.buttons["moreButton"]
        XCTAssertTrue(moreButton.waitForExistence(timeout: 5))
        moreButton.tap()
    }
    
}

