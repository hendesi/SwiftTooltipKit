//
//  SwiftTooltip+Configuration.swift
//  
// Copyright (c) 2022 Felix Desiderato
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(UIKit)
import UIKit

public extension Tooltip {
    /// `TooltipConfiguration` allows to customize a `Tooltip` according to the user's preferences.
    public class ToolTipConfiguration {
        /// The background color of the `Tooltip` object. Defaults to `.darkGray`.
        public var backgroundColor: UIColor = .darkGray
        /// The offset of the tooltip to the view it belongs to. Defaults to `20`.
        public var offset: CGFloat = 20
        /// The inset of the tooltip's content to the tooltip's edges. Defaults to `10`.
        public var inset: CGFloat = 10
        /// The size of the tip that points towards to the view that is displaying the tooltip. Defaults to `CGSize(width: 20, height: 20)`
        public var tipSize: CGSize = CGSize(width: 20, height: 20)
        /// The corner radius of the tooltip. Defaults to `5.0`
        public var cornerRadius: CGFloat = 5.0
        /// The configuration for the displaying and dismiss animations of the tooltip. Refer to `AnimationConfiguration` for default settings.
        public var animationConfiguration: AnimationConfiguration = AnimationConfiguration()
        /// The configuration for the shadow properties of the tooltip. Refer to `ShadowConfiguration` for default settings.
        public var shadowConfiguration: ShadowConfiguration = ShadowConfiguration()
        /// The configuration for the tooltip if it is displayed by calling `tooltip(_ text: String, ...)`. Refer to `LabelConfiguration` for default settings.
        public var labelConfiguration: LabelConfiguration = LabelConfiguration()
        /// Boolean value indicating if the tooltip is automatically dismissed after `timeToDimiss` time interval. Defaults to `true`
        public var dismissAutomatically: Bool = true
        /// If `dismissAutomatically`is set to true, this can be used to set the time interval after which the tooltip is dismissed. Defaults to `2.5` seconds.
        public var timeToDimiss: TimeInterval = 2.5
        /// Default init.
        public init() {}
    }
    
    /// `ShadowConfiguration` contains properties that allow to customize the shadow properties of the tooltip.
    public class ShadowConfiguration {
        /// The color of th shadow. Defaults to `UIColor.black.withAlphaComponent(0.60).cgColor`.
        public var shadowColor: CGColor = UIColor.black.withAlphaComponent(0.60).cgColor
        /// The offset of the shadow to the tooltip. Defaults to `CGSize(width: 0, height: 2)`.
        public var shadowOffset: CGSize = CGSize(width: 0, height: 2)
        /// The opacity of the shadow. Defaults to `0.8`.
        public var shadowOpacity: Float = 0.8
    }
    
    /// `AnimationConfiguration` contains properties that allow to customize the displaying and dismiss animations of the tooltip.
    public class AnimationConfiguration {
        /// The duration of the animation. Defaults to `0.25`.
        public var animationDuration: CGFloat = 0.25
        /// The delay of the animation. Defaults to zero.
        public var animationDelay: CGFloat = 0.0
        /// Additional `UIView.AnimationOptions` to further customize the animation. `.curveEaseOut` is set as default.
        public var animationOptions: UIView.AnimationOptions = [.curveEaseOut]
    }
    
    /// **NOTE**: Only needed if tooltip is displayed via `tooltip(_ text: String,...)`.
    /// `LabelConfiguration` contains properties that allow to customize the label that is used to display the string.
    public class LabelConfiguration {
        /// The text alignment. Defaults to `.center`.
        public var textAlignment: NSTextAlignment = .center
        /// The text color. Defaults to `.white`.
        public var textColor: UIColor = .white
        /// The text font. Defaults to `.systemFont(ofSize: 14, weight: .medium)`
        public var font: UIFont = .systemFont(ofSize: 14, weight: .medium)
        /// The max length of the label and therefore the tooltip. Indicates at which point a linebreak is performed. Defaults to 150
        public var preferredMaxLayoutWidth: CGFloat = 150
    }
}

#endif
