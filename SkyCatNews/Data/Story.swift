//
//  Story.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

/// `Story` holds data about each news item and it's contents
struct Story: Identifiable, Decodable {
    let id: String
    let headline: String
    let heroImage: HeroImage
    let creationDate: String
    let modifiedDate: String
    let contents: [StoryContent]

}

struct StoryContent: Decodable {
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

extension Story {
    /// `sampleMediaItem` is meant to be used for debug purposes only, therefore the returned item is based on a forced unwrapping
    static var sampleStory: Story {
        let fileProvider = FileProvider(filename: .sampleStory)
        let item: Story? = fileProvider.parseData()
        return item!
    }
}
