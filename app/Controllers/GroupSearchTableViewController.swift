//
//  GroupSearchTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

class GroupSearchTableViewController: UITableViewController {
    private var group = [DefaultTableDataProtocol]() {
        didSet {
            GroupSearchTableView.reloadData()
        }
    }

    @IBOutlet var GroupSearchTableView: UITableView!
    @IBOutlet var searchField: UISearchBar!

    override func viewDidLoad() {
        searchField.delegate = self
    }

    override func viewWillAppear(_: Bool) {
        loadData()
    }

    func getGroup() -> [DefaultTableDataProtocol] {
        return group
    }

    func loadData() {
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !testGroupData.isMain(groupName: group[indexPath.row].name) {
            let alert = UIAlertController(
                title: "Confirm",
                message: "Are you sure you want to add a group ?",
                preferredStyle: .actionSheet
            )

            alert.addAction(
                UIAlertAction(
                    title: NSLocalizedString("OK", comment: "Default action"),
                    style: .default,
                    handler: { _ in
                        self.performSegue(withIdentifier: "addGroupSegue", sender: nil)
                    }
                )
            )

            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil
                )
            )

            present(alert, animated: true, completion: nil)

        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // запрет добавления группы если такая уже добавлена
        if testGroupData.isMain(groupName: group[indexPath.row].name) {
            return nil
        }

        let actionCustomBtn = UIContextualAction(style: .normal, title: "") { _, _, complete in
            testGroupData.changeAttrIsMainByName(groupName: self.group[indexPath.row].name, direction: true)
            complete(true)
            self.loadData()
        }
        actionCustomBtn.backgroundColor = .blue
        actionCustomBtn.image = UIImage(systemName: "person.fill.checkmark")
        return UISwipeActionsConfiguration(actions: [actionCustomBtn])
    }
}

extension GroupSearchTableViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return loadData()
        }

        group = testGroupData.filter {
            $0.name.lowercased().contains(searchText.lowercased()) && !$0.isMain
        }
    }
}
