//
//  ViewController.swift
//  Firebase101
//
//  Created by 김동환 on 2021/05/24.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var firstData: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        
//        saveBasicTypes()
//        saveCustomers()
        fetchCustomers()
    }

    func updateLabel(){
        db.child("firstData").observeSingleEvent(of: .value){ snapshot in
            
            let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.firstData.text = value
            }
        }
    }
}

extension ViewController {
    func fetchCustomers(){
        db.child("customers").observeSingleEvent(of: .value) { snapshot in
            
            do{
                let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                let decoder = JSONDecoder()
                let customers: [Customer] = try decoder.decode([Customer].self, from: data)
                DispatchQueue.main.async {
                    self.countLabel.text = "\(customers.count)"
                }
            }catch let error{
                print(error)
            }
            
        }
    }
}

extension ViewController {
    func saveBasicTypes(){
        db.child("int").setValue(3)
        db.child("double").setValue(3.5)
        db.child("str").setValue("str set")
        db.child("array").setValue(["a", "b", "c"])
        db.child("dict").setValue(["id" : "anyId", "age" : 10, "city" : "seoul"])
    }
    
    func saveCustomers(){
        let books = [Book(title: "Good to Great", author: "Someone"), Book(title: "Hacking Growth", author: "Somebody")]
        
        let customer1 = Customer(id: "\(Customer.id)", name: "Son", books: books)
        Customer.id += 1
        let customer2 = Customer(id: "\(Customer.id)", name: "Dele", books: books)
        Customer.id += 1
        let customer3 = Customer(id: "\(Customer.id)", name: "Kane", books: books)
        db.child("customers").child(customer1.id).setValue(customer1.toDictionary)
        db.child("customers").child(customer2.id).setValue(customer2.toDictionary)
        db.child("customers").child(customer3.id).setValue(customer3.toDictionary)
    }
}

struct Customer: Codable {
    let id: String
    let name: String
    let books: [Book]
    
    var toDictionary: [String : Any] {
        let booksArray = books.map{$0.toDictionary}
        let dict: [String: Any] = ["id" : id, "name" : name, "books" : booksArray]
        return dict
    }
    
    static var id: Int = 0
    
}

struct Book: Codable {
    let title: String
    let author: String
    
    var toDictionary: [String : Any] {
        let dict: [String : Any] = ["title" : title, "author" : author]
        return dict
    }
}
