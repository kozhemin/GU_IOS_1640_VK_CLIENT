//
//  GroupSearchTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

class GroupSearchTableViewController: UITableViewController {
    private var group = [DefaultTableDataProtocol]()
    @IBOutlet var GroupSearchTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        loadData()
        GroupSearchTableView.reloadData()
    }

    public func loadData() {
        group = testGroupData.filter { $0.isMain == false }
    }
}

extension GroupSearchTableViewController {
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

extension GroupSearchTableViewController {
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionCustomBtn = UIContextualAction(style: .normal, title: ""){_,_,_ in
            testGroupData.changeAttrIsMainByName(groupName: self.group[indexPath.row].name, direction: true)
            self.loadData()
            self.GroupSearchTableView.reloadData()
        }
        actionCustomBtn.backgroundColor = .blue
        actionCustomBtn.image = UIImage(systemName: "person.fill.checkmark")
        return UISwipeActionsConfiguration(actions: [actionCustomBtn])
    }
}
