//
//  PeopleViewContoller.swift
//  java_kurs
//
//  Created by Александр Крайнов on 23.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import Foundation

import UIKit

class PeopleViewController: UIViewController , UITableViewDataSource {
    
    @IBAction func onAddPress(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add person", message: nil, preferredStyle: .alert)
        alert.addTextField { personTF in
            personTF.placeholder = "Enter first name"
        }
        alert.addTextField { personTF in
            personTF.placeholder = "Enter last name"
        }
        alert.addTextField { personTF in
            personTF.placeholder = "Enter pather name"
        }
        alert.addTextField { personTF in
            personTF.placeholder = "Enter group id"
        }
        let action = UIAlertAction(title: "Add as a student", style: .default) { _ in
            guard let first_name  = alert.textFields?.first?.text else {
                return
            }
            guard let second_name  = alert.textFields?[1].text else {
                return
            }
            guard let pather_name  = alert.textFields?[2].text else {
                return
            }
            guard let student_group  = alert.textFields?[3].text else {
                return
            }
            var request = URLRequest(url: URL(string: self.addpersonURL)!)
            let json: [String: Any] = [
                "first_name": first_name,
                "last_name": second_name,
                "pather_name": pather_name,
                "student_group": student_group,
                "type": "s"
            ]
            request.httpMethod = "POST"
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, error in
                DispatchQueue.main.async {
                    guard let data = data else {
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        _ = try decoder.decode([Person].self, from: data)
                    } catch {
                        DispatchQueue.main.async {
                            let buf = try? decoder.decode(Error.self, from: data)
                            if (buf != nil) {
                                if(buf?.status == 403) {
                                let alert = UIAlertController(title: "Invalid acess", message: "Your role cannot edit the files", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                } else {
                                    let alert = UIAlertController(title: "Invalid group id", message: "Use valid group id", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    self.viewDidAppear(true)
                }
            }
            .resume()
        }
        let action3 = UIAlertAction(title: "Add as a teacher", style: .default) { _ in
            guard let first_name  = alert.textFields?.first?.text else {
                return
            }
            guard let second_name  = alert.textFields?[1].text else {
                return
            }
            guard let pather_name  = alert.textFields?[2].text else {
                return
            }
            var request = URLRequest(url: URL(string: self.addpersonURL)!)
            let json: [String: Any] = [
                "first_name": first_name,
                "last_name": second_name,
                "pather_name": pather_name,
                "student_group": "",
                "type": "t"
            ]
            request.httpMethod = "POST"
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, error in
                DispatchQueue.main.async {
                    guard let data = data else {
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                          print("JSON String: \(String(describing: String(data: data, encoding: .utf8)))")
                        _ = try decoder.decode([Person].self, from: data)
                    } catch {
                        DispatchQueue.main.async {
                            let buf = try? decoder.decode(Error.self, from: data)
                            if (buf != nil) {
                                let alert = UIAlertController(title: "Invalid acess", message: "Your role cannot edit the files", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    self.viewDidAppear(true)
                }
            }
            .resume()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(action)
        alert.addAction(action3)
        alert.addAction(action2)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableCell", for: indexPath) as! PeopleTableViewCell
        cell.setup(with: persons[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        var request = URLRequest(url: URL(string: "\(self.personURL)\(persons[indexPath.row].id)")!)
        request.httpMethod = "DELETE"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                
                _ = try decoder.decode([Person].self, from: data)
            } catch {
                let buf = try? decoder.decode(Error.self, from: data)
                if (buf != nil) {
                    if(buf?.status == 403) {
                    let alert = UIAlertController(title: "Invalid acess", message: "Your role cannot edit the files", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Invalid group id", message: "Use valid group id", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            DispatchQueue.main.async {
                self.viewDidAppear(true)
            }
        }
        .resume()
    }
    
    
    let personURL =  "http://localhost:8080/dc/people/"
    let addpersonURL = "http://localhost:8080/dc/add_person"
    @IBOutlet private var tableView: UITableView!
    var persons = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.token == nil) {
            self.performSegue(withIdentifier: "loginView", sender: self)
        } else {
            var request = URLRequest(url: URL(string: personURL)!)
            request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                let decoder = JSONDecoder()
                let persons = try? decoder.decode([Person].self, from: data)
                self.persons = persons ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .resume()
        }
    }
    
    
}
