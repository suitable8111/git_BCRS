//
//  FavorDetailViewController.swift
//  BSPublicReservation
//
//  Created by 김대호 on 2015. 5. 17..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import UIKit
import MapKit
class FavorDetailViewController : UIViewController, MKMapViewDelegate{
    
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
    
    @IBOutlet weak var contextView: UITextView!
    @IBOutlet weak var backGroundImg: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
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
        
        titleLabel.text = _detailModelData.elements.valueForKey("title") as? String
        placeLabel.text = _detailModelData.elements.valueForKey("place") as? String
        phoneLabel.text = _detailModelData.elements.valueForKey("phoneNum") as? String
        homePageLabel.text = _detailModelData.elements.valueForKey("homePage") as? String
        contextView.text = _detailModelData.elements.valueForKey("context") as? String
        timeLabel.text = _detailModelData.elements.valueForKey("time") as? String
        periodLabel.text = _detailModelData.elements.valueForKey("period") as? String
        startLabel.text = startDate
        endLabel.text = endDate
        
        if((view.frame.width)/375 != 1){
            
            if((view.center.y)/333.5 > 1){
                labelsView.center = CGPoint(x: labelsView.center.x, y: labelsView.center.y*(view.center.y)/333.5)
                contextView.frame.size = CGSizeMake(contextView.frame.size.width*(view.frame.width)/375,contextView.frame.height*(view.frame.height)/667)
                scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height*(view.frame.height)/667)
                labelsView.frame.size = CGSizeMake(labelsView.frame.size.width*(view.frame.width)/375,labelsView.frame.height*(view.frame.height)/667)
                
                
            }else {
                contextView.frame.size = CGSizeMake(contextView.frame.size.width*(view.frame.width)/375,contextView.frame.height)
                labelsView.frame.size = CGSizeMake(labelsView.frame.size.width*(view.frame.width)/375,labelsView.frame.height)
                scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height*(view.frame.height)/667*2)
                println(scrollView.frame.height)
            }
           
            mapView.frame.origin = CGPoint(x: view.frame.width+10, y: 15)
            
            titleLabel.frame.size = CGSizeMake(titleLabel.frame.size.width*(view.frame.width)/375,titleLabel.frame.height*(view.frame.height)/667)
            placeLabel.frame.size = CGSizeMake(placeLabel.frame.size.width*(view.frame.width)/375,placeLabel.frame.height*(view.frame.height)/667)
            backGroundImg.frame.size = CGSizeMake(backGroundImg.frame.size.width*(view.frame.width)/375,backGroundImg.frame.height)
            gapLabel.frame.size = CGSizeMake(gapLabel.frame.size.width*(view.frame.width)/375,gapLabel.frame.height*(view.frame.height)/667)
            
            backGroundView.frame.size = CGSizeMake(backGroundView.frame.size.width*(view.frame.width)/375, backGroundView.frame.height)
            
            phoneLabel.frame.size = CGSizeMake(phoneLabel.frame.size.width*(view.frame.width)/375,phoneLabel.frame.height*(view.frame.height)/667)
            homePageLabel.frame.size = CGSizeMake(homePageLabel.frame.size.width*(view.frame.width)/375,homePageLabel.frame.height*(view.frame.height)/667)
            
            timeLabel.frame.size = CGSizeMake(timeLabel.frame.size.width*(view.frame.width)/375,timeLabel.frame.height*(view.frame.height)/667)
            periodLabel.frame.size = CGSizeMake(periodLabel.frame.size.width*(view.frame.width)/375,periodLabel.frame.height*(view.frame.height)/667)
            
            
            
            mapView.frame.size = CGSizeMake(mapView.frame.size.width*(view.frame.width)/375,mapView.frame.height*(view.frame.height)/667)
            
            scrollView.frame.size = CGSizeMake(view.frame.width,view.frame.height)
            
        }
        
        
        
        backGroundView.addSubview(titleLabel)
        backGroundView.addSubview(placeLabel)
        backGroundView.addSubview(startLabel)
        backGroundView.addSubview(endLabel)
        backGroundView.addSubview(gapLabel)
        
        labelsView.addSubview(phoneLabel)
        labelsView.addSubview(homePageLabel)
        labelsView.addSubview(periodLabel)
        labelsView.addSubview(timeLabel)
        
        scrollView.addSubview(contextView)
        scrollView.addSubview(labelsView)
        scrollView.addSubview(mapView)

        
        labelsView.layer.cornerRadius = 5
        contextView.layer.cornerRadius = 5
        mapView.layer.cornerRadius = 5
        
        mapView.layer.masksToBounds = true
        labelsView.layer.masksToBounds = true
        contextView.layer.masksToBounds = true
        
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

}
