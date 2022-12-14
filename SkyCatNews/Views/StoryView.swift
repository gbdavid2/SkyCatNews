//
//  StoryView.swift
//  SkyCatNews
//
//  Created by David Garces on 10/08/2022.
//

import SwiftUI

struct StoryView: View {
    
    var namespace: Namespace.ID
    var isAnimated = true
    
    @State var viewState: CGSize = .zero
    @State var showSection = false
    @State var appear = [false, false, false]
    
    @ObservedObject var storyModel: StoryModel
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
                sectionsSection
                    .opacity(appear[2] ? 1 : 0)
            }
            .coordinateSpace(name: "scroll")
            .background(Color("Background"))
            .mask(RoundedRectangle(cornerRadius: appear[0] ? 0 : 30))
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3))
            .shadow(color: Color("Shadow").opacity(0.5), radius: 30, x: 0, y: 10)
            .scaleEffect(-viewState.width/500 + 1)
            .background(Color("Shadow").opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .gesture(drag)
            .ignoresSafeArea()
            
            Button {
                withAnimation(.closeStory) {
                    navigationModel.showDetail = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
                    .backgroundStyle(cornerRadius: 18)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .ignoresSafeArea()
        }
        .zIndex(1)
        .onAppear { fadeIn() }
        .onChange(of: navigationModel.showDetail) { show in
            fadeOut()
        }
        .task(id: storyModel.isFetching) {
            await storyModel.loadStory()
        }
        .refreshable {
            await storyModel.loadStory()
        }
    }
    
    var cover: some View {
        GeometryReader { proxy in
            
            let scrollY = proxy.frame(in: .named("scroll")).minY
            
            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 500 + scrollY: 500)
            .background(
                AsyncImage(url: storyModel.detailedStory.heroImage.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .matchedGeometryEffect(id: "background_image", in: namespace)
                        .offset(y: scrollY > 0 ? -scrollY:0)
                        .accessibilityValue(storyModel.detailedStory.heroImage.accessibilityText)
                } placeholder: {
                    ProgressView()
                }
            )
            .mask(
                RoundedRectangle(cornerRadius: appear[0] ? 0 : 30)
                    .matchedGeometryEffect(id: "mask", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            )
            .overlay(
                VStack(alignment: .leading, spacing: 16) {
                    Text(storyModel.detailedStory.headline)
                        .font(.title).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                        .matchedGeometryEffect(id: "headline", in: namespace)
                    
                    Divider()
                        .foregroundColor(.secondary)
                        .opacity(appear[1] ? 1 : 0)
                    
                    HStack {
                        Text(storyModel.detailedStory.getFullUpdateText())
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)
                            .matchedGeometryEffect(id: "time", in: namespace)
                    }
                    .opacity(appear[1] ? 1 : 0)
                    .accessibilityElement(children: .combine)
                }
                    .padding(20)
                    .padding(.vertical, 10)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .cornerRadius(30)
                            .blur(radius: 30)
                            .opacity(appear[0] ? 0 : 1)
                    )
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .backgroundStyle(cornerRadius: 30)
                            .opacity(appear[0] ? 1 : 0)
                    )
                    .offset(y: scrollY > 0 ? -scrollY * 1.8 : 0)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: 100)
                    .padding(20)
            )
        }
        .frame(height: 500)
    }
    
    var sectionsSection: some View {
        VStack {
                ForEach (Array(storyModel.detailedStory.content.enumerated()), id: \.offset) {
                    index, storyItem in
                    if index != 0 { Divider() }
                    
                    if let paragraph = storyItem as? NewsParagraph {
                        Text(paragraph.text)
                    }
                    if let _ = storyItem as? NewsImage {
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                            .font(.system(size: 67))
                            .frame(width: 200, height: 200)
                        Text("Image goes here")
                        // FIXME: Fix code below and use instead when live server is available 
                        //NewsImageView(image: theImage)
                    }
                
            }
        }

        .padding(20)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 30)
        .padding(20)
        .padding(.vertical, 80)
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onChanged { value in
                guard value.translation.width > 0 else { return }
                
                if value.startLocation.x < 100 {
                    withAnimation {
                        viewState = value.translation
                    }
                }
                
                if viewState.width > 120 {
                    close()
                }
            }
            .onEnded { value in
                if viewState.width > 80 {
                    close()
                } else {
                    withAnimation(.closeStory) {
                        viewState = .zero
                    }
                }
            }
    }
    
    func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.5)) {
            appear[2] = true
        }
    }
    
    func fadeOut() {
        withAnimation(.easeIn(duration: 0.1)) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
        }
    }
    
    func close() {
        withAnimation {
            viewState = .zero
        }
        withAnimation(.closeStory.delay(0.2)) {
            navigationModel.showDetail = false
        }
    }
}

struct NewsImageView: View {
    var theImage: NewsImage
    var body: some View {
        AsyncImage(url: theImage.imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .accessibilityValue(theImage.accessibilityText)
        } placeholder: {
            ProgressView()
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        StoryView(namespace: namespace, storyModel: StoryModel(networkProvider: FileProvider(filename: .sampleStory)))
            .environmentObject(NavigationModel())
    }
}
