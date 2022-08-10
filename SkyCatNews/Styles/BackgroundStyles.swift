//
//  BackgroundStyles.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import Foundation
import SwiftUI

struct BackgroundColor: ViewModifier {
    var opacity: Double = 0.6
    var cornerRadius: CGFloat = 20
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Color("Background")
                    .opacity(colorScheme == .dark ? opacity : 0)
                    .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            )
    }
}

extension View {
    func backgroundColor(opacity: Double = 0.6) -> some View {
        self.modifier(BackgroundColor(opacity: opacity))
    }
}

struct BackgroundStyle: ViewModifier {
    
    var cornerRadius: CGFloat = 20
    let opacity = 0.3
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .cornerRadius(cornerRadius)
            .shadow(color: Color("Shadow").opacity(opacity), radius: cornerRadius, x: 0, y: 10)
            .overlay(
                Color("Background")
                    .opacity(colorScheme == .dark ? opacity : 0)
                    .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            )
    }
}

extension View {
    func backgroundStyle(cornerRadius: CGFloat = 20) -> some View {
        self.modifier(BackgroundStyle(cornerRadius: cornerRadius))
    }
}
