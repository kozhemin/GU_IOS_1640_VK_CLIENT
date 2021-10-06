//
//  FriendTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import Nuke
import UIKit

struct Section {
    let letter: String
    let data: [Friend]
}

class FriendTableViewController: UITableViewController {
    @IBOutlet var FriendTableView: UITableView!

    private let networkService = NetworkService()
    private var friend = [Friend]()
    private var sections = [Section]() {
        didSet {
            FriendTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    public func loadData() {
        networkService.getFriends { [weak self] resp in
            guard let self = self else { return }
            self.friend = resp

            let groupedDictionary = Dictionary(grouping: self.friend, by: { String($0.lastName.prefix(1)) })
            let keys = groupedDictionary.keys.sorted()
            self.sections = keys.map { Section(letter: $0, data: groupedDictionary[$0]!) }
        }
    }

    private func getRowData(indexPath: IndexPath) -> Friend {
        let section = sections[indexPath.section]
        return section.data[indexPath.row]
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

        networkService.getPhotos(ownerId: Int(rowData.id)) { [weak self] resp in
            guard let self = self else { return }
            galleryController.loadData(items: resp)
        }
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
}

extension FriendTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRequireFailureOf _: UIGestureRecognizer) -> Bool {
        return true
    }
}
