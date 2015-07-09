//
//  IntroViewController.swift
//  BSPublicReservation
//
//  Created by 김대호 on 2015. 5. 24..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var introImageView: UIImageView!
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        introImageView.image = UIImage(named: "Intro.png")
        introImageView.frame.size = CGSizeMake(introImageView.frame.width*(view.frame.width)/375,introImageView.frame.height*(view.frame.height)/667)
    }
}
