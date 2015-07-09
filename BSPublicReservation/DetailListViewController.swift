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
    var moveSeletImageX : CGFloat = 187.5

    //즐겨찾기 배열
    var arrFavorite:NSMutableArray!
    var path:String = ""
    //맵 찾기
    var matchingItems: [MKMapItem] = [MKMapItem]()
    //dDay계산

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var homePageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet weak var startText: UILabel!
    @IBOutlet weak var endText: UILabel!
    @IBOutlet weak var gapLabel: UILabel!
    
    @IBOutlet weak var showPhoneBtnLabel: UILabel!
    @IBOutlet weak var showHomePageBtnLabel: UILabel!
    @IBOutlet weak var showFavorBtnLabel: UILabel!
    @IBOutlet weak var showperiodLabel: UILabel!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var showPhoneLabel: UILabel!
    @IBOutlet weak var showHomePageLabel: UILabel!
    @IBOutlet weak var goMapBtn: UIButton!
    @IBOutlet weak var goExplainBtn: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var homePageButton: UIButton!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var favorBtn: UIButton!
    @IBOutlet weak var twBtn: UIButton!
    @IBOutlet weak var faceBookBtn: UIButton!
    
    @IBOutlet weak var bgImage2: UIImageView!
    @IBOutlet weak var bgImage3: UIImageView!
    @IBOutlet weak var labelsBackGround: UIImageView!
    @IBOutlet weak var cellBackGround: UIImageView!
    @IBOutlet weak var btnsBackGround: UIImageView!
    @IBOutlet weak var favorBackGround: UIImageView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var clockImg: UIImageView!
    @IBOutlet weak var currentView: UIImageView!
    
    @IBOutlet weak var naviBarView: UIView!


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    
    func detailModelData() -> DetailDataModel {
        if(_detailModelData == nil){
            _detailModelData = DetailDataModel()
        }
        
        return _detailModelData
    }
    
    override func viewWillAppear(animated: Bool) {

        let path = getFileName("myFavorite.plist")
        let fileManager = NSFileManager.defaultManager()
        
        let frameForHeight : CGFloat = view.frame.size.height/667
        let frameForWidth : CGFloat = view.frame.size.width/375
        

        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("myFavorite", ofType: "plist")
            fileManager.copyItemAtPath(orgPath!, toPath: path, error: nil)
        }
        arrFavorite = NSMutableArray(contentsOfFile: path)
        
        self.detailModelData()
        self._detailModelData.beginParsing(curruntState, dataSid: serialID)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.hidden = true
        self.makeMapView()
        
        self.scrollView.delegate = self
        
        ///////////////contentSize//////////
        if(frameForHeight != 1){
            
        moveSeletImageX = moveSeletImageX * frameForWidth
        titleLabel.frame.origin = CGPoint(x: titleLabel.frame.origin.x * frameForWidth, y: titleLabel.frame.origin.y * frameForHeight)
        placeLabel.frame.origin = CGPoint(x: placeLabel.frame.origin.x * frameForWidth, y: placeLabel.frame.origin.y * frameForHeight)
        phoneLabel.frame.origin = CGPoint(x: phoneLabel.frame.origin.x * frameForWidth, y: phoneLabel.frame.origin.y * frameForHeight)
        homePageLabel.frame.origin = CGPoint(x: homePageLabel.frame.origin.x * frameForWidth, y: homePageLabel.frame.origin.y * frameForHeight)
        timeLabel.frame.origin = CGPoint(x: timeLabel.frame.origin.x * frameForWidth, y: timeLabel.frame.origin.y * frameForHeight)
        periodLabel.frame.origin = CGPoint(x: periodLabel.frame.origin.x * frameForWidth, y: periodLabel.frame.origin.y * frameForHeight)
        startText.frame.origin = CGPoint(x: startText.frame.origin.x * frameForWidth, y: startText.frame.origin.y * frameForHeight)
        endText.frame.origin = CGPoint(x: endText.frame.origin.x * frameForWidth, y: endText.frame.origin.y * frameForHeight)
        gapLabel.frame.origin = CGPoint(x: gapLabel.frame.origin.x * frameForWidth, y: gapLabel.frame.origin.y * frameForHeight)
        goMapBtn.frame.origin = CGPoint(x: goMapBtn.frame.origin.x * frameForWidth, y: goMapBtn.frame.origin.y * frameForHeight)
        goExplainBtn.frame.origin = CGPoint(x: goExplainBtn.frame.origin.x * frameForWidth, y: goExplainBtn.frame.origin.y * frameForHeight)
        phoneButton.frame.origin = CGPoint(x: phoneButton.frame.origin.x * frameForWidth, y: phoneButton.frame.origin.y * frameForHeight)
        homePageButton.frame.origin = CGPoint(x: homePageButton.frame.origin.x * frameForWidth, y: homePageButton.frame.origin.y * frameForHeight)
        preBtn.frame.origin = CGPoint(x: preBtn.frame.origin.x * frameForWidth, y: preBtn.frame.origin.y * frameForHeight)
        favorBtn.frame.origin = CGPoint(x: favorBtn.frame.origin.x * frameForWidth, y: favorBtn.frame.origin.y * frameForHeight)
        twBtn.frame.origin = CGPoint(x: twBtn.frame.origin.x * frameForWidth, y: twBtn.frame.origin.y * frameForHeight)
        faceBookBtn.frame.origin = CGPoint(x: faceBookBtn.frame.origin.x * frameForWidth, y: faceBookBtn.frame.origin.y * frameForHeight)
        bgImage2.frame.origin = CGPoint(x: bgImage2.frame.origin.x * frameForWidth, y: bgImage2.frame.origin.y * frameForHeight)
        bgImage3.frame.origin = CGPoint(x: bgImage3.frame.origin.x * frameForWidth, y: bgImage3.frame.origin.y * frameForHeight)
        labelsBackGround.frame.origin = CGPoint(x: labelsBackGround.frame.origin.x * frameForWidth, y: labelsBackGround.frame.origin.y * frameForHeight)
        btnsBackGround.frame.origin = CGPoint(x: btnsBackGround.frame.origin.x * frameForWidth, y: btnsBackGround.frame.origin.y * frameForHeight)
        cellBackGround.frame.origin = CGPoint(x: cellBackGround.frame.origin.x * frameForWidth, y: cellBackGround.frame.origin.y * frameForHeight)
        flagImg.frame.origin = CGPoint(x: flagImg.frame.origin.x * frameForWidth, y: flagImg.frame.origin.y * frameForHeight)
        clockImg.frame.origin = CGPoint(x: clockImg.frame.origin.x * frameForWidth, y: clockImg.frame.origin.y * frameForHeight)
        currentView.frame.origin = CGPoint(x: currentView.frame.origin.x * frameForWidth, y: currentView.frame.origin.y * frameForHeight)
        naviBarView.frame.origin = CGPoint(x: naviBarView.frame.origin.x * frameForWidth, y: naviBarView.frame.origin.y * frameForHeight)
        mapView.frame.origin = CGPoint(x: mapView.frame.origin.x * frameForWidth, y: mapView.frame.origin.y * frameForHeight)
        segmentControl.frame.origin = CGPoint(x: segmentControl.frame.origin.x * frameForWidth, y: segmentControl.frame.origin.y * frameForHeight)
        showHomePageLabel.frame.origin = CGPoint(x: showHomePageLabel.frame.origin.x * frameForWidth, y: showHomePageLabel.frame.origin.y * frameForHeight)
        showperiodLabel.frame.origin = CGPoint(x: showperiodLabel.frame.origin.x * frameForWidth, y: showperiodLabel.frame.origin.y * frameForHeight)
        showPhoneLabel.frame.origin = CGPoint(x: showPhoneLabel.frame.origin.x * frameForWidth, y: showPhoneLabel.frame.origin.y * frameForHeight)
        showTimeLabel.frame.origin = CGPoint(x: showTimeLabel.frame.origin.x * frameForWidth, y: showTimeLabel.frame.origin.y * frameForHeight)
        showFavorBtnLabel.frame.origin = CGPoint(x: showFavorBtnLabel.frame.origin.x * frameForWidth, y: showFavorBtnLabel.frame.origin.y * frameForHeight)
        showHomePageBtnLabel.frame.origin = CGPoint(x: showHomePageBtnLabel.frame.origin.x * frameForWidth, y: showHomePageBtnLabel.frame.origin.y * frameForHeight)
        showPhoneBtnLabel.frame.origin = CGPoint(x: showPhoneBtnLabel.frame.origin.x * frameForWidth, y: showPhoneBtnLabel.frame.origin.y * frameForHeight)
        favorBackGround.frame.origin = CGPoint(x: favorBackGround.frame.origin.x * frameForWidth, y: favorBackGround.frame.origin.y * frameForHeight)
        
        titleLabel.frame.size = CGSizeMake(titleLabel.frame.width * frameForWidth,  titleLabel.frame.height * frameForHeight)
        placeLabel.frame.size = CGSizeMake( placeLabel.frame.width * frameForWidth,  placeLabel.frame.height * frameForHeight)
        phoneLabel.frame.size = CGSizeMake( phoneLabel.frame.width * frameForWidth,  phoneLabel.frame.height * frameForHeight)
        homePageLabel.frame.size = CGSizeMake( homePageLabel.frame.width * frameForWidth,  homePageLabel.frame.height * frameForHeight)
        timeLabel.frame.size = CGSizeMake( timeLabel.frame.width * frameForWidth,  timeLabel.frame.height * frameForHeight)
        periodLabel.frame.size = CGSizeMake( periodLabel.frame.width * frameForWidth,  periodLabel.frame.height * frameForHeight)
        startText.frame.size = CGSizeMake( startText.frame.width * frameForWidth,  startText.frame.height * frameForHeight)
        endText.frame.size = CGSizeMake( endText.frame.width * frameForWidth,  endText.frame.height * frameForHeight)
        gapLabel.frame.size = CGSizeMake( gapLabel.frame.width * frameForWidth,  gapLabel.frame.height * frameForHeight)
        goMapBtn.frame.size = CGSizeMake( goMapBtn.frame.width * frameForWidth,  goMapBtn.frame.height * frameForHeight)
        goExplainBtn.frame.size = CGSizeMake( goExplainBtn.frame.width * frameForWidth,  goExplainBtn.frame.height * frameForHeight)
        phoneButton.frame.size = CGSizeMake( phoneButton.frame.width * frameForWidth,  phoneButton.frame.height * frameForHeight)
        homePageButton.frame.size = CGSizeMake( homePageButton.frame.width * frameForWidth,  homePageButton.frame.height * frameForHeight)
        preBtn.frame.size = CGSizeMake( preBtn.frame.width * frameForWidth,  preBtn.frame.height * frameForHeight)
        favorBtn.frame.size = CGSizeMake( favorBtn.frame.width * frameForWidth,  favorBtn.frame.height * frameForHeight)
        twBtn.frame.size = CGSizeMake( twBtn.frame.width * frameForWidth,  twBtn.frame.height * frameForHeight)
        faceBookBtn.frame.size = CGSizeMake( faceBookBtn.frame.width * frameForWidth,  faceBookBtn.frame.height * frameForHeight)
        bgImage2.frame.size = CGSizeMake( bgImage2.frame.width * frameForWidth,  bgImage2.frame.height * frameForHeight)
        bgImage3.frame.size = CGSizeMake( bgImage3.frame.width * frameForWidth,  bgImage3.frame.height * frameForHeight)
        labelsBackGround.frame.size = CGSizeMake( labelsBackGround.frame.width * frameForWidth,  labelsBackGround.frame.height * frameForHeight)
        btnsBackGround.frame.size = CGSizeMake( btnsBackGround.frame.width * frameForWidth,  btnsBackGround.frame.height * frameForHeight)
        cellBackGround.frame.size = CGSizeMake( cellBackGround.frame.width * frameForWidth,  cellBackGround.frame.height * frameForHeight)
        flagImg.frame.size = CGSizeMake( flagImg.frame.width * frameForWidth,  flagImg.frame.height * frameForHeight)
        clockImg.frame.size = CGSizeMake( clockImg.frame.width * frameForWidth,  clockImg.frame.height * frameForHeight)
        currentView.frame.size = CGSizeMake( currentView.frame.width * frameForWidth,  currentView.frame.height * frameForHeight)
        naviBarView.frame.size = CGSizeMake( naviBarView.frame.width * frameForWidth,  naviBarView.frame.height * frameForHeight)
        mapView.frame.size = CGSizeMake( mapView.frame.width * frameForWidth,  mapView.frame.height * frameForHeight)
        segmentControl.frame.size = CGSizeMake( segmentControl.frame.width * frameForWidth,  segmentControl.frame.height * frameForHeight)
        showHomePageLabel.frame.size = CGSizeMake( showHomePageLabel.frame.width * frameForWidth,  showHomePageLabel.frame.height * frameForHeight)
        showperiodLabel.frame.size = CGSizeMake( showperiodLabel.frame.width * frameForWidth,  showperiodLabel.frame.height * frameForHeight)
        showPhoneLabel.frame.size = CGSizeMake( showPhoneLabel.frame.width * frameForWidth,  showPhoneLabel.frame.height * frameForHeight)
        showTimeLabel.frame.size = CGSizeMake( showTimeLabel.frame.width * frameForWidth,  showTimeLabel.frame.height * frameForHeight)
            
            showHomePageBtnLabel.frame.size = CGSizeMake( showHomePageBtnLabel.frame.width * frameForWidth,  showHomePageBtnLabel.frame.height * frameForHeight)
            showPhoneBtnLabel.frame.size = CGSizeMake( showPhoneBtnLabel.frame.width * frameForWidth,  showPhoneBtnLabel.frame.height * frameForHeight)
            showFavorBtnLabel.frame.size = CGSizeMake( showFavorBtnLabel.frame.width * frameForWidth,  showFavorBtnLabel.frame.height * frameForHeight)
            favorBackGround.frame.size = CGSizeMake( favorBackGround.frame.width * frameForWidth,  favorBackGround.frame.height * frameForHeight)
        }
        
        scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height)
        scrollView.frame.size = CGSizeMake(view.frame.width,view.frame.height)
        
        ///////////////////

        titleLabel.text = _detailModelData.elements.valueForKey("title") as? String
        placeLabel.text = _detailModelData.elements.valueForKey("place") as? String
        phoneLabel.text = _detailModelData.elements.valueForKey("phoneNum") as? String
        homePageLabel.text = _detailModelData.elements.valueForKey("homePage") as? String
        
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
        
        mapView.layer.cornerRadius = 5
        mapView.layer.masksToBounds = true
        
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(periodLabel)
        scrollView.addSubview(homePageLabel)
        scrollView.addSubview(phoneLabel)
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
        let currentState : String = curruntState
        
        _detailModelData.beginParsing("MUSICAL", dataSid: favorDataSid)
        //뮤지컬은 장소를 DetailDataModel에서 받아야한다
        if curruntState == "MUSICAL" {
            favorStartDate = _detailModelData.elements.valueForKey("time") as! String
        }else {
            favorStartDate = startDate
        }
        
        favorPlace = _detailModelData.elements.valueForKey("place") as! String
        let dicInfo:Dictionary<String, String> = ["title":favorTitle,"startDate": favorStartDate,"endDate": favorEndDate,"place":favorPlace,"serialID": favorDataSid, "currentState" : currentState]
        
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
        var alert = UIAlertView(title: "전화걸기", message: "전화 걸어 예약하시겠습니까?", delegate: self, cancelButtonTitle: "취소")
        alert.addButtonWithTitle("전화걸기")
        alert.show()
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let indexNum = buttonIndex
        if(indexNum == 1){
            let urlStirng = "tel://" + (_detailModelData.elements.valueForKey("phoneNum") as? String)!
            let url:NSURL = NSURL(string: urlStirng)!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    @IBAction func sendButtonClicked(sender: UIButton) {
        let mainText = "\t\t[부산 문화 정보]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startText.text!+" ~ \n\t\t"+endText.text!+"\n 전화하기 : "+phoneLabel.text!
        let mainTextMusical = "\t\t[[부산 문화 정보]]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startText.text!+"\n 전화하기 : "+phoneLabel.text!
   
        
        let mainLabel = KakaoTalkLinkObject.createLabel(mainText)
        let mainLabelMusical = KakaoTalkLinkObject.createLabel(mainTextMusical)

        if KOAppCall.canOpenKakaoTalkAppLink() {
            if(curruntState != "MUSICAL"){
                KOAppCall.openKakaoTalkAppLink([mainLabel])
            }else{
                KOAppCall.openKakaoTalkAppLink([mainLabelMusical])
            }
        } else {
            println("cannot open kakaotalk.")
        }
        
//        let image = KakaoTalkLinkObject.createImage("https://developers.kakao.com/assets/img/link_sample.jpg", width: 138, height: 80)
        
//        
//        let androidAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.Android, devicetype: KakaoTalkLinkActionDeviceType.Phone, execparam: ["test1" : "test1", "test2" : "test2"])
//        let iphoneAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.Phone, execparam: ["test1" : "test1", "test2" : "test2"])
//        let ipadAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.Pad, execparam: ["test1" : "test1", "test2" : "test2"])
//        let appLink = KakaoTalkLinkObject.createAppButton("앱으로 가기", actions: [androidAppAction, iphoneAppAction, ipadAppAction])
        
        
    }
    @IBAction func actTwitter(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(twShare, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBAction  func faceBookBtnClick() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            if fbShare.setInitialText("Some text") {
                NSLog("Success")
            } else {
                NSLog("Failure")
            }
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
            actGoExplain()
        }else{
            actGoMap()
        }
        scrollView.userInteractionEnabled = true
    }
    @IBAction func actGoExplain() {
        UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.currentView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.scrollView.contentOffset = CGPointMake(0, 0)
            }, completion: nil)
        
    }
    @IBAction func actGoMap() {
        UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.currentView.transform = CGAffineTransformMakeTranslation(self.moveSeletImageX, 0);
            self.scrollView.contentOffset = CGPointMake(375, 0)
            }, completion: nil)
    }
    
    
    func replaceSpeciaChar(str:String) -> String {
        var str_change = NSMutableString(string: str)
        str_change.replaceOccurrencesOfString(".", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        
        return str_change as String
    }

}