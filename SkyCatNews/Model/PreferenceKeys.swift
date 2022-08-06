//
//  PreferenceKeys.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
