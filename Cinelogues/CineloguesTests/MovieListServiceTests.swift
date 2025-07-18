//
//  MovieListServiceTests.swift
//  Cinelogues
//
//  Created by AJ on 19/07/25.
//

import XCTest
@testable import Cinelogues

// MARK: - Mock URLSession and DataTask

class MockURLSession: URLSession, @unchecked Sendable {
    var mockData: Data?
    var mockError: Error?

    override func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return MockDataTask {
            completionHandler(self.mockData, nil, self.mockError)
        }
    }
}

class MockDataTask: URLSessionDataTask, @unchecked Sendable {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    override func resume() {
        closure()
    }
}

// MARK: - Test Class

final class MovieListServiceTests: XCTestCase {

    // Sample valid JSON response for tests
    func sampleMoviesJSON() -> Data {
        return """
        {
            "dates": null,
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "Inception",
                    "overview": "A mind-bending thriller.",
                    "poster_path": "/poster.jpg",
                    "backdrop_path": "/backdrop.jpg",
                    "release_date": "2010-07-16",
                    "vote_average": 8.8,
                    "genre_ids": [28, 12, 878],
                    "original_language": "en"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!
    }


    func testFetchMoviesSuccess() {
        let mockSession = MockURLSession()
        mockSession.mockData = sampleMoviesJSON()

        let service = MovieListService(session: mockSession)

        let expectation = self.expectation(description: "Movies fetched")

        service.fetchMovies(for: .popular) { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "Inception")
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchMoviesInvalidJSON() {
        let mockSession = MockURLSession()
        mockSession.mockData = "{invalid json}".data(using: .utf8)

        let service = MovieListService(session: mockSession)

        let expectation = self.expectation(description: "Parsing should fail")

        service.fetchMovies(for: .popular) { result in
            switch result {
            case .success:
                XCTFail("Expected failure for invalid JSON")
            case .failure:
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchMoviesWithError() {
        let mockSession = MockURLSession()
        mockSession.mockError = NSError(domain: "", code: -1009, userInfo: nil) // Simulate network error

        let service = MovieListService(session: mockSession)

        let expectation = self.expectation(description: "Should receive error")

        service.fetchMovies(for: .popular) { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

