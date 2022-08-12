//
//  Story.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

/// `Story` holds data about each news item and it's contents
struct StoryData: Identifiable, Decodable {
    let id: String
    let headline: String
    let heroImage: HeroImage
    let creationDate: String
    let modifiedDate: String
    let contents: [StoryDataContent]
}

struct StoryDataContent: Decodable {
    let type: StoryItemType
    let text: String?
    let url: String?
    let accessibilityText: String?
    
    enum StoryItemType: String, Decodable {
            case paragraph, image
    }
}

struct HeroImage: Decodable {
    let imageUrl: String
    let accessibilityText: String
}

extension StoryData {
    /// `sampleMediaItem` is meant to be used for debug purposes only, therefore the returned item is based on a forced unwrapping
    static var sampleStory: StoryData {
        let fileProvider = FileProvider(filename: .sampleStory)
        let item: StoryData? = fileProvider.parseData()
        return item!
    }
}
