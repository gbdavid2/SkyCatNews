//
//  Stories.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

struct Stories: Decodable {
    let title: String
    let data: [DataItem]
}

struct DataItem: Identifiable, Decodable {
    let id: Int
    let type: String
    let headline: String
    let teaserText: String
    let creationDate: String
    let modfiedDate: String
}
