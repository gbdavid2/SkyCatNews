//
//  SkyCatNewsTests.swift
//  SkyCatNewsTests
//
//  Created by David Garces on 05/08/2022.
//

import XCTest
@testable import SkyCatNews

final class SkyCatNewsTests: XCTestCase {
    
    let storyFileProvider = FileProvider(filename: .sampleStory)
    let storiesFileProvider = FileProvider(filename: .sampleList)
    
    func testFileProviderCanDecodeBasicStoryProperties() {
        
        
        
        let story: Story? = storyFileProvider.parseData()
        
        guard let story = story else { return XCTFail("Test error creating story") }
        
        XCTAssertEqual(story.id, .storyID)
        XCTAssertEqual(story.headline, .storyHeadline)
        
    }
    
    func testFileProviderCanDecondeBasicStories() {
        let stories: Stories? = fetchLocalStoriesArray()
        
        guard let stories = stories else { return XCTFail("Test error creating stories") }
        
        XCTAssertEqual(stories.title, .skyTitle)
    }
    
    /// All `MediaItem` entries should have a `type` value decoded.
    func testCanDecodeMediaItemArray() {
        let stories: Stories? = fetchLocalStoriesArray()
        
        guard let stories = stories else { return XCTFail("Test error creating stories") }
        
        
        stories.data.forEach { print("id:\($0.type)") }
        
        stories.data.forEach { XCTAssertNotEqual($0.type.rawValue, "") }
        
    }
    
    func testMediaItem_StoryHasTeaserImage() {
        
    }
    
    
    // MARK: Reusable functions
    
    func fetchLocalStoriesArray() -> Stories? {
        let stories: Stories? = storiesFileProvider.parseData()
        
        guard let stories = stories else {
            XCTFail("Test error creating stories")
            return nil
        }
        
        return stories
    }
    
    
}
