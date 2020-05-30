//
//  Mark.swift
//  java_kurs
//
//  Created by Александр Крайнов on 23.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import Foundation

struct Mark: Decodable {
    var id: Int
    var student: Person
    var teacher: Person
    var subject: Subject
    var value: Int
}
