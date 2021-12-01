//
//  FriendTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import Nuke
import RealmSwift
import UIKit

struct Section {
    let letter: String
    let data: [RealmFriend]
}

class FriendTableViewController: UITableViewController {
    @IBOutlet var FriendTableView: UITableView!

    private var friendToken: NotificationToken?
    private let realmProvider = ProviderDataService()
    private var friend: Results<RealmFriend>?

    private var sections = [Section]() {
        didSet {
            FriendTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        friend = try? RealmService
            .load(typeOf: RealmFriend.self)
    }

    override func viewDidAppear(_: Bool) {
        loadData()
    }

    public func loadData() {
        realmProvider.loadFriends()
        friendToken = friend?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.loadSection()
            case .update:
                self?.loadSection()
            case let .error(error):
                print(error)
            }
        }
    }

    private func getRowData(indexPath: IndexPath) -> RealmFriend {
        let section = sections[indexPath.section]
        return section.data[indexPath.row]
    }

    private func loadSection() {
        guard let friend = friend else { return }
        let groupedDictionary = Dictionary(grouping: friend, by: { String($0.lastName.prefix(1)) })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map { Section(letter: $0, data: groupedDictionary[$0]!) }
    }
}

extension FriendTableViewController {
    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FriendTableViewCell
        if let resCell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell {
            cell = resCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        }

        let section = sections[indexPath.section]
        let sectionData = section.data[indexPath.row]

        cell.labelName?.text = "\(sectionData.lastName) \(sectionData.firstName)"
        cell.labelDescription?.text = sectionData.nickName

        // add shadow to image container
        cell.contentImage.addShadow()

        // clip image
        cell.avatarImage.clip(borderColor: UIColor.orange.cgColor)

        if let url = sectionData.photoUrl {
            Nuke.loadImage(
                with: url,
                into: cell.avatarImage
            )
        }
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: "showGallery",
            sender: indexPath
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let galleryController = segue.destination as? GalleryCollectionViewController
        else { return }
        let indexPath = sender as! IndexPath
        let rowData = getRowData(indexPath: indexPath)
        galleryController.ownerId = rowData.userId
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    override func sectionIndexTitles(for _: UITableView) -> [String]? {
        return sections.map { $0.letter }
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }

    override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 25))

        label.text = sections[section].letter
        label.backgroundColor = .white
        label.isOpaque = true
        label.textColor = .black
        returnedView.addSubview(label)

        return returnedView
    }
}

extension FriendTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRequireFailureOf _: UIGestureRecognizer) -> Bool {
        return true
    }
}
