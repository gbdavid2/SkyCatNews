//
//  File.swift
//  SkyCatNews
//
//  Created by David Garces on 11/08/2022.
//

import Foundation

struct Stories { 
    let stories: [NewsRepresentable]
}

protocol NewsRepresentable {
}

struct Story: NewsRepresentable {
    let headline: String
    let updated: String // this should be computed and based on a calulcation of the modified date - or creaction date if modified is empty
    let teaserText: String
    let teaserImage: NewsImage
    let heroImage: NewsImage
    let content: [StoryRepresentable]
}

protocol StoryRepresentable {
}

struct NewsImage: StoryRepresentable {
    let imageURL: URL
    let accessibilityText: String
}
struct NewsParagraph: StoryRepresentable {
    let text: String
}

struct WebLink: NewsRepresentable {
    let headline: String
    let updated: String // this should be computed and based on a calulcation of the modified date - or creaction date if modified is empty
    let url: URL
    let teaserImage: NewsImage
}

struct Advert: NewsRepresentable {
    let url: URL
}
