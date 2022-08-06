# Sky Cat News

## iOS Version
There was no requirement for supporting a minimum version of iOS, so I've tried to create a user experience that gets the most out of the most recent and modern Apple APIs. I've created the project with **iOS 15** as the target deployment version.

## Navigation
The App features the custom navigation control `NavigationBar`. This was required so we could animate the control when the user scrolls. `GeometryReader` and `ScrollPreferenceKey` were used to detect user scrolling, and  `AnimatableFontModifier` was used to animate the title font after scrolling.

## Testing

Tests coverage for business logic and model data can be found in `SkyCatNewsTests`
Test coverage for UI behaviours and workflows can be found in `SkyCatNewsUITests`
I created extension files for each test project so I could more easily validate data. If there are any changes in the main file [Extensions.swift](/SkyCatNews/Model/Extensions.swift), then the file [SkyCatNewsTestsExtensions.swift](SkyCatNewsTests/SkyCatNewsTestsExtensions.swift)  and the file [SkyCatNewsUITestsExtensions.swift](/SkyCatNewsUITests/SkyCatNewsUITestsExtensions.swift) will also need changing
