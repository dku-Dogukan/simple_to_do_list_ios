//
//  ViewController.swift
//  To Do List With CORE DATA
//
//  Created by DKU on 04/08/2018.
//  Copyright © 2018 dku. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    //xcdatamodeld uzantili yerde tanimladigimiz Item listi olusturuyoruz.
    var itemsList = [Items]() ;
    
    //bu aslinda bizim containerimiz oluyor bilgileri tutan , ve persistence datanin nasil islenecegi Appdelegate tetanimlandigi icin oraya delegate veriyoruz.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Table View Delegate Methods:
    
    //Boolean degerini tersine cevir , boylece image i guncelle ve kaydet anlamina geliyor
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        itemsList[indexPath.row].completed = !itemsList[indexPath.row].completed
        
        saveItems();
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            let item = itemsList[indexPath.row];
            
            itemsList.remove(at: indexPath.row);
            context.delete(item);
            
            do{
                try context.save();
            }
            catch{
                print("\(error) ")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic);
        }
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath);
        let item = itemsList[indexPath.row];
        
        cell.textLabel?.text = item.name ;
       // item.completed = false ;
        cell.accessoryType = item.completed ? .checkmark : .none
        
        return cell ;
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert);
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            let newItem = Items(context: self.context);
            newItem.name = textField.text!;
            newItem.completed = false ;
            self.itemsList.append(newItem);
            self.saveItems();
            
        }
        
        alert.addAction(action);
        alert.addTextField { (field) in
            textField = field ;
            textField.placeholder = "Add new Todo"
        }
        
        present(alert, animated: true, completion: nil);
    }
    
    func saveItems(){
        
        do {
            try context.save();
        }
        catch
        {
            print("\(error)")
        }
        tableView.reloadData();
    }
    
    func loadItems(){
        let request : NSFetchRequest<Items> = Items.fetchRequest();
        
        do{
        itemsList = try context.fetch(request)
        }
        catch{
            print("\(error)")
        }
        
        tableView.reloadData();
    }
    
}

