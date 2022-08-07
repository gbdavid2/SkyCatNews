//
//  SkyCatNewsTests.swift
//  SkyCatNewsTests
//
//  Created by David Garces on 05/08/2022.
//

import XCTest
@testable import SkyCatNews

final class SkyCatNewsTests: XCTestCase {
    
    
    func testFileProviderCanDecodeName() {
        let fileProvider = FileProvider()
        let story: Story? = fileProvider.load(.sampleStory)
        
        guard let story = story else { return XCTFail("Empty story") }
        
        XCTAssertEqual(story.id, .storyID)
        XCTAssertEqual(story.headline, .storyHeadline)
        
    }
    
    
    func testNetworkProviderRequestsRealData() {
        let networkProvider = NetworkProvider()
        networkProvider.requestData()
    }
    
    
}
