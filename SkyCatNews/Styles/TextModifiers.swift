//
//  TextModifiers.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import Foundation
import SwiftUI

// MARK: Section Title

struct SectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, .generalHorizontal)
    }
}

extension View {
    func sectionTitleModifier() -> some View {
        modifier(SectionTitleModifier())
    }
}


struct TextModifiers_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            /// Demo section
            Text(verbatim: .newsSection.uppercased())
                .sectionTitleModifier()
            /// Demo section
            Text(verbatim: .newsSection.uppercased())
                .sectionTitleModifier()
                .preferredColorScheme(.dark)
            
        }
    }
}
