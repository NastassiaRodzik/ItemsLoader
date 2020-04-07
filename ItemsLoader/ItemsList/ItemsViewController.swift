//
//  ItemsViewController.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit
import Combine

final class ItemsViewController: UIViewController {

    @IBOutlet weak private var noItemsAvailableView: UIView!
    @IBOutlet weak private var itemsTableView: UITableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private let itemsViewModel = ItemsViewModel()
    private var itemsCancellable: Cancellable!
    private var items: [ItemsGroupedList] = [] {
        didSet {
            let isItemsListsAvailable = !items.isEmpty
            self.noItemsAvailableView.isHidden = isItemsListsAvailable
            self.itemsTableView.isHidden = !isItemsListsAvailable
            self.itemsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadTableData()
    }
    
    private func setupTableView() {
        itemsTableView.register(UINib(nibName: ItemTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
        itemsTableView.dataSource = self
        itemsTableView.rowHeight = ItemTableViewCell.rowHeight
        itemsTableView.accessibilityIdentifier = "ItemsTableView"
    }
    
    private func loadTableData() {
        activityIndicator.startAnimating()

        itemsViewModel.prepareItems()
        itemsCancellable = itemsViewModel.itemsSubject
            .dropFirst()
            .sink(receiveCompletion: { [weak self] failure in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                switch failure {
                case .failure(let error):
                    self.showErrorAlert(with: error)
                case .finished:
                    self.itemsCancellable.cancel()
                }
            }
            
        }) { [weak self] list in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.items = list
            }
        }
        
    }
    
    private func showErrorAlert(with error: Error) {
        let errorDescription: String?
        if let localizedError = error as? LocalizedError {
            errorDescription = localizedError.errorDescription
        } else {
            errorDescription = error.localizedDescription
        }
        let alert = UIAlertController(title: NSLocalizedString("Sorry, we cannot display data", comment: ""),
                                      message: errorDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: .cancel,
                                     handler: nil)
        let tryAgainAction = UIAlertAction(title: NSLocalizedString("Try Again", comment: ""),
                                           style: .default) { _ in
                                            self.loadTableData()
        }
        alert.addAction(okAction)
        alert.addAction(tryAgainAction)
        present(alert, animated: true, completion: nil)
    }

}

extension ItemsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier) as! ItemTableViewCell
        let list = items[indexPath.section]
        let item = list.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let listIdentifier = items[section].listId
        return String(format: NSLocalizedString("List Identifier: %@", comment: ""), "\(listIdentifier)")
    }
    
}
