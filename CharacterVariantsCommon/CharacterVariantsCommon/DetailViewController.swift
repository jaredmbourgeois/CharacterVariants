//
//  DetailViewController.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import UIKit

public class DetailViewController: UIViewController, Dismissable {
    public var dismissesOnTouch: Bool?
    public unowned var dismissingSplitViewController: UISplitViewController?
    private let configuration: Configuration = Configuration.configuration()
    
    private var characterViewModelTitlesObserved: [String] = []
    public weak var characterViewModel: ViewModel.Character? {
        didSet {
            if let characterViewModel: ViewModel.Character = characterViewModel {
                var observingChanges = false
                self.characterViewModelTitlesObserved.forEach({ if ($0 == characterViewModel.title) { observingChanges = true } })
                if !observingChanges {
                    characterViewModel.didSetHandlers.append(characterViewModelChanged(characterViewModel:))
                    self.characterViewModelTitlesObserved.append(characterViewModel.title)
                }
                characterTitleLabel.text = characterViewModel.title
                characterImageView.image = characterViewModel.image
                characterDescriptionLabel.text = characterViewModel.description
            }
            else {
                setEmpty()
            }
        }
    }
    
    private func setEmpty() -> Void {
        characterTitleLabel.text = "select a character"
        characterImageView.image = nil
        characterDescriptionLabel.text = String.empty
    }
    
    public lazy var backgroundGradientLayer: GradientLayer = {
        let gradientLayer: GradientLayer = GradientLayer()
        gradientLayer.parent = .detail
        gradientLayer.frame = view.bounds
        return gradientLayer
    }()
    public lazy var characterTitleLabel: UILabel = {
        let label: UILabel = UILabel.label(font: ViewConfiguration.Detail.fontTitle, textColor: configuration.colorScheme.listBackgroundLight.color, textAlignment: .center, numberOfLines: 1)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: ViewConfiguration.insetX),
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -ViewConfiguration.insetX),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewConfiguration.insetX),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: ViewConfiguration.Detail.heightHeader)
        ])
        return label
    }()
    public lazy var characterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -ViewConfiguration.Detail.insetY),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, constant: -2*ViewConfiguration.insetX),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: -(2*ViewConfiguration.insetX + 2*ViewConfiguration.Detail.insetY + ViewConfiguration.Detail.heightFooter + ViewConfiguration.Detail.heightHeader))
        ])
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        return imageView
    }()
    public lazy var characterDescriptionLabel: UILabel = {
        let label: UILabel = UILabel.label(font: ViewConfiguration.Detail.fontTitle, textColor: mainConfiguration.colorScheme.listBackgroundLight.color, textAlignment: .center, numberOfLines: 0)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: ViewConfiguration.insetX),
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -ViewConfiguration.insetX),
            label.heightAnchor.constraint(lessThanOrEqualToConstant: ViewConfiguration.Detail.heightFooter),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ViewConfiguration.insetX)
        ])
        return label
    }()
    
    
    public override func viewDidLoad() {
        setEmpty()
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        backgroundGradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundGradientLayer.setNeedsDisplay()
    }
    
    
    public func characterViewModelChanged(characterViewModel: ViewModel.Character) {
        if let currentViewModel = self.characterViewModel {
            if (currentViewModel === characterViewModel) {
                characterTitleLabel.text = characterViewModel.title
                characterImageView.image = currentViewModel.image
                characterDescriptionLabel.text = characterViewModel.description
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let dismissesOnTouch: Bool = dismissesOnTouch {
            if dismissesOnTouch { dismiss() }
        }
    }
    
    public func dismiss() {
        if let dismissingSplitViewController: UISplitViewController = dismissingSplitViewController,
        let splitViewControllerDelegate: UISplitViewControllerDelegate = dismissingSplitViewController.delegate {
            splitViewControllerDelegate.dismissDetailViewControllerHandler(UISplitViewController.DismissDetailViewController(
                splitViewController: dismissingSplitViewController,
                animated: true,
                handlerCompletionHandler: {
                    if let splitViewController: SplitViewController = dismissingSplitViewController as? SplitViewController,
                    let selectedIndexPath: IndexPath = splitViewController.listViewController.charactersTableView.indexPathForSelectedRow {
                            splitViewController.listViewController.charactersTableView.deselectRow(at: selectedIndexPath, animated: true)
                    }
                }
            ))
        }
    }
}
