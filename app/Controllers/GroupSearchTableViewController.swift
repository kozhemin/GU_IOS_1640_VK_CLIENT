//
//  GroupSearchTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

class GroupSearchTableViewController: UITableViewController {
    @IBOutlet var GroupSearchTableView: UITableView!
    @IBOutlet var searchField: UISearchBar!

    private var group = [Group]() {
        didSet {
            GroupSearchTableView.reloadData()
        }
    }

    private let networkService = NetworkService()

    override func viewDidLoad() {
        searchField.delegate = self
    }

    override func viewWillAppear(_: Bool) {
        loadData()
    }

    func getGroup() -> [Group] {
        return group
    }

    func loadData() {
        let defaultQueryString = "apple swift"
        networkService.searchGroups(query: defaultQueryString) { [weak self] resp in
            guard let self = self else { return }
            self.group = resp
        }
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
    override func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
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
    }

    override func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionCustomBtn = UIContextualAction(style: .normal, title: "") { _, _, complete in

            self.networkService.joinToGroup(
                groupId: Int(self.group[indexPath.row].id)
            ) { codeResp in
                if codeResp == 1 {
                    complete(true)
                }
            }
            // self.loadData()
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

        networkService.searchGroups(query: searchText.lowercased()) { [weak self] resp in
            guard let self = self else { return }
            self.group = resp
        }
    }
}
