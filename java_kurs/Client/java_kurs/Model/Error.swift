//
//  Error.swift
//  java_kurs
//
//  Created by Александр Крайнов on 23.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import Foundation

struct Error: Decodable {
    var status: Int
    var error: String
}
