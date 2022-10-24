//
//  ContactsViewController.swift
//  Trough
//
//  Created by Imed on 03/11/2021.

import UIKit
import Contacts

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success{
                print("Authrization successfull")
            }
        }
        fetchContacts()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ContactsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let contactToDisplay = contacts[indexPath.row]
        cell.textLabel?.text = contactToDisplay.givenName + " " + contactToDisplay.familyName
        cell.detailTextLabel?.text = contactToDisplay.number
        cell.accessoryType = .checkmark
        return cell
    }
    
    func fetchContacts(){
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as[CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try! contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
            let name = contact.givenName
            let familyName = contact.familyName
            let number = contact.phoneNumbers.first?.value.stringValue
            let contactToAppend = ContactStruct(givenName: name, familyName: familyName, number: number!)
            self.contacts.append(contactToAppend)
        }
        tableView.reloadData()
    }
    
}
