//
//  MarkViewCell.swift
//  java_kurs
//
//  Created by Александр Крайнов on 23.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import UIKit

class MarkViewCell: UITableViewCell {
    @IBOutlet private var studentLabel: UILabel!
    @IBOutlet private var teacherLabel: UILabel!
    @IBOutlet private var subjectLabel: UILabel!
    @IBOutlet private var markLabel: UILabel!
    
    func setup(with mark: Mark) {
        var person = mark.student
        studentLabel.text = "Student: \(person.last_name) \(person.first_name) \(person.pather_name)"
        person = mark.teacher
        teacherLabel.text = "Teacher: \(person.last_name) \(person.first_name) \(person.pather_name)"
        subjectLabel.text = "Subject: \(mark.subject.name)"
        markLabel.text = "Mark: \(mark.value)"
    }
}
