# Sky Cat News

## iOS Version
There was no requirement for supporting a minimum version of iOS, so I've tried to create a user experience that gets the most out of the most recent and modern Apple APIs. I've created the project with **iOS 15** as the target deployment version. The App has SwiftUI at its core, but of course, if there was a requirement to provide support for iOS 12 or below, an implementation with a mix of SwiftUI (for iOS 13+) and UIKit (for iOS 12 and below) could be possible.

## Navigation
The App features the custom navigation control `NavigationBar`. This was required so we could animate the control when the user scrolls. `GeometryReader` and `ScrollPreferenceKey` were used to detect user scrolling, and  `AnimatableFontModifier` was used to animate the title font after scrolling.

The App is also ready for using in __dark mode__. You can preview views by using `.preferredColorScheme(.dark)` or in Simulator --> Features --> Toggle Appearance.

For this prototype, navigation into a story has been implemented for the __Featured Story__ only. This has been implemented with `.matchedGeometryEffect` techniques I've learned earlier this year. These enable elements of the view that are matched between both source and destination view to align and produce a smooth transition effect when animating. I've animated the transition so that it gives the effect that we are maximising the feature story into its own full screen mode.
After you open the featured story, different sections of the story will appear at separate times (see `var appear: [Bool]` in `StoryView`), which gives a chain animation effect. You will be able to drag down to see a scaling effect in the background as you drag.
When you dismiss/close the featured story, you will be taken back to the main view in the app. At the moment there is a bug where the app doesn't come back to the original state it was before showing the featured story, and stays in a mode waiting to receive new stories, so you will need to drag down to request the stories again.
The section with the __Latest__ stories does not navigate into details of a story, but this behaviour can be implemented in a similar way as the featured story, or by using other navigation methods such as a presentation sheet or a navigation link.

## Architecture

I've followed a __layered__ approach where components are distributed across software layers. They communicate with each other when required.

* __UI__ - This component starts on `ContentView`, as this is the view at the top of the hierarchy. `ContentView` displays a `StoryView` instance in full screen mode when the user taps on the displayed `FeaturedStory`. The `StoriesView` is shown in the __Latest__ section and uses `StoriesViewItem` to display each story in the list. Future implementations of the App will require developing an advert and a weblink view that can also be used by the `StoriesView` list and can be filled with `[Advert]` and `[WebLink]` data provided by the presentation object.
* __Presentation__ - This layer is in charge of controlling and communicating changes between the data layer and the UI. `StoriesModel` is the main component of this layer. It uses `ObservableObject` as part of the _Combine framework_ to communicate changes between layers. _@Published_ property wrapper has been used as part of Apple's new reactive model to refresh data in the UI and in the data layer automatically. a __Model__ object needs to be initiated with a specific implementation of `DecodeProviding` so that it connects to the correct __data source__. `MediaMaker` implementations read information contained in data structures after the presentation class has accessed the data (via `DecodeProviding` implementations), and then they match properties from data structures to the presentation structures that conform to `NewsRepresentable` to create specific objects of stories, web links or adverts. These will then be ready for using in the UI when required and can be read from instances of presentation objects (model classes). 
* __Data__ - This layer contains the structures that hold data used by the presentation layer: `StoryData` and `StoryDataFeed`. These structures resemble the properties found in the expected _JSON_ response and thus are very basic and only conform to `Decodable` and if the response is providing an `id`, they will also conform to `Identifiable`. 
* __Other components__ Data Providers are used to facilitate access to data. All the providers are based on the `DecodeProviding` protocol, as it is expected that all the providers will decode the data they access. `func parseData<T: Decodable>() async -> T?` was declared as a _generic_ so that it allows for writing the same method for parsing different types of objects, so we can retrieve `StoryData` or `StoriesDataFeed` and its inner `[MediaItem]` from the network in a similar way. All the providers can also use the default implementation of `func decode<T: Decodable>(_ data: Data) throws -> T?` which was declared as an extension of `DecodeProviding` which provides a default behaviour for decoding all the structures and does not need to be different or modified for any of them.

## URL Usage

URL creation occurs via extensions to `URL` and `URLCompoments` found in [Extensions.swift](/SkyCatNews/Model/Extensions.swift). For sample data, I've created URLs using images retrieved from [Lorem Picsum](https://picsum.photos), which provides a great interface for prototyping and testing network access to images of different sizes. At the moment URLs are built using static strings found in [Extensions.swift](/SkyCatNews/Model/Extensions.swift) (see `extension String`). You can edit the URL strings for the Sky server and then use `URL.newsListURL` to create a valid URL that connects to a Sky server to retrieve live Cat news. This URL can be used by a network provider (e.g. In `ContentView` you can declare `@ObservedObject var storiesModel = StoriesModel(networkProvider: NetworkProvider(url: .newsListURL))` instead of the current model that connects to a file provider).

## Error Handling

Error providers conform to the protocol `ErrorProviding` and are used by the `DecodeProviding` data providers to provide errors when trying to access data. Other areas of the app where a critical error has been found, use messages found in [Extensions.swift](/SkyCatNews/Model/Extensions.swift). At the moment these areas use `preconditionFailure` to stop the app in debug mode, as there is no specific requirement about what we should do for each error (e.g. display error messages to users or create a logging system and display default placeholder views to users)


## Testing

Tests coverage for business logic and model data can be found in `SkyCatNewsTests`.
Test coverage for UI behaviours and workflows can be found in `SkyCatNewsUITests`.
I added additional test values in [Extensions.swift](/SkyCatNews/Model/Extensions.swift). These are widely used in both test projects to validate data. This file needs to have __Target Membership__ for all the projects so that it can be used by the test projects.

## Final observations

* Navigation back from a detailed story (`StoryView`) to the main view (`ContentView`) is currently bugged because it does not load the content again. The user will need to drag down to refresh the view and load the content again.
* `StoryView` displays a list of story paragraphs and images. At the moment the image is not shown and this implementation is not working ( a text placeholder that says `Image goes here` is shown instead)
* There are a total of 5 __FIXME__ locations in the App that will need changing to live server commands when the connections are ready.
* The UI Testing project still requires a lot of work. I could use query techniques such as `.descendants(matching: .staticText).allElementsBoundByIndex` or `matching: .image` amongst other to find elements and check that accessibility features are available. It is also possible to use accessibility identifiers to find the `FeatureStory` view in the main UI and the close button in `StoryView` to create a UI Testing workflow where we can perform `foundElement.tap()` or `app.swipeDown()` to create automated interactions in the UI and validate that certain view elements are being displayed after these actions (e.g. to test that navigation is working)
* The unit test project still needs additional testing functions to cover test of the model objects `StoriesModel` and `StoryModel` using certain conditions (e.g. with a mocked network provider, a file provider, or perhaps if we created another mocked provider that uses stored data)
* The App requires an internet connection to access media files located in [Lorem Picsum](https://picsum.photos). The Controls that show all the images are of type `AsyncImage` and use a `ProgressView()` as a placeholder. If the App is emulated from a device that has no internet access, the `ProgressView()` will show indefinitely. If the app was intended for showcasing within an environment with no network access at all, it might be useful to replace all the instances of `ProgressView()` within `AsyncImage` placeholders with a local `Image(systemName: "photo")` 
 
