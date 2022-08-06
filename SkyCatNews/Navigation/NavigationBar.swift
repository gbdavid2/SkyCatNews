//
//  NavigationBar.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import SwiftUI

/// Custom navigation bar for SkyCatNews that allows creating a custom layout and custom behaviours and animations
struct NavigationBar: View {
    
    var title = "" 
    
    /// Based on the behaviour of this variable we'll be able to add a navigation bar effect. This variable is bound to the `ContentView`'s `contentHasScrolled` behaviour.
    @Binding var contentHasScrolled: Bool
    
    /// `showNavigation` is used to hide the bar altogether if we open detail views.
    @Binding var showNavigation: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: .navigationBarHeight)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .blur(radius: contentHasScrolled ? 10 : 0)
                .opacity(contentHasScrolled ? 1 : 0)
            Text(title)
                .animatableFont(size: contentHasScrolled ? .titleSmall : .titleLarge, weight: .bold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, .titleHorizontal)
                .padding(.top, .titleTop)
                .opacity(contentHasScrolled ? .titleFaded : .titleStrong)
        }
        .offset(y: showNavigation ? 0 : .navigationBarHiddenY)
        .accessibility(hidden: !showNavigation)
        .offset(y: contentHasScrolled ? .navigationBarContentHasScrolledY : 0)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationBar(title: .skyTitle, contentHasScrolled: .constant(false), showNavigation: .constant(true))
            NavigationBar(title: .skyTitle, contentHasScrolled: .constant(true), showNavigation: .constant(true))
        }
        Group {
            NavigationBar(title: .skyTitle, contentHasScrolled: .constant(false), showNavigation: .constant(true))
            NavigationBar(title: .skyTitle, contentHasScrolled: .constant(true), showNavigation: .constant(true))
        }
        .preferredColorScheme(.dark)
    }
}
