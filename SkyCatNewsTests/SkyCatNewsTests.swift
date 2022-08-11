//
//  SkyCatNewsTests.swift
//  SkyCatNewsTests
//
//  Created by David Garces on 05/08/2022.
//

import XCTest
import SwiftUI
@testable import SkyCatNews

final class SkyCatNewsTests: XCTestCase {
    
    /// `storyFileProvider` and `storiesFileProvider` comform to `DecodeProviding` so you can easily swap them to a different provider (e.g. to test network data)
    /// for example  `storyProvider = NetworkProvider()` then all the executions of `storyProvider.parseData()` will trigger a network request instead.
    let storyProvider = FileProvider(filename: .sampleStory)
    let storiesProvider = FileProvider(filename: .sampleList)
    
    // MARK: FileProvider tests
    
    func testFileProviderCanDecodeBasicStoryProperties() {
        let story: StoryData? = storyProvider.parseData()
        
        guard let story = story else { return XCTFail("Test error creating story") }
        
        XCTAssertEqual(story.id, .storyID)
        XCTAssertEqual(story.headline, .storyHeadline)
        XCTAssertTrue(story.contents.count > 0)
        XCTAssertTrue(story.contents.filter { $0.type == .paragraph }.count > 0)
        XCTAssertTrue(story.contents.filter { $0.type == .image }.count > 0)
        // other data validation tests could be performed here once we have more data samples from the server.
    }
    
    func testFileProviderCanDecondeBasicStories() {
        let stories: StoriesDataFeed = fetchLocalStoriesArray()

        XCTAssertNotEqual(stories.title, .skyTitle)
        XCTAssertNotEqual(stories.title, "")
    }
    
    /// All `MediaItem` entries should have a `type` value decoded.
    func testCanDecodeMediaItemArray() {
        let stories: StoriesDataFeed = fetchLocalStoriesArray()
        
        stories.data.forEach { print("id:\($0.type)") }
        
        stories.data.forEach { XCTAssertNotEqual($0.type.rawValue, "") }
        
    }
    
    func testMediaItem_StoryHasTeaserImage() {
        let stories: StoriesDataFeed = fetchLocalStoriesArray()
        // check that a story and a web link exist to proceed with this test
        let dataStories = stories.data.filter { $0.type == .story }
        let webLinks = stories.data.filter { $0.type == .weblink }
        
        XCTAssertTrue(dataStories.count > 0)
        XCTAssertTrue(webLinks.count > 0)
        
        dataStories.forEach { XCTAssertNotNil($0.teaserImage) }
        webLinks.forEach { XCTAssertNotNil($0.teaserImage) }
        
        // test contents of random element - from the sample file we can see that all elements have "image/jpeg" as the return value
        XCTAssertEqual(dataStories.randomElement()?.teaserImage?._links.url.type, URLItem.URLType.image)
        XCTAssertEqual(webLinks.randomElement()?.teaserImage?._links.url.type, URLItem.URLType.image)
        
    }
    
    // MARK: URL Tests
    
    func testValidURLs() {
        print(URL.newsListURL.absoluteString)
        print(URL.storyURL(storyID: 1).absoluteString)
        print(URL.coffeeURL.absoluteString)
        print(URL.randomImageURL_small.absoluteString)
        print(URL.randomImageURL_large.absoluteString)
        
        XCTAssertNotEqual(URL.newsListURL.absoluteString,"")
        XCTAssertNotEqual(URL.storyURL(storyID: 1).absoluteString,"")
        XCTAssertNotEqual(URL.coffeeURL.absoluteString,"")
        XCTAssertNotEqual(URL.randomImageURL_small.absoluteString,"")
        XCTAssertNotEqual(URL.randomImageURL_large.absoluteString,"")
    }
    
    // MARK: Network provider tests
    
    func testCanGetRandomImageFromNetwork() async {
        let image1 = AsyncImage(url: URL.randomImageURL_large)
        let image2 = AsyncImage(url: URL.randomImageURL_small)
        XCTAssertNotNil(image1)
        XCTAssertNotNil(image2)
    }
    
    /// Although this test is not directly testing the `Story` or `Stories` structures (which are the main structures for our app), We are aiming to test our `NetworkProvider` with a real network connection to a test server. In this case our test will succeed if `networkProvider.parseData()` can successfully connect to the provided `URL` and can successfully retrieve the data from it and parse it. In future implemenations we can simply modify the test to retrieve a `story` from the server using the same `networkProvider` but giving it a different `URL`
    func testCanGetCoffeeFromNetwork() async {
        let networkProvider: DecodeProviding = NetworkProvider(url: URL.coffeeURL)
        let coffee: Coffee? = await networkProvider.parseData()
        guard let coffee = coffee else {
            XCTFail("Test error creating network coffee")
            return
        }
        XCTAssertNotEqual(coffee.id, 0)
    }
    
    // MARK: Date tests
    func testCanConvertDateFromUTCString() {
        let testDates = getTestDates()
        
        print(testDates.validDate1)
        XCTAssertNotNil(testDates.validDate1)
        XCTAssertNotNil(testDates.validDate2)
    }
    
    func testCanCalculateHoursForDate() {
        let testDates = getTestDates()
        
        // attempt to calculate minutes for oldDate first then newDate
        let result1 = Date.minutesBetweenDates(testDates.validDate1, testDates.validDate2)
        print("Result time is \(result1)")
        XCTAssertTrue(result1 > 0)
        
        // attempt to calcualte minutes for newDate first then oldDate
        let result2 = Date.minutesBetweenDates(testDates.validDate2, testDates.validDate1)
         print("Result time is \(result2)")
         XCTAssertTrue(result2 < 0)
    }
    
    func testCanCalculateDaysHours() {
        let testDates = getTestDates()
        let result1 = Calendar.calculateTimeFromDate(fromDate: testDates.validDate1)
        let result2 = Calendar.calculateTimeFromDate(fromDate: testDates.validDate1)
        // since both results happened quite a while ago, we expect them to be days ago
        XCTAssertEqual(result1.component, .day)
        XCTAssertEqual(result2.component, .day)
        XCTAssertTrue(result1.time > 0)
        XCTAssertTrue(result2.time > 0)
        
        // test adding Today - 3 hours
        let result3 = Calendar.calculateTimeFromDate(fromDate: Date().addingTimeInterval(-(60*60*3)))
        XCTAssertTrue(result3.time == 3)
        print("Calcualted time is \(result3)")
        XCTAssertEqual(result3.component, .hour)
        
        // test adding Today - 4 minutes
        let result4 = Calendar.calculateTimeFromDate(fromDate: Date().addingTimeInterval(-(60*4)))
        XCTAssertTrue(result4.time == 4)
        print("Calcualted time is \(result4)")
        XCTAssertEqual(result4.component, .minute)
        
        // test adding Today + 2 hours - in this case we are setting the logic to return 0 whenever the date is in the future - we might need to change the logic based on user requirements.
        let result5 = Calendar.calculateTimeFromDate(fromDate: Date().addingTimeInterval((60*60*2)))
        XCTAssertTrue(result5.time == 0)
        print("Calcualted time is \(result4)")
        XCTAssertEqual(result5.component, .minute)
    }
    
    func testCalculateMostRecentDate() {
        let testDates = getTestDates()
        let result1 = Date.calculateMostRecentDate(date1: .creationDate1, date2: .modifiedDate1)
        XCTAssertTrue(result1 == testDates.validDate2)
        
        let result2 = Date.calculateMostRecentDate(date1: .modifiedDate1, date2: .creationDate1)
        XCTAssertTrue(result2 == testDates.validDate2)
        
        let date3 = "2022-05-18T00:00:00Z"
        let date3Converted = Date.convert(fromString: date3)
        let result3 = Date.calculateMostRecentDate(date1: .modifiedDate1, date2: date3)
        XCTAssertTrue(result3 == date3Converted)
    }
    
    // MARK: Story tests
    func testAdvertCannotChangeType() {
        var newsRepresentable: NewsRepresentable
        newsRepresentable = Advert(url: .randomImageURL_small)
        XCTAssertEqual(newsRepresentable.getMediaType(), .advert)
    }
    

    
    // MARK: Reusable functions
    
    func fetchLocalStoriesArray() -> StoriesDataFeed {
        let stories: StoriesDataFeed? = storiesProvider.parseData()
        
        guard let stories = stories else {
            XCTFail("Test error creating stories")
            return StoriesDataFeed(title: "", data: [MediaItem]()) /// this value won't be returned because `XCTFail` will stop execution - but we still need to decalre this so the compiler accepts it.
        }
        
        return stories
    }
    
    func getTestDates() -> (validDate1: Date, validDate2: Date) {
        guard let validDate1 = Date.convert(fromString: .creationDate1), let validDate2 = Date.convert(fromString: .modifiedDate1) else {
            XCTFail("Failed to convert strings to dates - test cannot proceed")
            return (Date(), Date())
        }
        return (validDate1, validDate2)
    }
    
    
}
