//
//  MemeViewController.swift
//  Memee
//
//  Created by Bashayer  on 06/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate {
    
    var memeImage: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func toSentMemes(_ sender: Any) {
        let controller = self.navigationController!.viewControllers[0]
        let _ = self.navigationController?.popToViewController(controller, animated: true)
        
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView!.image = memeImage
        
        navigationController?.isNavigationBarHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    
}
