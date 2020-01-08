//
//  ListViewController.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import UIKit

public class ListViewController: UIViewController {
    public typealias ListViewControllerViewDidLoadCallback = () -> Void
    private var listViewControllerViewDidLoadCallback: ListViewControllerViewDidLoadCallback?
    
    public init(listViewControllerViewDidLoadCallback: @escaping ListViewControllerViewDidLoadCallback) {
        super.init(nibName: nil, bundle: nil)
        self.listViewControllerViewDidLoadCallback = listViewControllerViewDidLoadCallback
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public lazy var backgroundGradientLayer: GradientLayer = {
        let gradientLayer: GradientLayer = GradientLayer()
        gradientLayer.parent = .list
        gradientLayer.frame = view.bounds
        return gradientLayer
    }()
    public lazy var logoHeaderView: LogoHeaderView = {
        let logoHeaderView = LogoHeaderView()
        logoHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoHeaderView)
        NSLayoutConstraint.activate([
            logoHeaderView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            logoHeaderView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            logoHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoHeaderView.heightAnchor.constraint(equalToConstant: ViewConfiguration.List.Header.height)
        ])
        return logoHeaderView
    }()
    public lazy var searchTextField: UITextField = {
        let searchTextField: UITextField = UITextField.textField(font: ViewConfiguration.List.Search.font, textColor: mainConfiguration.colorScheme.font.color, textAlignment: .left, numberOfLines: 1)
        searchTextField.isUserInteractionEnabled = true
        searchTextField.delegate = self
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: ViewConfiguration.insetX),
            searchTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -ViewConfiguration.insetX),
            searchTextField.topAnchor.constraint(equalTo: logoHeaderView.bottomAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: ViewConfiguration.List.Search.height)
        ])
        return searchTextField
    }()
    public lazy var charactersTableView: UITableView = {
        let charactersTableView: UITableView = UITableView()
        charactersTableView.translatesAutoresizingMaskIntoConstraints = false
        charactersTableView.backgroundColor = .clear
        charactersTableView.layer.cornerRadius = ViewConfiguration.List.Table.cornerRadius
        view.addSubview(charactersTableView)
        NSLayoutConstraint.activate([
            charactersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ViewConfiguration.insetX),
            charactersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ViewConfiguration.insetX),
            charactersTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            charactersTableView.bottomAnchor.constraint(equalTo: self.buttonContainerView.topAnchor)
        ])
        charactersTableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseIdentifier)
        return charactersTableView
    }()
    public lazy var buttonContainerView: ButtonContainerView = {
        let buttonContainerView: ButtonContainerView = ButtonContainerView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainerView)
        NSLayoutConstraint.activate([
            buttonContainerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            buttonContainerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            buttonContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ViewConfiguration.insetX),
            buttonContainerView.heightAnchor.constraint(equalToConstant: ViewConfiguration.Button.height + 2*ViewConfiguration.insetX)
        ])
        return buttonContainerView
    }()
    
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let listViewControllerViewDidLoadCallback: ListViewControllerViewDidLoadCallback = listViewControllerViewDidLoadCallback {
            listViewControllerViewDidLoadCallback()
            self.listViewControllerViewDidLoadCallback = nil
        }
    }
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        if let listViewControllerViewDidLoadCallback: ListViewControllerViewDidLoadCallback = listViewControllerViewDidLoadCallback {
//            listViewControllerViewDidLoadCallback()
//        }
//    }
}


extension ListViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
