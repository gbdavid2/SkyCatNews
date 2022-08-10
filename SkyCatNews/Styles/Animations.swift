//
//  Animations.swift
//  SkyCatNews
//
//  Created by David Garces on 10/08/2022.
//

import Foundation
import SwiftUI

extension Animation {
    static let openStory = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static let closeStory = Animation.spring(response: 0.6, dampingFraction: 0.9)
}
