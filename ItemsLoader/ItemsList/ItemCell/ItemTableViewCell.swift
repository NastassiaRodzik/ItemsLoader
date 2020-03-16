//
//  ItemTableViewCell.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit

final class ItemTableViewCell: UITableViewCell {

    static let rowHeight: CGFloat = 60.0
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    @IBOutlet weak private var nameLabel: UILabel!
    
    func configure(with viewModel: ItemTableViewCellViewModel) {
        nameLabel.text = viewModel.name
    }
    
}
