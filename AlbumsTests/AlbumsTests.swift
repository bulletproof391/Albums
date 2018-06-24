//
//  AlbumsTests.swift
//  AlbumsTests
//
//  Created by Дмитрий Вашлаев on 24.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import XCTest
@testable import Albums

class AlbumsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSearchAlbumsWithName() {
        let iTunes = ItunesAPI()
        // Create an expectation
        let expectation = XCTestExpectation(description: "Fetching")
        var resultCount = 0
        
        
        iTunes.downloadAlbums(withName: "Noize mc") {(fetchedData) in
            do {
                guard let data = fetchedData else { return }
                // Parsing JSON
                let result = try JSONDecoder().decode(ItunesReplyByAlbums.self, from: data)
                if result.resultCount != nil {
                   resultCount = result.resultCount!
                }
                
                // Fullfil the expectation to let the test runner
                // know that it's OK to proceed
                expectation.fulfill()
            } catch _ {
                XCTAssertGreaterThan(resultCount, 0)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertGreaterThan(resultCount, 0)
    }
    
}
