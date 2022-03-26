//
//  Extensions.swift
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

extension UIApplication {
    static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Array where Element: Equatable {
    func remove(_ element: Element) -> Self {
        var mutableCopy = self
        for (index, ele) in mutableCopy.enumerated() {
            if ele == element {
                mutableCopy.remove(at: index)
                
            }
        }
        return mutableCopy
    }
}

public extension UIView {
    var boundsOrIntrinsicContentSize: CGSize {
        return self.bounds.size != .zero ? self.bounds.size : self.intrinsicContentSize
    }
    
    var hasActiveTooltip: Bool {
        guard let activeTooltips = UIApplication.shared.keyWindow?.subviews.filter({ $0 is Tooltip }),
                !activeTooltips.isEmpty else { return false }
        
        return activeTooltips.compactMap { $0 as? Tooltip }.contains(where: { $0.presentingView == self })
    }
    
    func tooltip(_ view: UIView, orientation: Tooltip.TipOrientation, configuration: Tooltip.ToolTipConfiguration = Tooltip.ToolTipConfiguration()) {
        guard !hasActiveTooltip else { return }
        let toolTip = Tooltip(view: view, presentingView: self, configuration: configuration, orientation: orientation)
        
        UIApplication.shared.keyWindow?.addSubview(toolTip)
    }
    
    func tooltip(_ text: String, orientation: Tooltip.TipOrientation, configuration: Tooltip.ToolTipConfiguration = Tooltip.ToolTipConfiguration()) {
        guard !hasActiveTooltip else { return }
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.text = text
        label.preferredMaxLayoutWidth = 150
        
        let toolTip = Tooltip(view: label, presentingView: self, configuration: configuration, orientation: orientation)
        
        UIApplication.shared.keyWindow?.addSubview(toolTip)
    }
}


#endif
