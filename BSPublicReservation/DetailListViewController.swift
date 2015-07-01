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

class DetailListViewController : UIViewController, UIAlertViewDelegate, UIScrollViewDelegate {

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
    //dDay계산
    let date = NSDate()
    let formatter = NSDateFormatter()
    
    //@IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var btnsView: UIView!
    @IBOutlet weak var labelsView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var homePageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet weak var startText: UILabel!
    @IBOutlet weak var endText: UILabel!
    @IBOutlet weak var gapLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var homePageButton: UIButton!
    @IBOutlet weak var bgImage2: UIImageView!
    @IBOutlet weak var bgImage3: UIImageView!
    @IBOutlet weak var backGroundImg: UIImageView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var clockImg: UIImageView!
    
    @IBOutlet weak var currentView: UIImageView!
    
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
        self.navigationController?.navigationBar.hidden = true
        let path = getFileName("myFavorite.plist")
        let fileManager = NSFileManager.defaultManager()
        
        let frameForHeight : CGFloat = view.frame.size.height/667
        let frameForWidth : CGFloat = view.frame.size.width/375
        let originForX : CGFloat = view.center.x/187.5
        let originForY : CGFloat = view.center.y/333.5

        formatter.dateFormat = "yyyy-MM-dd"
        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("myFavorite", ofType: "plist")
            fileManager.copyItemAtPath(orgPath!, toPath: path, error: nil)
        }
        arrFavorite = NSMutableArray(contentsOfFile: path)
        
        self.detailModelData()
        self._detailModelData.beginParsing(curruntState, dataSid: serialID)
        self.automaticallyAdjustsScrollViewInsets = false
        self.makeMapView()
        
        self.scrollView.delegate = self
        
        if(frameForHeight != 1){
            
            if(frameForHeight > 1){
                contextView.center = CGPoint(x: contextView.center.x, y: contextView.center.y*originForY)
                labelsView.center = CGPoint(x: labelsView.center.x, y: labelsView.center.y*originForY)
                btnsView.center = CGPoint(x: btnsView.center.x, y: btnsView.center.y*originForY)
                contextView.frame.size = CGSizeMake(contextView.frame.size.width*frameForWidth,contextView.frame.height*frameForHeight)
                scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height*frameForHeight)
                labelsView.frame.size = CGSizeMake(labelsView.frame.size.width*frameForWidth,labelsView.frame.height*frameForHeight)
            }else {
                contextView.frame.size = CGSizeMake(contextView.frame.size.width*frameForWidth,contextView.frame.height)
                labelsView.frame.size = CGSizeMake(labelsView.frame.size.width*frameForWidth,labelsView.frame.height)
                scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height)
                favorBtn.center = CGPoint(x: favorBtn.center.x*originForX, y: favorBtn.center.y)
                faceBookBtn.center = CGPoint(x: faceBookBtn.center.x*originForX, y: faceBookBtn.center.y)
                kakoBtn.center = CGPoint(x: kakoBtn.center.x*originForX, y: kakoBtn.center.y)
            }
        
            //mapView.frame.origin = CGPoint(x: view.frame.width+10, y: 217)
            
            //segmentControl.center = CGPoint(x: segmentControl.center.x*originForX, y: segmentControl.center.y*originForY)
        
            titleLabel.frame.size = CGSizeMake(titleLabel.frame.size.width*frameForWidth,titleLabel.frame.height*frameForHeight)
            placeLabel.frame.size = CGSizeMake(placeLabel.frame.size.width*frameForWidth,placeLabel.frame.height*frameForHeight)
            startText.frame.size = CGSizeMake(startText.frame.size.width*frameForWidth,startText.frame.height*frameForHeight)
            endText.frame.size = CGSizeMake(endText.frame.size.width*frameForWidth,endText.frame.height*frameForHeight)
            gapLabel.frame.size = CGSizeMake(gapLabel.frame.size.width*frameForWidth,gapLabel.frame.height*frameForHeight)
            flagImg.frame.size = CGSizeMake(flagImg.frame.size.width*frameForWidth,flagImg.frame.height*frameForHeight)
            clockImg.frame.size = CGSizeMake(clockImg.frame.size.width*frameForWidth,clockImg.frame.height*frameForHeight)
            backGroundImg.frame.size = CGSizeMake(backGroundImg.frame.size.width*frameForWidth,backGroundImg.frame.height)

            phoneLabel.frame.size = CGSizeMake(phoneLabel.frame.size.width*frameForWidth,phoneLabel.frame.height*frameForHeight)
            homePageLabel.frame.size = CGSizeMake(homePageLabel.frame.size.width*frameForWidth,homePageLabel.frame.height*frameForHeight)
        
            timeLabel.frame.size = CGSizeMake(timeLabel.frame.size.width*frameForWidth,timeLabel.frame.height*frameForHeight)
            periodLabel.frame.size = CGSizeMake(periodLabel.frame.size.width*frameForWidth,periodLabel.frame.height*frameForHeight)
        
        
            btnsView.frame.size = CGSizeMake(btnsView.frame.size.width*frameForWidth,btnsView.frame.height)
        
        
            mapView.frame.size = CGSizeMake(mapView.frame.size.width*frameForWidth,mapView.frame.height*frameForHeight)
        
            scrollView.frame.size = CGSizeMake(view.frame.width,scrollView.frame.height*frameForHeight)
        
        }else {
            scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height)
        }
        ///////////////////
        
        titleLabel.text = _detailModelData.elements.valueForKey("title") as? String
        placeLabel.text = _detailModelData.elements.valueForKey("place") as? String
        phoneLabel.text = _detailModelData.elements.valueForKey("phoneNum") as? String
        homePageLabel.text = _detailModelData.elements.valueForKey("homePage") as? String
        contextView.text = _detailModelData.elements.valueForKey("context") as? String
        
        if(phoneLabel.text == ""){
            phoneButton.hidden = true
        }else{
            phoneButton.hidden = false
        }
        if(homePageLabel.text == ""){
            homePageButton.hidden = true
        }else{
            homePageButton.hidden = false
        }
        if (curruntState == "FESTIVAL"){
            timeLabel.text = "홈페이지를 참고해주세요!"
            periodLabel.text = "무료!"
            bgImage2.image = UIImage(named: "Fastival_bg2.png")
            bgImage3.image = UIImage(named: "Fastival_bg3.png")
        }else {
            timeLabel.text = _detailModelData.elements.valueForKey("time") as? String
            periodLabel.text = _detailModelData.elements.valueForKey("period") as? String
            
        }
        
        if (curruntState == "MUSICAL") {
            startText.text = _detailModelData.elements.valueForKey("time") as? String
            gapLabel.text = ""
            bgImage2.image = UIImage(named: "Musical_bg2.png")
            bgImage3.image = UIImage(named: "Musical_bg3.png")
        }else {
            startText.text = startDate
        }
        
        if (curruntState == "MUSICDANCE"){
            bgImage2.image = UIImage(named: "Music_bg2.png")
            bgImage3.image = UIImage(named: "Music_bg3.png")
        }
        if (curruntState == "EXHIBIT"){
            bgImage2.image = UIImage(named: "Art_bg2.png")
            bgImage3.image = UIImage(named: "Art_bg3.png")
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
        var favorDday : String = ""
        _detailModelData.beginParsing("MUSICAL", dataSid: favorDataSid)
        //뮤지컬은 장소를 DetailDataModel에서 받아야한다
        if curruntState == "MUSICAL" {
            favorStartDate = _detailModelData.elements.valueForKey("time") as! String
        }else {
            favorStartDate = startDate
        }
        
        let currentDate = formatter.stringFromDate(date)
        let favorDate = replaceSpeciaChar(favorStartDate)

        let date1 = formatter.dateFromString(currentDate)
        let date2 = formatter.dateFromString(favorDate)
        
        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let c1 = cal!.components(NSCalendarUnit.DayCalendarUnit, fromDate: date1!, toDate: date2!, options: NSCalendarOptions(0))
        
        favorDday = String(c1.day)
        
        favorPlace = _detailModelData.elements.valueForKey("place") as! String
        let dicInfo:Dictionary<String, String> = ["title":favorTitle,"startDate": favorStartDate,"endDate": favorEndDate,"place":favorPlace,"serialID": favorDataSid, "dDay" : favorDday]
        
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
    @IBAction func actPrevious(sender: AnyObject) {
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
    func replaceSpeciaChar(str:String) -> String {
        var str_change = NSMutableString(string: str)
        str_change.replaceOccurrencesOfString(".", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        
        return str_change as String
    }

}