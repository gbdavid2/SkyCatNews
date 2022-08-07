# Sky Cat News

## iOS Version
There was no requirement for supporting a minimum version of iOS, so I've tried to create a user experience that gets the most out of the most recent and modern Apple APIs. I've created the project with **iOS 15** as the target deployment version.

## Navigation
The App features the custom navigation control `NavigationBar`. This was required so we could animate the control when the user scrolls. `GeometryReader` and `ScrollPreferenceKey` were used to detect user scrolling, and  `AnimatableFontModifier` was used to animate the title font after scrolling.

## Architecture

I've followed a __layered__ approach where components are distributed across software layers. They communicate with each other when required.

* __UI__ - This compoment starts on `ContentView`, as this is the view at the top of the hierarchy.
* __Presentation__ - This layer is in charge of controlling and communicating changes between the data layer and the UI. `NewsModel` is the main compoment of this layer. It uses `ObservableObject` as part of the _Combine framework_ to communicate changes between layers. _@Published_ property wrapper has been used as part of Apple's new reactive model to refresh data in the UI and in the data layer automatically.  
* __Data__ - This layer contains the structures that hold data used by the presentation layer: `NewsItem`
* __Other components__ - 


## Testing

Tests coverage for business logic and model data can be found in `SkyCatNewsTests`.
Test coverage for UI behaviours and workflows can be found in `SkyCatNewsUITests`.
I created extension files for each test project so I could more easily validate data. If there are any changes in the main file [Extensions.swift](/SkyCatNews/Model/Extensions.swift), then the file [SkyCatNewsTestsExtensions.swift](SkyCatNewsTests/SkyCatNewsTestsExtensions.swift)  and the file [SkyCatNewsUITestsExtensions.swift](/SkyCatNewsUITests/SkyCatNewsUITestsExtensions.swift) will also need changing.
