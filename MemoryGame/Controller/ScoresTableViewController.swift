//
//  ScoresTableViewController.swift
//  MemoryGame
//
//  Created by Vishwas Mukund on 17/04/16.
//  
//

import UIKit

class ScoresTableViewController: UITableViewController {

  

    var scores: Array<Dictionary<String,String>> = []

  

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
   

    override func numberOfSections(in tableView: UITableView) -> Int {
        return scores.count == 0 ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)

       
        let score = scores[indexPath.row]
        let name = score["name"]!
        let time = Double(score["score"]!)
        
        cell.textLabel?.text = String(format: "%d. %@", indexPath.row+1, name)
        cell.detailTextLabel?.text = String(format: "%.0fs", time!)
        cell.detailTextLabel?.isHidden = true

        return cell
    }


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.detailTextLabel?.isHidden = false
    }


}
