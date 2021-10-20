//
//  GroupTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import RealmSwift
import UIKit

class GroupTableViewController: UITableViewController {
    @IBOutlet var GroupTableView: UITableView!
    @IBOutlet var tableViewHeader: GroupTableHeader!

    private var group: Results<RealmGroup>?
    private var groupToken: NotificationToken?
    private let realmProvider = ProviderDataService()

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addGroupSegue",
              let vc = segue.source as? GroupSearchTableViewController,
              let index = vc.tableView.indexPathForSelectedRow?.row
        else { return }

        let newGroup = vc.getGroup()[index]
        realmProvider.joinToGroup(group: newGroup)
    }

    override func viewDidLoad() {
        // header image
        tableViewHeader.imageView.image = UIImage(named: "groupHeader")
        tableViewHeader.imageView.contentMode = .scaleAspectFill

        group = try? RealmService
            .load(typeOf: RealmGroup.self)
    }

    override func viewDidAppear(_: Bool) {
        loadData()
    }

    public func loadData(forceReload _: Bool = false) {
        realmProvider.loadGroups()
        groupToken = group?.observe { [weak self] changes in
            switch changes {
            case .initial:
                print("loadData - initial")
            case .update:
                self?.reloadView()
            case let .error(error):
                print(error)
            }
        }
    }

    private func setHeaderLabel() {
        tableViewHeader.labelCountGroup.text = "Всего групп: \(group?.count ?? 0)"
    }

    private func reloadView() {
        tableView.reloadData()
        setHeaderLabel()
    }
}

extension GroupTableViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return group?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "GroupCell")
        }

        guard let currentGroup = group?[indexPath.row] else { return UITableViewCell() }
        configGroupCell(cell: &cell, group: currentGroup)

        return cell
    }
}

extension GroupTableViewController {
    override func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "") { _, _, complete in

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
                        guard let currentGroup = self.group?[indexPath.row] else { return }
                        self.realmProvider.leaveGroup(group: currentGroup)
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
