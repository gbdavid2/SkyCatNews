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
}

extension Story {
    /// `sampleMediaItem` is meant to be used for debug purposes only, therefore the returned item is based on a forced unwrapping
    static var sampleStory: Story {
        let fileProvider = FileProvider(filename: .sampleStory)
        let item: Story? = fileProvider.parseData()
        return item!
    }
}
