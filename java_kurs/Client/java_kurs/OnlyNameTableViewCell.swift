//
//  GroupTableViewCell.swift
//  java_kurs
//
//  Created by Александр Крайнов on 22.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import UIKit

class OnlyNameTableViewCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var idLabel:UILabel!
    
    func setup(with group: Group) {
        nameLabel.text = group.name
        idLabel.text = "id: \(group.id)"
    }
    
    func setup(with subject: Subject) {
        nameLabel.text = subject.name
        idLabel.text = "id: \(subject.id)"
    }
}
