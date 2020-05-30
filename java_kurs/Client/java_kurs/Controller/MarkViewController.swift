//
//  MarkViewController.swift
//  java_kurs
//
//  Created by Александр Крайнов on 23.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import UIKit

import UIKit

class MarkViewController: UIViewController , UITableViewDataSource {
    
    @IBAction func onAddPress(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add mark", message: nil, preferredStyle: .alert)
        alert.addTextField { markTF in
            markTF.placeholder = "Enter student id"
        }
        alert.addTextField { markTF in
            markTF.placeholder = "Enter teacher id"
        }
        alert.addTextField { markTF in
            markTF.placeholder = "Enter subject id"
        }
        alert.addTextField { markTF in
            markTF.placeholder = "Enter value"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            guard let student  = alert.textFields?.first?.text else {
                return
            }
            guard let teacher  = alert.textFields?[1].text else {
                return
            }
            guard let subject  = alert.textFields?[2].text else {
                return
            }
            guard let value  = alert.textFields?[3].text else {
                return
            }
            var request = URLRequest(url: URL(string: self.addmarkURL)!)
            let json: [String: Any] = [
                "student": student,
                "teacher": teacher,
                "subject": subject,
                "value": value
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
                        _ = try decoder.decode([Mark].self, from: data)
                    } catch {
                        DispatchQueue.main.async {
                            let buf = try? decoder.decode(Error.self, from: data)
                            if (buf != nil) {
                                if(buf?.status == 409) {
                                let alert = UIAlertController(title: "Confliting data", message: "Check if the provided IDs correspond to the correct roles", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                } else {
                                    if(buf?.status == 403)
                                    {
                                let alert = UIAlertController(title: "Invalid acess", message: "Your role cannot edit the files", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                    } else {
                                        let alert = UIAlertController(title: "Invalid ids", message: "Check if the provided ids do exist", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                    self.viewDidAppear(true)
                }
            }
            .resume()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(action2)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        marks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkTableCell", for: indexPath) as! MarkViewCell
        cell.setup(with: marks[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        var request = URLRequest(url: URL(string: "\(self.markURL)\(marks[indexPath.row].id)")!)
        request.httpMethod = "DELETE"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                _ = try decoder.decode([Mark].self, from: data)
            } catch {
                let buf = try? decoder.decode(Error.self, from: data)
                if (buf != nil) {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Invalid acess", message: "Your role cannot edit the files", preferredStyle: .alert)
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
    
    
    let markURL =  "http://localhost:8080/dc/marks/"
    let addmarkURL = "http://localhost:8080/dc/add_mark"
    @IBOutlet private var tableView: UITableView!
    var marks = [Mark]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 200
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.token == nil) {
            self.performSegue(withIdentifier: "loginView", sender: self)
        } else {
            var request = URLRequest(url: URL(string: markURL)!)
            request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                let decoder = JSONDecoder()
                print("JSON String: \(String(describing: String(data: data, encoding: .utf8)))")
                let marks = try? decoder.decode([Mark].self, from: data)
                self.marks = marks ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .resume()
        }
    }
    
    
}
