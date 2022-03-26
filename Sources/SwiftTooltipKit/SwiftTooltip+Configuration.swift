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

extension Tooltip {
    public class ToolTipConfiguration {
        public var backgroundColor: UIColor = .darkGray
        
        public var alignBackgroundColorWithViewColor: Bool = true
        
        public var offset: CGFloat = 20
        
        public var inset: CGFloat = 10
        
        public var tipSize: CGSize = CGSize(width: 20, height: 20)
        
        public var cornerRadius: CGFloat = 5.0
        
        public var animationDuration: CGFloat = 0.25
        
        public var animationDelay: CGFloat = 0.0
        
        public var animationOptions: UIView.AnimationOptions = [.curveEaseOut]
        
        public var dismissAutomatically: Bool = true
        
        public var timeToDimiss: TimeInterval = 2.5
        
        public init() {}
    }
}





#endif

