//
//  SkyCatNewsUITests.swift
//  SkyCatNewsUITests
//
//  Created by David Garces on 05/08/2022.
//

import XCTest

final class SkyCatNewsUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }
    
    func testCanDisplayTitle() {
        XCTAssertTrue(app.staticTexts[.skyTitle].isHittable)
    }
    
    func testCanDisplayNewsSection() {
        XCTAssertTrue(app.staticTexts[.newsSection.uppercased()].isHittable)
    }
    
    func testCanDisplayStoriesView() {
        let storiesView = app.staticTexts[.storiesViewIdentifier]
        XCTAssertTrue(storiesView.isHittable)
    }
}
