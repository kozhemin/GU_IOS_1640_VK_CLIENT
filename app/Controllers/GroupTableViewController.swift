//
//  GroupTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

class GroupTableViewController: UITableViewController {
    @IBOutlet var GroupTableView: UITableView!
    @IBOutlet var tableViewHeader: GroupTableHeader!

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addGroupSegue",
              let vc = segue.source as? GroupSearchTableViewController,
              let index = vc.tableView.indexPathForSelectedRow?.row
        else { return }

        networkService.joinToGroup(
            groupId: Int(vc.getGroup()[index].id)
        ) { [weak self] codeResp in
            if codeResp == 1 {
                guard let self = self else { return }
                self.loadData()
            }
        }
    }

    private var group = [Group]() {
        didSet {
            setHeaderLabel()
            tableView.reloadData()
        }
    }

    private let networkService = NetworkService()

    override func viewDidLoad() {
        // header image
        tableViewHeader.imageView.image = UIImage(named: "groupHeader")
        tableViewHeader.imageView.contentMode = .scaleAspectFill
    }

    override func viewWillAppear(_: Bool) {
        loadData()
    }

    public func loadData() {
        networkService.getGroups(userId: AuthData.share.userId) { [weak self] resp in
            guard let self = self else { return }
            self.group = resp
        }
    }

    private func setHeaderLabel() {
        tableViewHeader.labelCountGroup.text = "Всего групп: \(group.count)"
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
    override func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt _: IndexPath) -> UISwipeActionsConfiguration? {
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
                        // Тут пока заглушка
//                        self.loadData()
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
