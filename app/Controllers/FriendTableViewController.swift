//
//  FriendTableViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

class FriendTableViewController: UITableViewController {
    private var friend = [DefaultTableDataProtocol]()
    @IBOutlet var FriendTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    public func loadData() {
        friend = testFriendData
    }
}

extension FriendTableViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return friend.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "GroupCell")
        }

        configGroupCell(cell: &cell, for: indexPath, item: friend)
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
        guard let galleryImages = testFriendData[indexPath.row].photoGallery
        else { return }

        galleryController.loadData(items: galleryImages)
    }
}
