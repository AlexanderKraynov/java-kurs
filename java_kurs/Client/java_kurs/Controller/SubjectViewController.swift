//
//  SubjectViewController.swift
//  java_kurs
//
//  Created by Александр Крайнов on 23.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController , UITableViewDataSource {
    
    @IBAction func onAddPress(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add subject", message: nil, preferredStyle: .alert)
        alert.addTextField { subjectTF in
            subjectTF.placeholder = "Enter subject name"
        }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            guard let subject  = alert.textFields?.first?.text else {
                return
            }
            var request = URLRequest(url: URL(string: self.addsubjectURL)!)
            let json: [String: Any] = ["name": subject]
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
                        _ = try decoder.decode([Subject].self, from: data)
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
        alert.addAction(action2)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectTableCell", for: indexPath) as! OnlyNameTableViewCell
        cell.setup(with: subjects[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        var request = URLRequest(url: URL(string: "\(self.subjectURL)\(subjects[indexPath.row].id)")!)
        request.httpMethod = "DELETE"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                _ = try decoder.decode([Subject].self, from: data)
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
    
    
    let subjectURL =  "http://localhost:8080/dc/subjects/"
    let addsubjectURL = "http://localhost:8080/dc/add_subject"
    @IBOutlet private var tableView: UITableView!
    var subjects = [Subject]()
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
            var request = URLRequest(url: URL(string: subjectURL)!)
            request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                let decoder = JSONDecoder()
                print("JSON String: \(String(describing: String(data: data, encoding: .utf8)))")
                let subjects = try? decoder.decode([Subject].self, from: data)
                self.subjects = subjects ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .resume()
        }
    }
    
    
}
