//
//  PeopleTableViewCell.swift
//  java_kurs
//
//  Created by Александр Крайнов on 23.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var studentGroupLabel: UILabel!
    @IBOutlet private var typeImage: UIImageView!
    @IBOutlet private var idLabel: UILabel!
    
    func setup(with person: Person) {
        nameLabel.text = "\(person.last_name) \(person.first_name) \(person.pather_name)"
        if let group_name = person.student_group {
            studentGroupLabel.text = "Group \(group_name.name)"
        } else {
            studentGroupLabel.text = "Teaching Staff"
        }
        
        if(person.type == "t") {
            typeImage.image = UIImage(systemName: "t.circle.fill")
        }
        if(person.type == "s") {
            typeImage.image = UIImage(systemName: "s.circle.fill")
        }
        idLabel.text = "id: \(person.id)"
        
    }
}
