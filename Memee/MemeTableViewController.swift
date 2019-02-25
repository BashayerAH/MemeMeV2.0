//
//  MemeTableViewController.swift
//  Memee
//
//  Created by Bashayer  on 07/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.memeTableLabel?.text = meme.topText + "..." + meme.bottomText
        cell.memeTableImage?.image = meme.memedImage
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        detailController.memeImage = appDelegate.memes[(indexPath as NSIndexPath).row].memedImage
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
    
    
    
    
}
