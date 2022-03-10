//
//  ImageGalleryTableViewController.swift
//  Assignment5
//
//  Created by Cezar Nicolae Gradinariu on 08.03.2022.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {


    var currentGalleries = ["One", "Two", "Three"]
    var deletedGalleries = [String]()
    var Galleries: [[String]]{
        return [currentGalleries,deletedGalleries]
    }
    // MARK: - Table view data source methods

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Galleries[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        cell.textLabel?.text = Galleries[indexPath.section][indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        }
        return "Galleries"
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1{
            let contextItem = UIContextualAction(style: .normal, title: "undelete"){
                (contextualAction,view,boolValue) in
                let undeleteItem = self.deletedGalleries.remove(at: indexPath.row)
                self.currentGalleries.append(undeleteItem)
                boolValue(true)
                self.tableView.reloadData()
            }
            return UISwipeActionsConfiguration(actions: [contextItem])
        }
        else{
            return nil
        }
    }

//    @IBAction func newEmojiArt(_ sender: UIBarButtonItem) {
//        emojiArtDocuments += ["Untitled".madeUnique(withRespectTo: emojiArtDocuments)]
//        tableView.reloadData()
//    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != UISplitViewController.DisplayMode.oneOverSecondary {
            splitViewController?.preferredDisplayMode = UISplitViewController.DisplayMode.oneOverSecondary
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from your data source
            let remove = currentGalleries.remove(at: indexPath.row)  // in final project, we will mess this up :))
            tableView.deleteRows(at: [indexPath], with: .fade)
            deletedGalleries.append(remove)
        }
        tableView.reloadData()
    }


}
