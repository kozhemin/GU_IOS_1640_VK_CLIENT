//
//  GroupTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

class GroupTableViewController: UITableViewController {
    private var group = [DefaultTableDataProtocol]() {
        didSet {
            setHeaderLabel()
            tableView.reloadData()
        }
    }

    @IBOutlet var GroupTableView: UITableView!
    @IBOutlet var tableViewHeader: GroupTableHeader!

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addGroupSegue",
              let vc = segue.source as? GroupSearchTableViewController,
              let index = vc.tableView.indexPathForSelectedRow?.row
        else { return }

        testGroupData.changeAttrIsMainByName(groupName: vc.getGroup()[index].name, direction: true)
        loadData()
    }

    override func viewDidLoad() {
        // header image
        tableViewHeader.imageView.image = UIImage(named: "groupHeader")
        tableViewHeader.imageView.contentMode = .scaleAspectFill
    }

    override func viewWillAppear(_: Bool) {
        loadData()
    }

    public func loadData() {
        group = testGroupData.filter { $0.isMain == true }
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
                        testGroupData.changeAttrIsMainByName(groupName: self.group[indexPath.row].name, direction: false)
                        self.loadData()
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
