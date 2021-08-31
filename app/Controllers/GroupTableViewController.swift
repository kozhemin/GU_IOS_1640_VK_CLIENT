//
//  GroupTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

class GroupTableViewController: UITableViewController {
    private var group = [DefaultTableDataProtocol]()
    @IBOutlet var GroupTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        loadData()
        GroupTableView.reloadData()
    }

    public func loadData() {
        group = testGroupData.filter { $0.isMain == true }
    }
}

extension GroupTableViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return group.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "GroupCell")
        }

        configGroupCell(cell: &cell, for: indexPath, item: group)
        return cell
    }
}

extension GroupTableViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionDelete = UIContextualAction(style: .destructive, title: "") {_, _, complete in
            
            let alert = UIAlertController(
                title: "Confirm",
                message: "Are you sure you want to leave the group?",
                preferredStyle: .actionSheet
            )
            
            alert.addAction(
                UIAlertAction(
                    title: NSLocalizedString("OK", comment: "Default action"),
                    style: .destructive,
                    handler: { _ in
                        testGroupData.changeAttrIsMainByName(groupName: self.group[indexPath.row].name, direction: false)
                        self.loadData()
                        tableView.reloadData()
                    }
                )
            )
            
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: { [complete] _ in complete(true) }
                )
            )
            
            self.present(alert, animated: true, completion: nil)
        }
        
        actionDelete.image = UIImage(systemName: "person.fill.xmark")
       
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
}
