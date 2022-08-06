//
//  NavigationBar.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import SwiftUI

struct NavigationBar: View {
    
    var title = "" 
    
    /// Based on the behaviour of this variable we'll be able to add a navigation bar effect.
    @Binding var contentHasScrolled: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .blur(radius: contentHasScrolled ? 10 : 0)
                .opacity(contentHasScrolled ? 1 : 0)
            Text(title)
                .animatableFont(size: contentHasScrolled ? 22 : 34, weight: .bold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .opacity(contentHasScrolled ? 0.7 : 1)
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: .skyTitle, contentHasScrolled: .constant(false))
    }
}
