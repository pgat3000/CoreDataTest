//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Pablo Gatgens on 3/26/22.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private var models = [ToDoLIstItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Data Todo List"
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter new to do list item!", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        
        present(alert ,animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       // cell.textLabel?.text = "\(model.name)-\(model.createdAt)"
        cell.textLabel?.text = model.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = models[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let sheet = UIAlertController(title: "Edit", message:nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your  item!", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {[weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName)
            }))
            
            self.present(alert ,animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
            self?.deleteItem(item: item)
        }))
       
        present(sheet ,animated: true)
    }
    
    
    //Core Data
    func getAllItems(){
        do{
           models = try  context.fetch(ToDoLIstItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
            title="Core Data To Do List"
        }
        catch{
            // in case of error
        }
        
    }
    func createItem(name: String){
        let newItem = ToDoLIstItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        do{
            try context.save()
            getAllItems()
        }catch{
        // in case of error
        }
        
        }
    
    func deleteItem(item: ToDoLIstItem){
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }catch{
        // in case of error
        }
        
    }
    func updateItem(item: ToDoLIstItem, newName: String){
        item.name = newName
        do{
            try context.save()
            getAllItems()   
        }catch{
        // in case of error
        }
    }
}

