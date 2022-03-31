# SwiftTooltipKit

[![Swift](https://github.com/hendesi/SwiftTooltipKit/actions/workflows/swift.yml/badge.svg)](https://github.com/hendesi/SwiftTooltipKit/actions/workflows/swift.yml) [![Swift Version](https://img.shields.io/badge/Swift-5.5-green.svg)](https://www.swift.org) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 

| Syntax | Description |
| --- | ----------- |
| ![2022-03-29 10 59 32](https://user-images.githubusercontent.com/23266326/160580656-c42cfd99-f8c0-48b7-9a45-60b5a326e32e.gif) | ![Simulator Screen Shot - iPod touch (7th generation) - 2022-03-29 at 11 36 25](https://user-images.githubusercontent.com/23266326/160581933-f8e5da9f-3084-4d0a-8f3a-456ef18fd949.png) |

# Description
SwiftTooltipKit is written in Swift and offers customizable tooltips out-of-the-box for iOS projects. It is easy to setup, light-weight and compatible with any project with or above iOS v10.

## Features

- ✅ **Usable for any `UIView` or `UIBarItem`**
- ✅ **Supports all orientations: `.top`, `.right`, `.left`, `.bottom`**
- ✅ **Automatically chooses a fitting orientation if the selected orientation violates layout constraints**
- ✅ **Supports the display of text or a custom `UIView`**
- ✅ **Allows customization of animation, shadow, label and general properties**

## Installation
Currently SwiftTooltipKit only supports installation via Swift Package Manager. 
Simply add this package by clicking **File > Add Packages** 
<img width="500" alt="Screenshot 2022-03-29 at 11 51 20" src="https://user-images.githubusercontent.com/23266326/160584919-27428241-214d-4c4d-bd91-87677c75a94b.png">

Alternatively, you can also add the package by editing `Package.swift`:
```swift
dependencies: [
        .package(url: "https://github.com/hendesi/SwiftTooltipKit.git", from: "0.1.0")
]
``` 

If you cannot or do not want to use SPM, you can integrate SwiftTooltipKit manually to your project.

## Usage
To add tooltips to your view using SwiftTooltipKit, simply import it to your file by `import SwiftTooltipKit`. You can add a tooltip to every `UIView` or `UIBarItem` by simply calling:
```swift
.tooltip("This is a demo text", orientation: .left)
```
You are also able to pass a configuration object to further customize the tooltip to your needs. You can set desired properties to the `Tooltip.ToolTipConfiguration` object in the closure or pass one directly:
```swift
sender.tooltip("Define the width of a tooltip dynamically", orientation: .left, configuration: {configuration in                   
    configuration.labelConfiguration.textColor = .green
    return configuration
})
```

SwiftTooltipKit supports also the tooltip display of custom views. To add your custom view to a tooltip and display, simply call:
```swift
let imageView = UIImageView()
imageView.image = UIImage(systemName: "heart.fill")!.withRenderingMode(.alwaysTemplate)
imageView.tintColor = .red
presentingView.tooltip(imageView, orientation: .right)
```
 
### Configuration
SwiftTooltipKit supports a wide range of configuration properties to customize the appearance of a tooltip. Refer to the [configuration source file](https://github.com/hendesi/SwiftTooltipKit/blob/develop/Sources/SwiftTooltipKit/Tooltip%2BConfiguration.swift) for a detailed description of each property.

## License
SwiftTooltipKit is developed by [Felix Desiderato](https://github.com/hendesi) and is released under the MIT license. See the LICENSE file for details.

## Contribution
Any contributions are very welcome. If you feel an important feature is missing, feel free to open a pull request or if you encounter any bugs, drop an issue. 
