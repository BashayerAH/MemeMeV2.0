//
//  MemeCollectionViewController.swift
//  Memee
//
//  Created/Users/bashayer/Desktop/MemeMe V1 2/Memee/MemeCollectionViewCell.swift by Bashayer  on 06/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let wDimension = (view.frame.size.width - (2 * space)) / 3.0
        let hDimension = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: wDimension, height: hDimension)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView?.reloadData()
        
    }
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        detailController.memeImage = appDelegate.memes[(indexPath as NSIndexPath).row].memedImage
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 75, height: 75)
        
    }
    
}
