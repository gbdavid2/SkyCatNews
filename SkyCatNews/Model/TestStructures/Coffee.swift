//
//  Coffee.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import Foundation

struct Coffee: Decodable, Identifiable {
    let id: Int
    let blend_name: String
    let origin: String
    let variety: String
    let notes: String
}
