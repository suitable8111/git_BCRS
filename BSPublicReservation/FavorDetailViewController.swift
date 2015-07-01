//
//  FavorDetailViewController.swift
//  BSPublicReservation
//
//  Created by 김대호 on 2015. 5. 17..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import UIKit
import MapKit
import Social

class FavorDetailViewController : UIViewController, MKMapViewDelegate, UIScrollViewDelegate{
    
    var _detailModelData : DetailDataModel!
    var startDate : String = ""
    var endDate : String = ""
    var serialID : String = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var gapLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var homePageLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    


    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var homePageBtn: UIButton!
    @IBOutlet weak var faceBookBtn: UIButton!
    @IBOutlet weak var backGroundImg: UIImageView!

    
    @IBOutlet weak var currentView: UIImageView!
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectedControl: UISegmentedControl!
    
    func detailDataModel() -> DetailDataModel {
        if(_detailModelData == nil) {
            _detailModelData = DetailDataModel()
        }
        
        return _detailModelData
    }
    override func viewWillAppear(animated: Bool){
        
        self.detailDataModel()
        _detailModelData.beginParsing("FESTIVAL", dataSid: serialID)
        self.makeMapView()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.hidden = true
        
        self.scrollView.delegate = self
        let frameForHeight : CGFloat = view.frame.size.height/667
        let frameForWidth : CGFloat = view.frame.size.width/375
        let originForX : CGFloat = view.center.x/187.5
        let originForY : CGFloat = view.center.y/333.5
        
        titleLabel.text = _detailModelData.elements.valueForKey("title") as? String
        placeLabel.text = _detailModelData.elements.valueForKey("place") as? String
        phoneLabel.text = _detailModelData.elements.valueForKey("phoneNum") as? String
        homePageLabel.text = _detailModelData.elements.valueForKey("homePage") as? String
        timeLabel.text = _detailModelData.elements.valueForKey("time") as? String
        periodLabel.text = _detailModelData.elements.valueForKey("period") as? String
        startLabel.text = startDate
        endLabel.text = endDate
        if(phoneLabel.text == ""){
            phoneBtn.hidden = true
        }else{
            phoneBtn.hidden = false
        }
        if(homePageLabel.text == ""){
            homePageBtn.hidden = true
        }else{
            homePageBtn.hidden = false
        }
        if(frameForHeight != 1){
            
            if(frameForHeight > 1){
                labelsView.center = CGPoint(x: labelsView.center.x, y: labelsView.center.y*originForY)
                scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height*frameForHeight)
                labelsView.frame.size = CGSizeMake(labelsView.frame.size.width*frameForWidth,labelsView.frame.height*frameForHeight)
            }else {
                labelsView.frame.size = CGSizeMake(labelsView.frame.size.width*frameForWidth,labelsView.frame.height)
                scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height*frameForHeight)
                println(scrollView.frame.height)
            }
           
            
            
            titleLabel.frame.size = CGSizeMake(titleLabel.frame.size.width*frameForWidth,titleLabel.frame.height*frameForHeight)
            placeLabel.frame.size = CGSizeMake(placeLabel.frame.size.width*frameForWidth,placeLabel.frame.height*frameForHeight)
            backGroundImg.frame.size = CGSizeMake(backGroundImg.frame.size.width*frameForWidth,backGroundImg.frame.height)
            gapLabel.frame.size = CGSizeMake(gapLabel.frame.size.width*frameForWidth,gapLabel.frame.height*frameForHeight)
            
            phoneLabel.frame.size = CGSizeMake(phoneLabel.frame.size.width*frameForWidth,phoneLabel.frame.height*frameForHeight)
            homePageLabel.frame.size = CGSizeMake(homePageLabel.frame.size.width*frameForWidth,homePageLabel.frame.height*frameForHeight)
            
            timeLabel.frame.size = CGSizeMake(timeLabel.frame.size.width*frameForWidth,timeLabel.frame.height*frameForHeight)
            periodLabel.frame.size = CGSizeMake(periodLabel.frame.size.width*frameForWidth,periodLabel.frame.height*frameForHeight)
            
            mapView.frame.size = CGSizeMake(mapView.frame.size.width*frameForWidth,mapView.frame.height*frameForHeight)
            
            scrollView.frame.size = CGSizeMake(view.frame.width,view.frame.height)
            
        }else {
            scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height)
        }
        
        labelsView.addSubview(phoneLabel)
        labelsView.addSubview(homePageLabel)
        labelsView.addSubview(periodLabel)
        labelsView.addSubview(timeLabel)
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(placeLabel)
        scrollView.addSubview(startLabel)
        scrollView.addSubview(endLabel)
        scrollView.addSubview(gapLabel)
        
        scrollView.addSubview(labelsView)
        scrollView.addSubview(mapView)

        
        labelsView.layer.cornerRadius = 5
        mapView.layer.cornerRadius = 5
        
        mapView.layer.masksToBounds = true
        labelsView.layer.masksToBounds = true
        
    }
    func makeMapView() {
        
        var location = CLLocationCoordinate2D()
        
        var x = _detailModelData.elements.valueForKey("latitude") as? String
        var y = _detailModelData.elements.valueForKey("longitude") as? String
        
        var xNSString = NSString(string: x!)
        var xToDouble = xNSString.doubleValue
        
        var yNSString = NSString(string: y!)
        var yToDouble = yNSString.doubleValue
        
        location.latitude = xToDouble
        location.longitude = yToDouble
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = _detailModelData.elements.valueForKey("place") as? String
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func actSelect(sender: AnyObject) {
        switch (selectedControl.selectedSegmentIndex){
        case 0 :
            mapView.mapType = MKMapType.Standard
            break
        case 1 :
            mapView.mapType = MKMapType.Satellite
            break
        case 2 :
            mapView.mapType = MKMapType.Hybrid
            break
        default :
            
            break
        }
    }
    
    @IBAction func actPhoneCall(sender: AnyObject) {
        var alert = UIAlertView(title: "전화걸기", message: "전화 거시겠습니까?", delegate: self, cancelButtonTitle: "취소")
        alert.addButtonWithTitle("전화걸기")
        alert.show()
    }
    @IBAction func actFaceBook(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    @IBAction func actPrevios(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        scrollView.userInteractionEnabled = false
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var indexPage = scrollView.contentOffset.x / scrollView.frame.width
        if(indexPage == 0){
            UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
                self.currentView.transform = CGAffineTransformMakeTranslation(0, 0)
                }, completion: nil)
        }else{
            UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
                self.currentView.transform = CGAffineTransformMakeTranslation(187, 0);
                }, completion: nil)
        }
        scrollView.userInteractionEnabled = true
    }

}
