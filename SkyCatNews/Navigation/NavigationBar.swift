//
//  NavigationBar.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import SwiftUI

/// Custom navigation bar for SkyCatNews that allows creating a custom layout and custom behaviours and animations
struct NavigationBar: View {
    
    @AppStorage(.title) var title = String.skyTitle

    /// Based on the behaviour of this variable we'll be able to add a navigation bar effect. This variable is bound to the `ContentView`'s `contentHasScrolled` behaviour.
    @Binding var contentHasScrolled: Bool
    
    /// `showNavigation` is used to hide the bar altogether if we open detail views.
    @EnvironmentObject var model: NavigationModel
    
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
        .offset(y: model.showNavigation ? 0 : .navigationBarHiddenY)
        .accessibility(hidden: !model.showNavigation)
        .offset(y: contentHasScrolled ? .navigationBarContentHasScrolledY : 0)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationBar(title: .skyTitle, contentHasScrolled: .constant(false))
            NavigationBar(title: .skyTitle, contentHasScrolled: .constant(true))
        }
        .environmentObject(NavigationModel())
        Group {
            NavigationBar(title: .skyTitle, contentHasScrolled: .constant(false))
            NavigationBar(title: .skyTitle, contentHasScrolled: .constant(true))
        }
        .environmentObject(NavigationModel())
        .preferredColorScheme(.dark)
    }
}
