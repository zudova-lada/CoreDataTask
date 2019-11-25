//
//  PictureView.swift
//  CoreDataTask
//
//  Created by Лада on 25/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import UIKit

class PictureView: UIViewController {

    var data: OneImage!
    
    var picture = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(data: data.image as Data, scale: 1)
        let delta = max(image!.size.width/view.frame.width, image!.size.height/view.frame.height)
        
        picture.image = image
        picture.frame = CGRect(x: 0, y: 0, width: image!.size.width/delta, height: image!.size.height/delta)
        picture.center = view.center
        view.addSubview(picture)
    }
    

}
