//
//  ViewController.swift
//  java_kurs
//
//  Created by Александр Крайнов on 22.05.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import Alamofire
import UIKit

class GroupViewController: UIViewController, UITableViewDataSource {
    
    @IBAction func onAddPress(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add group", message: nil, preferredStyle: .alert)
        alert.addTextField { groupTF in
            groupTF.placeholder = "Enter group name"
        }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            guard let group  = alert.textFields?.first?.text else {
                return
            }
            var request = URLRequest(url: URL(string: self.addGroupURL)!)
            let json: [String: Any] = ["name": group]
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
                        _ = try decoder.decode([Group].self, from: data)
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
        groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableCell", for: indexPath) as! OnlyNameTableViewCell
        cell.setup(with: groups[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        var request = URLRequest(url: URL(string: "\(self.groupURL)\(groups[indexPath.row].id)")!)
        request.httpMethod = "DELETE"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                print("JSON String: \(String(describing: String(data: data, encoding: .utf8)))")
                print(error.debugDescription)
                _ = try decoder.decode(Group.self, from: data)
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
    
    
    let groupURL =  "http://localhost:8080/dc/groups/"
    let addGroupURL = "http://localhost:8080/dc/add_group"
    @IBOutlet private var tableView: UITableView!
    var groups = [Group]()
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
            var request = URLRequest(url: URL(string: groupURL)!)
            request.setValue( "Bearer \(appDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                let decoder = JSONDecoder()
                let groups = try? decoder.decode([Group].self, from: data)
                self.groups = groups ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .resume()
        }
    }
    
    
}


