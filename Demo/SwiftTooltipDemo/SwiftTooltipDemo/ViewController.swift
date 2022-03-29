//
//  ViewController.swift
//  SwiftTooltipDemo
//
//  Created by Felix Desiderato on 28.03.22.
//

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
//        buttonStackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).activate()
//        buttonStackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).activate()
        buttonStackview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).activate()
        
        populateView()
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

}

fileprivate extension NSLayoutConstraint {
    @discardableResult
    func activate() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }
}
