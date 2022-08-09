//
//  SkyCatNewsTests.swift
//  SkyCatNewsTests
//
//  Created by David Garces on 05/08/2022.
//

import XCTest
@testable import SkyCatNews

final class SkyCatNewsTests: XCTestCase {
    
    /// `storyFileProvider` and `storiesFileProvider` comform to `DecodeProviding` so you can easily swap them to a different provider (e.g. to test network data)
    /// for example  `storyProvider = NetworkProvider()` then all the executions of `storyProvider.parseData()` will trigger a network request instead.
    let storyProvider = FileProvider(filename: .sampleStory)
    let storiesProvider = FileProvider(filename: .sampleList)
    
    func testFileProviderCanDecodeBasicStoryProperties() {
        let story: Story? = storyProvider.parseData()
        
        guard let story = story else { return XCTFail("Test error creating story") }
        
        XCTAssertEqual(story.id, .storyID)
        XCTAssertEqual(story.headline, .storyHeadline)
        
    }
    
    func testFileProviderCanDecondeBasicStories() {
        let stories: Stories = fetchLocalStoriesArray()

        XCTAssertEqual(stories.title, .skyTitle)
    }
    
    /// All `MediaItem` entries should have a `type` value decoded.
    func testCanDecodeMediaItemArray() {
        let stories: Stories = fetchLocalStoriesArray()
        
        stories.data.forEach { print("id:\($0.type)") }
        
        stories.data.forEach { XCTAssertNotEqual($0.type.rawValue, "") }
        
    }
    
    func testMediaItem_StoryHasTeaserImage() {
        let stories: Stories = fetchLocalStoriesArray()
        // check that a story and a web link exist to proceed with this test
        let dataStories = stories.data.filter { $0.type == .story }
        let webLinks = stories.data.filter { $0.type == .weblink }
        
        XCTAssertTrue(dataStories.count > 0)
        XCTAssertTrue(webLinks.count > 0)
        
        dataStories.forEach { XCTAssertNotNil($0.teaserImage) }
        webLinks.forEach { XCTAssertNotNil($0.teaserImage) }
        
        // test contents of random element - from the sample file we can see that all elements have "image/jpeg" as the return value
        XCTAssertEqual(dataStories.randomElement()?.teaserImage?._links.url.type, "image/jpeg")
        XCTAssertEqual(webLinks.randomElement()?.teaserImage?._links.url.type, "image/jpeg")
        
    }
    
    // MARK: URL Tests
    
    func testValidURLs() {
        XCTAssertNotEqual(URL.newsListURL.absoluteString,"")
        XCTAssertNotEqual(URL.storyURL(storyID: 1).absoluteString,"")
        XCTAssertNotEqual(URL.coffeeURL.absoluteString,"")
        XCTAssertNotEqual(URL.randomImageURL.absoluteString,"")
    }
    
    
    // MARK: Reusable functions
    
    func fetchLocalStoriesArray() -> Stories {
        let stories: Stories? = storiesProvider.parseData()
        
        guard let stories = stories else {
            XCTFail("Test error creating stories")
            return Stories(title: "", data: [MediaItem]()) /// this value won't be returned because `XCTFail` will stop execution - but we still need to decalre this so the compiler accepts it.
        }
        
        return stories
    }
    
    
}
