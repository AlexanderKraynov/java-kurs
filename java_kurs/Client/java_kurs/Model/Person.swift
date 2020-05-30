//
//  Person.swift
//  java_kurs
//
//  Created by Александр Крайнов on 23.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import Foundation

struct Person: Decodable {
    var id: Int
    var first_name: String
    var last_name: String
    var pather_name: String
    var student_group: Group?
    var type: String
}
