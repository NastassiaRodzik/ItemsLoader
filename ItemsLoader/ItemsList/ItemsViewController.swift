//
//  ItemsViewController.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit

final class ItemsViewController: UIViewController {

    @IBOutlet weak private var noItemsAvailableView: UIView!
    @IBOutlet weak private var itemsTableView: UITableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private let itemsViewModel = ItemsViewModel()
    
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
        itemsViewModel.prepareItems { [weak self] errorDescription in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.activityIndicator.stopAnimating()
                guard errorDescription == nil else {
                    self.showErrorAlert(with: errorDescription)
                    return
                }
                
                self.noItemsAvailableView.isHidden = self.itemsViewModel.isItemsListsAvailable
                self.itemsTableView.isHidden = !self.itemsViewModel.isItemsListsAvailable
                self.itemsTableView.reloadData()
            }
        }
    }
    
    private func showErrorAlert(with errorDescription: String?) {
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
        return itemsViewModel.lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lists = itemsViewModel.lists else {
            return 0
        }
        return lists[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier) as! ItemTableViewCell
        if let list = itemsViewModel.lists?[indexPath.section] {
            let item = list.items[indexPath.row]
            cell.configure(with: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let lists = itemsViewModel.lists else {
            return nil
        }
        let listIdentifier = lists[section].listId
        return String(format: NSLocalizedString("List Identifier: %@", comment: ""), "\(listIdentifier)")
    }
    
}
