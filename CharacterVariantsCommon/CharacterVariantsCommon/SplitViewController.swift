//
//  SplitViewController.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import UIKit

public class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    public lazy var listViewController: ListViewController = {
        let listViewController: ListViewController = ListViewController(listViewControllerViewDidLoadCallback: listViewControllerViewDidLoadHandler)
        return listViewController
    }()
    public lazy var detailViewController: DetailViewController = {
        let detailViewController: DetailViewController = DetailViewController()
        return detailViewController
    }()
    public lazy var viewModelCoordinator: ViewModelCoordinator = {
        let viewModelCoordinator: ViewModelCoordinator = ViewModelCoordinator.init(
            databaseLoadedCallback: databaseLoadedCallback,
            filteredCharactersChangedCallback: filteredCharactersChangedCallback
        )
        return viewModelCoordinator
    }()
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public func setup() -> Void {
        delegate = self
        viewControllers = [listViewController, detailViewController]
        detailViewController.dismissesOnTouch = true
        detailViewController.dismissingSplitViewController = self
        preferredDisplayMode = .allVisible
        presentsWithGesture = false
    }
    public func databaseLoadedCallback() -> Void {
        viewModelCoordinator.refreshCharacterViewModels()
        listViewController.charactersTableView.reloadData()
    }
    public func filteredCharactersChangedCallback() -> Void {
        listViewController.charactersTableView.reloadData()
    }
    public func listViewControllerViewDidLoadHandler() -> Void {
        listViewController.logoHeaderView.label.text = "Viewer"
        listViewController.searchTextField.placeholder = "Search character names and descriptions"
        listViewController.searchTextField.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
        listViewController.charactersTableView.dataSource = self
        listViewController.charactersTableView.delegate = self
        listViewController.buttonContainerView.deleteCharactersButton.addTarget(self, action: #selector(deleteCharactersButtonPressed), for: .touchUpInside)
        listViewController.buttonContainerView.refreshCharactersButton.addTarget(self, action: #selector(refreshCharactersButtonPressed), for: .touchUpInside)
    }
}

extension SplitViewController {
    @objc private func searchTextDidChange() -> Void {
        viewModelCoordinator.filterText = listViewController.searchTextField.text ?? String.empty
    }
    
    @objc private func deleteCharactersButtonPressed() -> Void {
        UserInputCoordinator.DeleteCharacters.deleteCharacters(with: viewModelCoordinator)
        detailViewController.characterViewModel = nil
    }
    @objc private func refreshCharactersButtonPressed() -> Void {
        UserInputCoordinator.RefreshCharacters.refreshCharacters(with: viewModelCoordinator)
        detailViewController.characterViewModel = nil
    }
}


extension SplitViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelCoordinator.filteredCharacterViewModels.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CharacterCell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseIdentifier) as? CharacterCell {
            cell.characterLabel.text = viewModelCoordinator.filteredCharacterViewModels[indexPath.row].title
            return cell
        }
        Configuration.printFatalError("ERROR: ViewModelCoordinator.tableView cellForRowAtIndexPath cell == nil")
    }
}


extension SplitViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailViewController.characterViewModel = viewModelCoordinator.filteredCharacterViewModels[indexPath.row]
        show(detailViewController, sender: nil)
    }
}
