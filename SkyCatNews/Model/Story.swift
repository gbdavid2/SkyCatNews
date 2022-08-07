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
