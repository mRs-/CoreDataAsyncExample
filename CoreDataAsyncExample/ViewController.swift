//
//  ViewController.swift
//  CoreDataAsyncExample
//
//  Created by Marius Landwehr on 06.02.17.
//  Copyright © 2017 Marius Landwehr. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UITableViewController {
    
    typealias JSON = [String: Any]
    typealias JSONArray = [JSON]
    
    var data: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Test")
        
        fetchRandomUserData()
    }
    
    private func fetchRandomUserData() {
        DispatchQueue.global(qos: .background).async {
            
            var i = 0
            
            repeat {
                
                i += 1
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + Double(i), execute: {
                    let randomInt = arc4random_uniform(UINT32_MAX)
                    URLSession.shared.dataTask(with: URL(string: "https://randomuser.me/api/?results=1&rand=\(randomInt)")!) { (data, response, error) in
                        
                        guard
                            let data = data,
                            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON,
                            let results = jsonObject?["results"] as? JSONArray else {
                                return
                        }
                        
                        let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).backgroundContext!
                        
                        for user in results {
                            let userDataObject = User(context: backgroundContext)
                            let name = user["name"] as? [String: String]
                            userDataObject.firstname = name?["first"]
                            userDataObject.lastname = name?["last"]
                        }
                        
                        try? backgroundContext.save()
                        
                        DispatchQueue.main.async {
                            self.populateTableViewFromCoreData()
                        }
                        
                        }.resume()
                })
            } while (i < 110)
        }
    }
    
    private func populateTableViewFromCoreData() {
        
        let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        data = try! persistentContainer?.viewContext.fetch(fetchRequest)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Test")
        cell.textLabel?.text = "\(data?[indexPath.row].firstname ?? "") \(data?[indexPath.row].lastname ?? "")"
        return cell
    }
}

