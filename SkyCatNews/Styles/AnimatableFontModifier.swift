//
//  AnimatableFontModifier.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import SwiftUI

/// The following technique won't animate the font: `.font(.system(size: hasScrolled ? 22 : 34))`
/// Therefore we need to create the `AnimatableFontModifier` implementation below to animate our font
struct AnimatableFontModifier: AnimatableModifier {
    var size: Double
    var weight: Font.Weight = .regular
    var design: Font.Design = .default
    
    var animatableData: Double {
        get { size }
        set { size = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

/// An extension to view can help us make shorter calls to `AnimatableFontModifier`
extension View {
    func animatableFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
    }
}

struct AnimatableFontModifier_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            /// Demo text when content has **scrolled**
            Text(verbatim: .skyTitle)
                .animatableFont(size: .titleSmall, weight: .bold)
                .opacity(.titleFaded)
            
            /// Demo text when content has not scrolled yet
            Text(verbatim: .skyTitle)
                .animatableFont(size: .titleLarge, weight: .bold)
                .opacity(.titleStrong)
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, .titleHorizontal)
        .padding(.top, .titleTop)
    }
}
