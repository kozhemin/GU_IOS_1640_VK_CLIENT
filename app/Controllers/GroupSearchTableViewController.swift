//
//  GroupSearchTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import FirebaseDatabase
import UIKit

class GroupSearchTableViewController: UITableViewController {
    @IBOutlet var GroupSearchTableView: UITableView!
    @IBOutlet var searchField: UISearchBar!

    private var group = [Group]() {
        didSet {
            GroupSearchTableView.reloadData()
        }
    }

    private let realmProvider = ProviderDataService()
    private let ref = Database.database().reference(withPath: "VkQueryLog")
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
        realmProvider.networkService.searchGroups(query: defaultQueryString) { [weak self] resp in
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

        let currentGroup = group[indexPath.row]
        var conf = cell.defaultContentConfiguration()

        conf.text = currentGroup.name
        conf.secondaryText = currentGroup.description

        if let photoUrl = currentGroup.photoUrl {
            let data = try? Data(contentsOf: photoUrl)
            if data != nil {
                conf.image = UIImage(data: data!)
            }
        }
        cell.contentConfiguration = conf

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
            self.realmProvider.joinToGroup(group: self.group[indexPath.row])
            complete(true)
        }

        actionCustomBtn.backgroundColor = .blue
        actionCustomBtn.image = UIImage(systemName: "person.fill.checkmark")
        return UISwipeActionsConfiguration(actions: [actionCustomBtn])
    }
}

extension GroupSearchTableViewController: UISearchBarDelegate {
    static var dtQuery = Int(NSDate().timeIntervalSince1970)
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return loadData()
        }

        let q = searchText.lowercased()
        realmProvider.networkService.searchGroups(query: q) { [weak self] resp in
            guard let self = self else { return }
            self.group = resp
        }

        // Firebase search query log
        resetDtQuery()
        let vkUserLog = FirebaseVkQueryLog(userId: AuthData.share.userId, query: q)
        let cityRef = ref.child(String(GroupSearchTableViewController.dtQuery))
        cityRef.setValue(vkUserLog.toAnyObject())
    }

    private func resetDtQuery() {
        let delay = 5
        let currentDt = Int(NSDate().timeIntervalSince1970)
        if GroupSearchTableViewController.dtQuery + delay < currentDt {
            GroupSearchTableViewController.dtQuery = Int(NSDate().timeIntervalSince1970)
        }
    }
}
