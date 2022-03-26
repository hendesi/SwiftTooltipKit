//
//  Tooltip.swift
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
import Foundation
import UIKit

public class Tooltip: UIView {
    
    public enum TipOrientation {
        case top, bottom, left, right
    }
    
    private enum AdjustmentType {
        case left, right, top, bottom
    }
    
    public private(set) var contentView: UIView!
    
    private var presentingViewFrame: CGRect {
        guard let presentingView = presentingView else { return .zero }
        return presentingView.convert(presentingView.bounds, to: UIApplication.getTopViewController()!.view)
    }
    
    public private(set) var presentingView: UIView?
    
    public private(set) var configuration: ToolTipConfiguration!
    
    public private(set) var orientation: TipOrientation = .top
    
    private var adjustmentTypes: Set<AdjustmentType> = []
    
    private var originXValue: CGFloat {
        switch orientation {
        case .top, .bottom:
            return presentingViewFrame.midX
        case .right:
            return presentingViewFrame.maxX + configuration.offset
        case .left:
            return presentingViewFrame.minX - configuration.offset
        }
    }
    
    private var originYValue: CGFloat {
        switch orientation {
        case .top:
            return presentingViewFrame.minY - configuration.offset
        case .bottom:
            return presentingViewFrame.maxY + configuration.offset
        case .left, .right:
            return presentingViewFrame.midY
        }
    }
    
    private var remainingOrientations: [TipOrientation] = [.top, .bottom, .right, .left]
    
    private var nextOrientation: TipOrientation {
        
        var rndElement: TipOrientation {
            remainingOrientations.randomElement() ?? .top
        }
        
        switch orientation {
        case .top:
            remainingOrientations = remainingOrientations.remove(.top)
            return remainingOrientations.contains(.bottom) ? .bottom : rndElement
        case .bottom:
            remainingOrientations = remainingOrientations.remove(.bottom)
            return remainingOrientations.contains(.top) ? .top : rndElement
        case .left:
            remainingOrientations = remainingOrientations.remove(.left)
            return remainingOrientations.contains(.right) ? .right : rndElement
        case .right:
            remainingOrientations = remainingOrientations.remove(.right)
            return remainingOrientations.contains(.left) ? .left : rndElement
        }
    }
    
    private var hasVerticalOrientation: Bool {
        orientation == .top || orientation == .bottom
    }
    
    private var hasHorizontalOrientation: Bool {
        orientation == .left || orientation == .right
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(view: UIView, presentingView: UIView, configuration: ToolTipConfiguration = ToolTipConfiguration(), orientation: TipOrientation) {
        self.init(frame: .zero)
        
        self.orientation = orientation
        self.contentView = view
        self.presentingView = presentingView
        self.configuration = configuration
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        backgroundColor = configuration.backgroundColor
        
        // animate showing
        alpha = 0
        
        // show
        show()
        
        // If configured, handles automatic dismissal
        handleAutomaticDismissalIfNedded()
        
        setNeedsLayout()
        layoutIfNeeded()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func computeFrame() {
        let viewSize = contentView.boundsOrIntrinsicContentSize
        
        let origin: CGPoint
        switch orientation {
        case .top:
            // take tipsize into account
            origin = CGPoint(x: originXValue - viewSize.width/2, y: originYValue - viewSize.height)
        case .bottom:
            origin = CGPoint(x: originXValue - viewSize.width/2, y: originYValue)
        case .left:
            origin = CGPoint(x: originXValue - viewSize.width, y: originYValue - viewSize.height/2)
        case .right:
            origin = CGPoint(x: originXValue, y: originYValue - viewSize.height/2)
        }
        
        self.frame = validateRect(CGRect(x: origin.x, y: origin.y, width: viewSize.width, height: viewSize.height), adjustedX: origin.x, adjustedY: origin.y, orientation: orientation)
    }
    
    private func validateRect(_ rect: CGRect, adjustedX: CGFloat, adjustedY: CGFloat, orientation: TipOrientation) -> CGRect {
        let screenBounds = UIScreen.main.bounds
        let globlSafeAreasInsets = UIApplication.shared.keyWindow!.safeAreaInsets
        let margin: CGFloat = 16
        
        precondition(rect.width <= screenBounds.width - margin*2, warningMsg())
        precondition(rect.height <= screenBounds.height - margin*2 - globlSafeAreasInsets.top - globlSafeAreasInsets.bottom, warningMsg())
        
        switch orientation {
        case .top:
            if contentView.boundsOrIntrinsicContentSize.height + margin + globlSafeAreasInsets.top > presentingViewFrame.minY {
                self.orientation = nextOrientation(for: orientation)
            }
        case .bottom:
            if screenBounds.height - contentView.boundsOrIntrinsicContentSize.height - margin - globlSafeAreasInsets.bottom < presentingViewFrame.maxY {
                self.orientation = nextOrientation(for: orientation)
            }
            
        case .left:
            if contentView.boundsOrIntrinsicContentSize.width + margin + globlSafeAreasInsets.left > presentingViewFrame.minX {
                self.orientation = nextOrientation(for: orientation)
            }
        case .right:
            if screenBounds.width - contentView.boundsOrIntrinsicContentSize.width - margin - globlSafeAreasInsets.bottom <  presentingViewFrame.maxX {
                self.orientation = nextOrientation(for: orientation)
            }
        }
        
        if adjustedY < margin + globlSafeAreasInsets.top {
            adjustmentTypes.insert(.top)
            return validateRect(
                rect,
                adjustedX: adjustedX,
                adjustedY: margin + globlSafeAreasInsets.top,
                orientation: self.orientation
            )
        } else if adjustedY > screenBounds.height - margin - globlSafeAreasInsets.bottom {
            adjustmentTypes.insert(.bottom)
            return validateRect(
                rect,
                adjustedX: adjustedX,
                adjustedY: screenBounds.height - margin - globlSafeAreasInsets.bottom,
                orientation: self.orientation
            )
        } else if adjustedX < margin {
            adjustmentTypes.insert(.left)
            return validateRect(
                rect,
                adjustedX: margin,
                adjustedY: adjustedY,
                orientation: self.orientation
            )
        } else if adjustedX > screenBounds.width - margin - contentView.boundsOrIntrinsicContentSize.width {
            adjustmentTypes.insert(.right)
            return validateRect(
                rect,
                adjustedX: screenBounds.width - margin - contentView.boundsOrIntrinsicContentSize.width,
                adjustedY: adjustedY,
                orientation: self.orientation            )
        }
        return CGRect(origin: CGPoint(x: adjustedX, y: adjustedY), size: rect.size)
    }
    
    private var orientationsTried: Set<TipOrientation> = []
    private func nextOrientation(for prevOrientation: TipOrientation) -> TipOrientation {
        switch prevOrientation {
        case .top:
            orientationsTried.insert(.top)
            if !orientationsTried.contains(.bottom) { return .bottom }
            return .left
        case .bottom:
            orientationsTried.insert(.bottom)
            if !orientationsTried.contains(.top) { return .top }
            return .left
        case .left:
            orientationsTried.insert(.left)
            if !orientationsTried.contains(.right) { return .right }
            return .top
        case .right:
            orientationsTried.insert(.right)
            if !orientationsTried.contains(.left) { return .left }
            return .top
        }
    }
    
    private func handleAutomaticDismissalIfNedded() {
        guard configuration.dismissAutomatically else { return }
        Timer.scheduledTimer(withTimeInterval: configuration.timeToDimiss, repeats: false, block: { [unowned self] _ in
            self.dismiss()
        })
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()
        
        computeFrame()
        drawToolTip(self.bounds)
        print(contentView.intrinsicContentSize)
    }
    
    private func drawToolTip(_ rect :CGRect) {
        let inset = configuration.inset
        let roundRect = CGRect(x: rect.minX - inset, y: rect.minY - inset, width: rect.width + inset * 2, height: rect.height + inset * 2)
        let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 5.0)
        
        let trianglePath = drawTip(rect)
        roundRectBez.append(trianglePath)
        roundRectBez.lineWidth = 2
        
        let shape = createShapeLayer(roundRectBez.cgPath)
        self.layer.insertSublayer(shape, at: 0)
    }
    
    private func drawTip(_ rect: CGRect) -> UIBezierPath {
        let tipPath = UIBezierPath()
        let tipSize = configuration.tipSize
        let inset = configuration.inset
        let rect = self.bounds
        
        let convertedPresentingFrame = presentingView!.convert(presentingView!.bounds, to: self)
        
        var xValueCenter: CGFloat = rect.midX
        var yValueCenter: CGFloat = rect.midY
        
        switch orientation {
        case .top, .bottom:
            xValueCenter = rect.midX
        case .left, .right:
            xValueCenter = rect.minY
        }
        
        for adjustmentType in adjustmentTypes {
            if (adjustmentType == .right || adjustmentType == .left) && hasVerticalOrientation {
                xValueCenter = convertedPresentingFrame.midX
            }
            
            if (adjustmentType == .top || adjustmentType == .bottom) && hasHorizontalOrientation {
                yValueCenter = convertedPresentingFrame.midY
            }
        }
        
        switch orientation {
        case .top:
            tipPath.move(to: CGPoint(x: xValueCenter - tipSize.width/2, y: rect.maxY + inset ))
            tipPath.addLine(to: CGPoint(x: xValueCenter + tipSize.width/2, y: rect.maxY + inset ))
            tipPath.addLine(to: CGPoint(x: xValueCenter, y: rect.maxY + tipSize.height ))
            tipPath.addLine(to: CGPoint(x: xValueCenter - tipSize.width/2, y: rect.maxY + inset ))
        case .bottom:
            tipPath.move(to: CGPoint(x: xValueCenter - tipSize.width/2, y: rect.minY - inset))
            tipPath.addLine(to: CGPoint(x: xValueCenter + tipSize.width/2, y: rect.minY - inset))
            tipPath.addLine(to: CGPoint(x: xValueCenter, y: rect.minY - tipSize.height ))
            tipPath.addLine(to: CGPoint(x: xValueCenter - tipSize.width/2, y: rect.minY - inset))
        case .left:
            tipPath.move(to: CGPoint(x: rect.maxX + inset, y: yValueCenter - tipSize.height/2 ))
            tipPath.addLine(to: CGPoint(x: rect.maxX + inset, y: yValueCenter + tipSize.height/2 ))
            tipPath.addLine(to: CGPoint(x: rect.maxX + tipSize.height, y: yValueCenter ))
            tipPath.addLine(to: CGPoint(x: rect.maxX + inset, y: yValueCenter - tipSize.height/2 ))
        case .right:
            tipPath.move(to: CGPoint(x: rect.minX - inset, y: yValueCenter - tipSize.height/2 ))
            tipPath.addLine(to: CGPoint(x: rect.minX - inset, y: yValueCenter + tipSize.height/2 ))
            tipPath.addLine(to: CGPoint(x: rect.minX - tipSize.height, y: yValueCenter ))
            tipPath.addLine(to: CGPoint(x: rect.minX - inset, y: yValueCenter - tipSize.height/2 ))
        }
        
        tipPath.close()
        return tipPath
    }
    
    func createShapeLayer(_ path : CGPath) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = configuration.backgroundColor.cgColor
        shape.shadowColor = configuration.shadowConfiguration.shadowColor
        shape.shadowOffset = configuration.shadowConfiguration.shadowOffset
        shape.shadowRadius = configuration.cornerRadius
        shape.shadowOpacity = configuration.shadowConfiguration.shadowOpacity
        return shape
    }
    
    private func dismiss() {
        UIView.animate(
            withDuration: configuration.animationConfiguration.animationDuration,
            delay: configuration.animationConfiguration.animationDelay,
            options: configuration.animationConfiguration.animationOptions,
            animations: { [unowned self] in
                self.alpha = 0
            },
            completion: { [unowned self] _ in
                self.isHidden = true
                self.removeFromSuperview()
            }
        )
    }
    
    private func show() {
        UIView.animate(
            withDuration: configuration.animationConfiguration.animationDuration,
            delay: configuration.animationConfiguration.animationDelay,
            options: configuration.animationConfiguration.animationOptions,
            animations: { [unowned self] in
                self.alpha = 1
            }
        )
    }
    
    private func warningMsg() -> String {
        """
            LAYOUT ERROR:
        
            It seems that the view displayed as a tooltip is too large!
            Please make sure that size of the tooltip is valid and try again.
        """
        
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if !self.bounds.contains(point) {
            dismiss()
            return false
        }
        return true
    }
}

#endif
