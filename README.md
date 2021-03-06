# ContentFitScrollView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/ContentFitScrollView.svg?style=flat)](http://cocoapods.org/pods/ContentFitScrollView)
[![License](https://img.shields.io/cocoapods/l/ContentFitScrollView.svg?style=flat)](http://cocoapods.org/pods/ContentFitScrollView)
[![Platform](https://img.shields.io/cocoapods/p/ContentFitScrollView.svg?style=flat)](http://cocoapods.org/pods/ContentFitScrollView)
[![CI Status](http://img.shields.io/travis/APUtils/ContentFitScrollView.svg?style=flat)](https://travis-ci.org/APUtils/ContentFitScrollView)

Self adjustable Scroll View that proportionally reducing provided height constraints constants to fit all content on screen without scrolling. It takes into account `ContentFitLayoutConstraint`'s `minimumHeight` value. If it's unable to fit content on screen without scrolling it'll just allow scrolling.

`ContentFitScrollView` allows you to layout your content for high resolution screens and be sure that in case there isn't enough space on lower resolution screens content will be scrollable.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Demonstration

About iPhone screens - https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions

Let's assume designer did his job well and provided me 1242x2208 images. In my turn I did everything to match original. So 7 Plus images are ideal ones. Now let's compare how my interface will look like on other devices.

#### Without `ContentFitScrollView`

<table>
  <tr>
    <th>7 Plus</th>
    <th>6s</th>
    <th>5s</th>
  </tr>
  <tr>
    <td><img src="Example/ContentFitScrollView/default_7p.png" width="320"/></td>
    <td><img src="Example/ContentFitScrollView/default_6s.png" width="320"/></td>
    <td><img src="Example/ContentFitScrollView/default_5s.png" width="320"/></td>
  </tr>
</table>

No doubt it looks awful on every device except top ones (iPhone 6+, 6s+, 7+). My goal here was to fit everything on screen and with simple layout I failed. Of course I could use constraints to labels center and layout them acording to container view's center... But it's headache to calculate all those multipliers and expecially recalculate them when new designs arrive. Now try to imagine that layout won't be that simple... Ugh...

#### With `ContentFitScrollView`

<table>
  <tr>
    <th>7 Plus</th>
    <th>6s</th>
    <th>5s</th>
  </tr>
  <tr>
    <td><img src="Example/ContentFitScrollView/contentFit_7p.png" width="320"/></td>
    <td><img src="Example/ContentFitScrollView/contentFit_6s.png" width="320"/></td>
    <td><img src="Example/ContentFitScrollView/contentFit_5s.png" width="320"/></td>
  </tr>
</table>

This one much better! `ContentFitScrollView` tries to reduce available space between labels to fit them all on screen. In case it can't screen will be scrollable so in worst case we fallback to how UIScrollView works.

#### With `ContentFitScrollView` + `APExtensions`

<table>
  <tr>
    <th>7 Plus</th>
    <th>6s</th>
    <th>5s</th>
  </tr>
  <tr>
    <td><img src="Example/ContentFitScrollView/apextensions_7p.png" width="320"/></td>
    <td><img src="Example/ContentFitScrollView/apextensions_6s.png" width="320"/></td>
    <td><img src="Example/ContentFitScrollView/apextensions_5s.png" width="320"/></td>
  </tr>
</table>

I'm using `UILabel+Storyboard` extension from [APExtensions/Storyboard](https://github.com/APUtils/APExtensions#storyboard) to fit labels to screen size.

This one solution almost guarantee that my screen never will be scrollable and all elements will fit to screen. But for some layouts I still might preffer second one. It's up to you to decide which one fits better for your needs.

## Installation

#### Carthage

**If you are setting `ContentFitScrollView` class in storyboard assure module field is also `ContentFitScrollView`**

<img src="Example/ContentFitScrollView/customClass.png"/>

Please check [official guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

Cartfile:

```
github "APUtils/ContentFitScrollView"
```

#### CocoaPods

ContentFitScrollView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ContentFitScrollView'
```

## Usage

Just set `ContentFitScrollView` class to UIScrollView in storyboard (usually it's base container), **assure module field is also `ContentFitScrollView`**: 

<img src="Example/ContentFitScrollView/customClass.png"/>

and add constraints that you want to be resized in order to fit content for screen:

<img src="Example/ContentFitScrollView/ContentFitScrollViewStoryboardOutlets.png"/>

You can set `ContentFitLayoutConstraint` class for those constraints in order to specify minimum height.

See example project for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

ContentFitScrollView is available under the MIT license. See the LICENSE file for more info.
