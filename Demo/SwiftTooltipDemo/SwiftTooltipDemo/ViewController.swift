//
//  ViewController.swift
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

import UIKit
import SwiftTooltipKit

class ViewController: UIViewController {
    
    let buttonStackview: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.alignment = .fill
        stackview.spacing = 15
        return stackview
    }()
    
    let buttonColors: [UIColor] = [.purple, .blue, .cyan, .green, .orange]
    
    var smallTooltipConfig: Tooltip.ToolTipConfiguration = {
        let smalltoolTipConfig = Tooltip.ToolTipConfiguration()
        smalltoolTipConfig.labelConfiguration.preferredMaxLayoutWidth = 100
        return smalltoolTipConfig
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(buttonStackview)
        buttonStackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90).activate()
        buttonStackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        buttonStackview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).activate()
        
        populateView()
        
        let item = UIBarButtonItem(title: "Show", style: .done, target: self, action: #selector(didPressBarButton(_:)))
        self.navigationItem.setRightBarButton(item, animated: true)
    }

    private func populateView() {
        for index in 0..<5 {
            let button = UIButton()
            button.setTitle("Button \(index)", for: .normal)
            button.backgroundColor = buttonColors[index]
            button.tag = index
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.widthAnchor.constraint(equalToConstant: 100).activate()
            button.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
            buttonStackview.addArrangedSubview(button)
        }
    }
    
    @objc func didPressButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            sender.tooltip("A tootltip with top orientation", orientation: .top)
        case 1:
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "heart.fill")!.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .red
            sender.tooltip(imageView, orientation: .right)
            sender.tooltip("Display custom views in the tooltip", orientation: .left, configuration: smallTooltipConfig)
        case 2:
            sender.tooltip("A tootltip with custom configuration", orientation: .top, configuration: { configuration in
                configuration.backgroundColor = sender.backgroundColor!
                configuration.cornerRadius = 0
                configuration.animationConfiguration.animationDuration = 1.25
                configuration.labelConfiguration.textColor = .black
                configuration.labelConfiguration.font = .systemFont(ofSize: 14, weight: .semibold)
                return configuration
            })
        case 3:
            sender.tooltip("Original .left Orientation is updated automatically because of layout constraints", orientation: .left)
        case 4:
            sender.tooltip("Define the width of a tooltip dynamically", orientation: .left, configuration: smallTooltipConfig)
        default:
            break
        }
    }
    
    @objc func didPressBarButton(_ sender: UIBarButtonItem) {
        sender.tooltip("BarButtons are also supported", orientation: .bottom)
    }

}

fileprivate extension NSLayoutConstraint {
    @discardableResult
    func activate() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }
}
