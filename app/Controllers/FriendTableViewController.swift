//
//  FriendTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

struct Section {
    let letter: String
    let data: [Friend]
}

class FriendTableViewController: UITableViewController {
    @IBOutlet var FriendTableView: UITableView!
    private var friend = [Friend]() {
        didSet {
            friend.sort { $0.name < $1.name }
        }
    }

    private var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        let groupedDictionary = Dictionary(grouping: friend, by: { String($0.name.prefix(1)) })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map { Section(letter: $0, data: groupedDictionary[$0]!) }

        FriendTableView.reloadData()
    }

    public func loadData() {
        friend = testFriendData
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

        cell.labelName?.text = sectionData.name
        cell.labelDescription?.text = sectionData.description

        // add shadow to image container
        cell.contentImage.addShadow()

        // clip image
        cell.avatarImage.clip(borderColor: UIColor.orange.cgColor)
        cell.avatarImage.image = sectionData.image
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
        let section = sections[indexPath.section]
        let sectionData = section.data[indexPath.row]

        guard let galleryImages = sectionData.photoGallery
        else { return }

        galleryController.loadData(items: galleryImages)
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
