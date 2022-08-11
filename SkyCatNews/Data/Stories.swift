//
//  Stories.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

struct Stories: Decodable {
    let title: String
    let data: [MediaItem]
        
}

struct MediaItem: Decodable {
    let id: String?
    let type: MediaItemType
    let headline: String?
    let teaserText: String?
    let weblinkUrl: String?
    let url: String?
    let creationDate: String?
    let modifiedDate: String?
    let teaserImage: TeaserImage?
    let accessibilityText: String?
    
    enum MediaItemType: String, Decodable {
            case advert, story, weblink
    }
}

struct TeaserImage: Decodable {
    let _links: LinkItem
}

struct LinkItem: Decodable {
    let url: URLItem
}

struct URLItem: Decodable {
    let href: String
    let templated: Bool
    let type: URLType
    
    enum URLType: String, Decodable {
        case image = "image/jpeg"
    }
}

extension MediaItem {
    /// `sampleMediaItem` is meant to be used for debug purposes only, therefore the returned item is based on a forced unwrapping
    static func sampleMediaItem() -> MediaItem {
        let fileProvider = FileProvider(filename: .sampleList)
        let items: Stories? = fileProvider.parseData()
        return items!.data.first!
    }
}
