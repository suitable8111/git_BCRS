//
//  WebPageController.swift
//  BSPublicReservation
//
//  Created by 김대호 on 2015. 5. 21..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import UIKit

class WebPageController : UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var naviBarImg: UIView!
    @IBOutlet weak var webView: UIWebView!
    var url : String = ""
    override func viewWillAppear(animated: Bool) {
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    @IBAction func actPrevious(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
