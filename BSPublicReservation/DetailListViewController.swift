//
//  DetailListViewController.swift
//  BSPublicReservation
//
//  Created by IT on 2015. 4. 29..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import UIKit
import MapKit
import Social

class DetailListViewController : UIViewController, UIAlertViewDelegate {

    var _detailModelData:DetailDataModel!
    var titleName : String = ""
    var startDate : String = ""
    var endDate : String = ""
    var serialID : String = ""
    var placeName : String = ""
    var curruntState : String = ""
    var viewIndexNum : Int = 0
    //즐겨찾기 배열
    var arrFavorite:NSMutableArray!
    var path:String = ""
    //맵 찾기
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var btnsView: UIView!
    @IBOutlet weak var labelsView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var phoneLabel: UIButton!
    @IBOutlet var homePageLabel: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet weak var startText: UILabel!
    @IBOutlet weak var endText: UILabel!
    @IBOutlet weak var gapLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var backGroundImg: UIImageView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var clockImg: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet var contextView: UITextView!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var favorBtn: UIButton!
    @IBOutlet weak var kakoBtn: UIButton!
    @IBOutlet weak var faceBookBtn: UIButton!
    func detailModelData() -> DetailDataModel {
        if(_detailModelData == nil){
            _detailModelData = DetailDataModel()
        }
        
        return _detailModelData
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        let path = getFileName("myFavorite.plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("myFavorite", ofType: "plist")
            fileManager.copyItemAtPath(orgPath!, toPath: path, error: nil)
        }
        arrFavorite = NSMutableArray(contentsOfFile: path)
        
        self.detailModelData()
        self._detailModelData.beginParsing(curruntState, dataSid: serialID)
        
        self.makeMapView()
        
        if((view.frame.width)/337 != 1){
            
            if((view.center.y)/333.5 > 1){
                contextView.center = CGPoint(x: contextView.center.x, y: contextView.center.y*(view.center.y)/333.5)
                labelsView.center = CGPoint(x: labelsView.center.x, y: labelsView.center.y*(view.center.y)/333.5)
                btnsView.center = CGPoint(x: btnsView.center.x, y: btnsView.center.y*(view.center.y)/333.5)
                contextView.frame.size = CGSizeMake(contextView.frame.size.width*(view.frame.width)/375,contextView.frame.height*(view.frame.height)/667)
                scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height*(view.frame.height)/667)
                labelsView.frame.size = CGSizeMake(labelsView.frame.size.width*(view.frame.width)/375,labelsView.frame.height*(view.frame.height)/667)
            }else {
                contextView.frame.size = CGSizeMake(contextView.frame.size.width*(view.frame.width)/375,contextView.frame.height)
                labelsView.frame.size = CGSizeMake(labelsView.frame.size.width*(view.frame.width)/375,labelsView.frame.height)
                scrollView.contentSize =  CGSizeMake(view.frame.width*2, 720)
                favorBtn.center = CGPoint(x: favorBtn.center.x*(view.center.x)/187.5, y: favorBtn.center.y)
                faceBookBtn.center = CGPoint(x: faceBookBtn.center.x*(view.center.x)/187.5, y: faceBookBtn.center.y)
                kakoBtn.center = CGPoint(x: kakoBtn.center.x*(view.center.x)/187.5, y: kakoBtn.center.y)
            }
        
            mapView.frame.origin = CGPoint(x: view.frame.width+10, y: 15)
            
            segmentControl.center = CGPoint(x: segmentControl.center.x*(view.center.x)/187.5, y: segmentControl.center.y*(view.center.y)/333.5)
        
            titleLabel.frame.size = CGSizeMake(titleLabel.frame.size.width*(view.frame.width)/375,titleLabel.frame.height*(view.frame.height)/667)
            placeLabel.frame.size = CGSizeMake(placeLabel.frame.size.width*(view.frame.width)/375,placeLabel.frame.height*(view.frame.height)/667)
            startText.frame.size = CGSizeMake(startText.frame.size.width*(view.frame.width)/375,startText.frame.height*(view.frame.height)/667)
            endText.frame.size = CGSizeMake(endText.frame.size.width*(view.frame.width)/375,endText.frame.height*(view.frame.height)/667)
            gapLabel.frame.size = CGSizeMake(gapLabel.frame.size.width*(view.frame.width)/375,gapLabel.frame.height*(view.frame.height)/667)
            flagImg.frame.size = CGSizeMake(flagImg.frame.size.width*(view.frame.width)/375,flagImg.frame.height*(view.frame.height)/667)
            clockImg.frame.size = CGSizeMake(clockImg.frame.size.width*(view.frame.width)/375,clockImg.frame.height*(view.frame.height)/667)
            backGroundImg.frame.size = CGSizeMake(backGroundImg.frame.size.width*(view.frame.width)/375,backGroundImg.frame.height)
            backGroundView.frame.size = CGSizeMake(backGroundView.frame.size.width*(view.frame.width)/375, backGroundView.frame.height)
            
            phoneLabel.frame.size = CGSizeMake(phoneLabel.frame.size.width*(view.frame.width)/375,phoneLabel.frame.height*(view.frame.height)/667)
            homePageLabel.frame.size = CGSizeMake(homePageLabel.frame.size.width*(view.frame.width)/375,homePageLabel.frame.height*(view.frame.height)/667)
        
            timeLabel.frame.size = CGSizeMake(timeLabel.frame.size.width*(view.frame.width)/375,timeLabel.frame.height*(view.frame.height)/667)
            periodLabel.frame.size = CGSizeMake(periodLabel.frame.size.width*(view.frame.width)/375,periodLabel.frame.height*(view.frame.height)/667)
        
        
            btnsView.frame.size = CGSizeMake(btnsView.frame.size.width*(view.frame.width)/375,btnsView.frame.height)
        
        
            mapView.frame.size = CGSizeMake(mapView.frame.size.width*(view.frame.width)/375,mapView.frame.height*(view.frame.height)/667)
        
            scrollView.frame.size = CGSizeMake(view.frame.width,scrollView.frame.height*(view.frame.height)/667)
        
        }
        ///////////////////
        
        titleLabel.text = _detailModelData.elements.valueForKey("title") as? String
        placeLabel.text = _detailModelData.elements.valueForKey("place") as? String
        phoneLabel.setTitle(_detailModelData.elements.valueForKey("phoneNum") as? String, forState: UIControlState.Normal)
        homePageLabel.setTitle(_detailModelData.elements.valueForKey("homePage") as? String, forState: UIControlState.Normal)
        contextView.text = _detailModelData.elements.valueForKey("context") as? String
        if (curruntState == "FESTIVAL"){
            timeLabel.text = "홈페이지를 참고해주세요!"
            periodLabel.text = "무료!"
        }else {
            timeLabel.text = _detailModelData.elements.valueForKey("time") as? String
            periodLabel.text = _detailModelData.elements.valueForKey("period") as? String
        }
        if (curruntState == "MUSICAL") {
            startText.text = _detailModelData.elements.valueForKey("time") as? String
            gapLabel.text = ""
        }else {
            startText.text = startDate
        }
        endText.text = endDate
        
        contextView.layer.cornerRadius = 5
        labelsView.layer.cornerRadius = 5
        btnsView.layer.cornerRadius = 5
        mapView.layer.cornerRadius = 5
        
        contextView.layer.masksToBounds = true
        labelsView.layer.masksToBounds = true
        btnsView.layer.masksToBounds = true
        mapView.layer.masksToBounds = true
        
        labelsView.addSubview(timeLabel)
        labelsView.addSubview(periodLabel)
        labelsView.addSubview(homePageLabel)
        labelsView.addSubview(phoneLabel)
        
        scrollView.addSubview(btnsView)
        scrollView.addSubview(labelsView)
        scrollView.addSubview(contextView)
        scrollView.addSubview(mapView)
        
    }
    func makeMapView() {
        var x = _detailModelData.elements.valueForKey("latitude") as? String
        var y = _detailModelData.elements.valueForKey("longitude") as? String
        if(x != ""){
            
                var location = CLLocationCoordinate2D()
    
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
            println("좌표로 찾기")
        }else{
            matchingItems.removeAll()
            let request = MKLocalSearchRequest()
            var placeString : String = _detailModelData.elements.valueForKey("place") as! String
            var resultString : String = "부산 " + placeString
            request.naturalLanguageQuery = resultString
            request.region = mapView.region
        
            let search = MKLocalSearch(request: request)
        
            search.startWithCompletionHandler({(response:
                MKLocalSearchResponse!,
                error: NSError!) in
            
                if error != nil {
                    println("Error occured in search: \(error.localizedDescription)")
                } else if response.mapItems.count == 0 {
                    println("No matches found")
                } else {
                    println("Matches found")
                
                    for item in response.mapItems as! [MKMapItem] {
                        println("Name = \(item.name)")
                        println("Phone = \(item.phoneNumber)")
                    
                        self.matchingItems.append(item as MKMapItem)
                        println("Matching items = \(self.matchingItems.count)")
                    
                        let span = MKCoordinateSpanMake(0.01, 0.01)
                        let myRegion = MKCoordinateRegion(center: item.placemark.coordinate, span: span)
                        self.mapView.setRegion(myRegion, animated: true)
                    
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
            })
        }

    }
    @IBAction func actMapType(sender: UISegmentedControl) {
        switch (segmentControl.selectedSegmentIndex){
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
    
    //즐겨찾기
    @IBAction func addFavor(sender: AnyObject) {
        path = getFileName("myFavorite.plist")
        let favorTitle : String = titleName
        var favorPlace : String = ""
        let favorEndDate : String = endDate
        var favorStartDate : String = ""
        let favorDataSid : String = serialID
        _detailModelData.beginParsing("MUSICAL", dataSid: favorDataSid)
        //뮤지컬은 장소를 DetailDataModel에서 받아야한다
        if curruntState == "MUSICAL" {
            favorStartDate = _detailModelData.elements.valueForKey("time") as! String
        }else {
            favorStartDate = startDate
        }
        favorPlace = _detailModelData.elements.valueForKey("place") as! String
        let dicInfo:Dictionary<String, String> = ["title":favorTitle,"startDate": favorStartDate,"endDate": favorEndDate,"place":favorPlace,"serialID": favorDataSid]
        
        arrFavorite.addObject(dicInfo)
        arrFavorite.writeToFile(path, atomically: true)
        
        var alert = UIAlertView(title: "즐겨찾기", message: "즐겨찾기에 추가 되었습니다!", delegate: self, cancelButtonTitle: "확인")
        alert.show()
    }
    func getFileName(fileName:String) -> String {
        let docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0] as! String
        let fullName = docPath.stringByAppendingPathComponent(fileName)
        return fullName
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "GoWeb"){
            var WebPageVC = segue.destinationViewController as! WebPageController
            WebPageVC.url = _detailModelData.elements.valueForKey("homePage") as? String
        }
    }
    //전화걸기
    @IBAction func PhoneCall() {
        var alert = UIAlertView(title: "전화걸기", message: "전화 거시겠습니까?", delegate: self, cancelButtonTitle: "취소")
        alert.addButtonWithTitle("전화걸기")
        alert.show()
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let indexNum = buttonIndex
        if(indexNum == 0){
            let urlStirng = "tel://" + (_detailModelData.elements.valueForKey("phoneNum") as? String)!
            let url:NSURL = NSURL(string: urlStirng)!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    @IBAction  func faceBookBtnClick() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}