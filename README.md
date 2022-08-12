# Sky Cat News

## iOS Version
There was no requirement for supporting a minimum version of iOS, so I've tried to create a user experience that gets the most out of the most recent and modern Apple APIs. I've created the project with **iOS 15** as the target deployment version.

## Navigation
The App features the custom navigation control `NavigationBar`. This was required so we could animate the control when the user scrolls. `GeometryReader` and `ScrollPreferenceKey` were used to detect user scrolling, and  `AnimatableFontModifier` was used to animate the title font after scrolling.

## Architecture

I've followed a __layered__ approach where components are distributed across software layers. They communicate with each other when required.

* __UI__ - This component starts on `ContentView`, as this is the view at the top of the hierarchy.
* __Presentation__ - This layer is in charge of controlling and communicating changes between the data layer and the UI. `StoriesModel` is the main compoment of this layer. It uses `ObservableObject` as part of the _Combine framework_ to communicate changes between layers. _@Published_ property wrapper has been used as part of Apple's new reactive model to refresh data in the UI and in the data layer automatically. a __Model__ object needs to be initiated with a specific implementation of `DecodeProviding` so that it connect to the correct __data source__. `MediaMaker` implementations read information contained in data structures after the presentation class has accessed the data (via `DecodeProviding` implementations), and then they match properties from data structures to the presentation structures that conform to `NewsRepresentable` to create specific objects of stories, web links or adverts. These will then be ready for using in the UI when required and can be read from instances of presentation objects (model classes). 
* __Data__ - This layer contains the structures that hold data used by the presentation layer: `StoryData` and `StoryDataFeed`. These structures resemble the properties found in the expected _JSON_ response and thus are very basic and only conform to `Decodable` and if the response is providing an `id`, they will also conform to `Identifiable`. 
* __Other components__ Data Providers are used to facilitate access to data. All the providers are based on the `DecodeProviding` protocol, as it is expected that all the providers will decode the data they access. `func parseData<T: Decodable>() async -> T?` was declared as a _generic_ so that it allows for writing the same method for parsing different types of objects, so we can retrieve `StoryData` or `StoriesDataFeed` and its inner `[MediaItem]` from the network in a similar way. All the providers can also use the default implemenation of `func decode<T: Decodable>(_ data: Data) throws -> T?` which was declared as an extension of `DecodeProviding` which provides a default behaviour for decoding all the structures and does not need to be different or modified for any of them.


## Testing

Tests coverage for business logic and model data can be found in `SkyCatNewsTests`.
Test coverage for UI behaviours and workflows can be found in `SkyCatNewsUITests`.
I added additional test values in [Extensions.swift](/SkyCatNews/Model/Extensions.swift). These are widely used in both test projects to validate data. This file needs to have __Target Membership__ for all the projects so that it can be used by the test projects.
