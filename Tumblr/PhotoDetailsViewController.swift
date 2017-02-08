//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Palak Jadav on 2/7/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoDetailImageView: UIImageView!
    
    var image: UIImage!
    var post: [NSDictionary]?
    var photos: [NSDictionary]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let imageUrlString = photos?[0].value(forKeyPath: ("original_size.url" as? String)!)
        if let imageUrl = URL(string: imageUrlString as! String) {
            photoDetailImageView.setImageWith(imageUrl as! URL)
        }
        else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
