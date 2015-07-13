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
    var arrFavorite:NSMutableArray!
    var _detailModelData : DetailDataModel!
    var titleName : String = ""
    var startDate : String = ""
    var endDate : String = ""
    var serialID : String = ""
    var currentState : String = ""
    var indexPathRow : Int = 0
    
    var moveSeletImageX : CGFloat = 187.5
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var homePageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var gapLabel: UILabel!
    

    @IBOutlet weak var showCancelFavorLabel: UILabel!
    @IBOutlet weak var showHomePageBtnLabel: UILabel!
    @IBOutlet weak var showPhoneBtnLabel: UILabel!
    @IBOutlet weak var showPhoneLabel: UILabel!
    @IBOutlet weak var showHomePageLabel: UILabel!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var showPeriodLabel: UILabel!
    @IBOutlet weak var goMapBtn: UIButton!
    @IBOutlet weak var goExplainBtn: UIButton!
    @IBOutlet weak var cancelFavorBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var homePageBtn: UIButton!
    @IBOutlet weak var faceBookBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var kakaoBtn: UIButton!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var bgImage1: UIImageView!
    @IBOutlet weak var bgImage2: UIImageView!
    @IBOutlet weak var cellBackGround: UIImageView!
    @IBOutlet weak var favorBackGround: UIImageView!
    @IBOutlet weak var labelsBackGround: UIImageView!
    @IBOutlet weak var btnsBackGround: UIImageView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var clockImg: UIImageView!
    
    @IBOutlet weak var currentView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectedControl: UISegmentedControl!
    
    @IBOutlet weak var naviBarView: UIView!
    
    

    func detailDataModel() -> DetailDataModel {
        if(_detailModelData == nil) {
            _detailModelData = DetailDataModel()
        }
        
        return _detailModelData
    }
    override func viewWillAppear(animated: Bool){
        
        self.detailDataModel()
        _detailModelData.beginParsing(currentState, dataSid: serialID)
        self.makeMapView()
        self.scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.hidden = true
        
        let path = getFileName("myFavorite.plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("myFavorite", ofType: "plist")
            fileManager.copyItemAtPath(orgPath!, toPath: path, error: nil)
        }
        arrFavorite = NSMutableArray(contentsOfFile: path)
        
        let frameForHeight : CGFloat = view.frame.size.height/667
        let frameForWidth : CGFloat = view.frame.size.width/375
        let originForX : CGFloat = view.center.x/187.5
        let originForY : CGFloat = view.center.y/333.5
        
        titleLabel.text = titleName
        startLabel.text = startDate
        endLabel.text = endDate
        placeLabel.text = _detailModelData.elements.valueForKey("place") as? String
        timeLabel.text = _detailModelData.elements.valueForKey("time") as? String
        phoneLabel.text = _detailModelData.elements.valueForKey("phoneNum") as? String
        homePageLabel.text = _detailModelData.elements.valueForKey("homePage") as? String
        periodLabel.text = _detailModelData.elements.valueForKey("period") as? String
        
        if(currentState == "MUSICAL"){
            startLabel.text = _detailModelData.elements.valueForKey("time") as? String
            gapLabel.text = ""
            endLabel.text = ""
        }else if(currentState == "FESTIVAL"){
            periodLabel.text = "무료"
            timeLabel.text = "홈페이지를 참고해주세요!"
        }
        
        if(frameForHeight != 1){
            
            moveSeletImageX = moveSeletImageX * frameForWidth
            titleLabel.frame.origin = CGPoint(x: titleLabel.frame.origin.x * frameForWidth, y: titleLabel.frame.origin.y * frameForHeight)
            placeLabel.frame.origin = CGPoint(x: placeLabel.frame.origin.x * frameForWidth, y: placeLabel.frame.origin.y * frameForHeight)
            phoneLabel.frame.origin = CGPoint(x: phoneLabel.frame.origin.x * frameForWidth, y: phoneLabel.frame.origin.y * frameForHeight)
            homePageLabel.frame.origin = CGPoint(x: homePageLabel.frame.origin.x * frameForWidth, y: homePageLabel.frame.origin.y * frameForHeight)
            timeLabel.frame.origin = CGPoint(x: timeLabel.frame.origin.x * frameForWidth, y: timeLabel.frame.origin.y * frameForHeight)
            periodLabel.frame.origin = CGPoint(x: periodLabel.frame.origin.x * frameForWidth, y: periodLabel.frame.origin.y * frameForHeight)
            startLabel.frame.origin = CGPoint(x: startLabel.frame.origin.x * frameForWidth, y: startLabel.frame.origin.y * frameForHeight)
            endLabel.frame.origin = CGPoint(x: endLabel.frame.origin.x * frameForWidth, y: endLabel.frame.origin.y * frameForHeight)
            gapLabel.frame.origin = CGPoint(x: gapLabel.frame.origin.x * frameForWidth, y: gapLabel.frame.origin.y * frameForHeight)
            goMapBtn.frame.origin = CGPoint(x: goMapBtn.frame.origin.x * frameForWidth, y: goMapBtn.frame.origin.y * frameForHeight)
            goExplainBtn.frame.origin = CGPoint(x: goExplainBtn.frame.origin.x * frameForWidth, y: goExplainBtn.frame.origin.y * frameForHeight)
            phoneBtn.frame.origin = CGPoint(x: phoneBtn.frame.origin.x * frameForWidth, y: phoneBtn.frame.origin.y * frameForHeight)
            homePageBtn.frame.origin = CGPoint(x: homePageBtn.frame.origin.x * frameForWidth, y: homePageBtn.frame.origin.y * frameForHeight)
            preBtn.frame.origin = CGPoint(x: preBtn.frame.origin.x * frameForWidth, y: preBtn.frame.origin.y * frameForHeight)
            twitterBtn.frame.origin = CGPoint(x: twitterBtn.frame.origin.x * frameForWidth, y: twitterBtn.frame.origin.y * frameForHeight)
            faceBookBtn.frame.origin = CGPoint(x: faceBookBtn.frame.origin.x * frameForWidth, y: faceBookBtn.frame.origin.y * frameForHeight)
            bgImage1.frame.origin = CGPoint(x: bgImage1.frame.origin.x * frameForWidth, y: bgImage1.frame.origin.y * frameForHeight)
            bgImage2.frame.origin = CGPoint(x: bgImage2.frame.origin.x * frameForWidth, y: bgImage2.frame.origin.y * frameForHeight)
            labelsBackGround.frame.origin = CGPoint(x: labelsBackGround.frame.origin.x * frameForWidth, y: labelsBackGround.frame.origin.y * frameForHeight)
            btnsBackGround.frame.origin = CGPoint(x: btnsBackGround.frame.origin.x * frameForWidth, y: btnsBackGround.frame.origin.y * frameForHeight)
            cellBackGround.frame.origin = CGPoint(x: cellBackGround.frame.origin.x * frameForWidth, y: cellBackGround.frame.origin.y * frameForHeight)
            flagImg.frame.origin = CGPoint(x: flagImg.frame.origin.x * frameForWidth, y: flagImg.frame.origin.y * frameForHeight)
            clockImg.frame.origin = CGPoint(x: clockImg.frame.origin.x * frameForWidth, y: clockImg.frame.origin.y * frameForHeight)
            currentView.frame.origin = CGPoint(x: currentView.frame.origin.x * frameForWidth, y: currentView.frame.origin.y * frameForHeight)
            naviBarView.frame.origin = CGPoint(x: naviBarView.frame.origin.x * frameForWidth, y: naviBarView.frame.origin.y * frameForHeight)
            mapView.frame.origin = CGPoint(x: mapView.frame.origin.x * frameForWidth, y: mapView.frame.origin.y * frameForHeight)
            selectedControl.frame.origin = CGPoint(x: selectedControl.frame.origin.x * frameForWidth, y: selectedControl.frame.origin.y * frameForHeight)
            showHomePageLabel.frame.origin = CGPoint(x: showHomePageLabel.frame.origin.x * frameForWidth, y: showHomePageLabel.frame.origin.y * frameForHeight)
            showPeriodLabel.frame.origin = CGPoint(x: showPeriodLabel.frame.origin.x * frameForWidth, y: showPeriodLabel.frame.origin.y * frameForHeight)
            showPhoneLabel.frame.origin = CGPoint(x: showPhoneLabel.frame.origin.x * frameForWidth, y: showPhoneLabel.frame.origin.y * frameForHeight)
            showTimeLabel.frame.origin = CGPoint(x: showTimeLabel.frame.origin.x * frameForWidth, y: showTimeLabel.frame.origin.y * frameForHeight)
            favorBackGround.frame.origin = CGPoint(x: favorBackGround.frame.origin.x * frameForWidth, y: favorBackGround.frame.origin.y * frameForHeight)
            showHomePageBtnLabel.frame.origin = CGPoint(x: showHomePageBtnLabel.frame.origin.x * frameForWidth, y: showHomePageBtnLabel.frame.origin.y * frameForHeight)
            showPhoneBtnLabel.frame.origin = CGPoint(x: showPhoneBtnLabel.frame.origin.x * frameForWidth, y: showPhoneBtnLabel.frame.origin.y * frameForHeight)
            showCancelFavorLabel.frame.origin = CGPoint(x: showCancelFavorLabel.frame.origin.x * frameForWidth, y: showCancelFavorLabel.frame.origin.y * frameForHeight)
            cancelFavorBtn.frame.origin = CGPoint(x: cancelFavorBtn.frame.origin.x * frameForWidth, y: cancelFavorBtn.frame.origin.y * frameForHeight)
            kakaoBtn.frame.origin = CGPoint(x: kakaoBtn.frame.origin.x * frameForWidth, y: kakaoBtn.frame.origin.y * frameForHeight)

            titleLabel.frame.size = CGSizeMake(titleLabel.frame.width * frameForWidth,  titleLabel.frame.height * frameForHeight)
            placeLabel.frame.size = CGSizeMake( placeLabel.frame.width * frameForWidth,  placeLabel.frame.height * frameForHeight)
            phoneLabel.frame.size = CGSizeMake( phoneLabel.frame.width * frameForWidth,  phoneLabel.frame.height * frameForHeight)
            homePageLabel.frame.size = CGSizeMake( homePageLabel.frame.width * frameForWidth,  homePageLabel.frame.height * frameForHeight)
            timeLabel.frame.size = CGSizeMake( timeLabel.frame.width * frameForWidth,  timeLabel.frame.height * frameForHeight)
            periodLabel.frame.size = CGSizeMake( periodLabel.frame.width * frameForWidth,  periodLabel.frame.height * frameForHeight)
            startLabel.frame.size = CGSizeMake( startLabel.frame.width * frameForWidth,  startLabel.frame.height * frameForHeight)
            endLabel.frame.size = CGSizeMake( endLabel.frame.width * frameForWidth,  endLabel.frame.height * frameForHeight)
            gapLabel.frame.size = CGSizeMake( gapLabel.frame.width * frameForWidth,  gapLabel.frame.height * frameForHeight)
            goMapBtn.frame.size = CGSizeMake( goMapBtn.frame.width * frameForWidth,  goMapBtn.frame.height * frameForHeight)
            goExplainBtn.frame.size = CGSizeMake( goExplainBtn.frame.width * frameForWidth,  goExplainBtn.frame.height * frameForHeight)
            phoneBtn.frame.size = CGSizeMake( phoneBtn.frame.width * frameForWidth,  phoneBtn.frame.height * frameForHeight)
            homePageBtn.frame.size = CGSizeMake( homePageBtn.frame.width * frameForWidth,  homePageBtn.frame.height * frameForHeight)
            preBtn.frame.size = CGSizeMake( preBtn.frame.width * frameForWidth,  preBtn.frame.height * frameForHeight)
            twitterBtn.frame.size = CGSizeMake( twitterBtn.frame.width * frameForWidth,  twitterBtn.frame.height * frameForHeight)
            faceBookBtn.frame.size = CGSizeMake( faceBookBtn.frame.width * frameForWidth,  faceBookBtn.frame.height * frameForHeight)
            bgImage1.frame.size = CGSizeMake( bgImage1.frame.width * frameForWidth,  bgImage1.frame.height * frameForHeight)
            bgImage2.frame.size = CGSizeMake( bgImage2.frame.width * frameForWidth,  bgImage2.frame.height * frameForHeight)
            labelsBackGround.frame.size = CGSizeMake( labelsBackGround.frame.width * frameForWidth,  labelsBackGround.frame.height * frameForHeight)
            btnsBackGround.frame.size = CGSizeMake( btnsBackGround.frame.width * frameForWidth,  btnsBackGround.frame.height * frameForHeight)
            cellBackGround.frame.size = CGSizeMake( cellBackGround.frame.width * frameForWidth,  cellBackGround.frame.height * frameForHeight)
            flagImg.frame.size = CGSizeMake( flagImg.frame.width * frameForWidth,  flagImg.frame.height * frameForHeight)
            clockImg.frame.size = CGSizeMake( clockImg.frame.width * frameForWidth,  clockImg.frame.height * frameForHeight)
            currentView.frame.size = CGSizeMake( currentView.frame.width * frameForWidth,  currentView.frame.height * frameForHeight)
            naviBarView.frame.size = CGSizeMake( naviBarView.frame.width * frameForWidth,  naviBarView.frame.height * frameForHeight)
            mapView.frame.size = CGSizeMake( mapView.frame.width * frameForWidth,  mapView.frame.height * frameForHeight)
            selectedControl.frame.size = CGSizeMake( selectedControl.frame.width * frameForWidth,  selectedControl.frame.height * frameForHeight)
            showHomePageLabel.frame.size = CGSizeMake( showHomePageLabel.frame.width * frameForWidth,  showHomePageLabel.frame.height * frameForHeight)
            showPeriodLabel.frame.size = CGSizeMake( showPeriodLabel.frame.width * frameForWidth,  showPeriodLabel.frame.height * frameForHeight)
            showPhoneLabel.frame.size = CGSizeMake( showPhoneLabel.frame.width * frameForWidth,  showPhoneLabel.frame.height * frameForHeight)
            showTimeLabel.frame.size = CGSizeMake( showTimeLabel.frame.width * frameForWidth,  showTimeLabel.frame.height * frameForHeight)
            showHomePageBtnLabel.frame.size = CGSizeMake( showHomePageBtnLabel.frame.width * frameForWidth,  showHomePageBtnLabel.frame.height * frameForHeight)
            showPhoneBtnLabel.frame.size = CGSizeMake( showPhoneBtnLabel.frame.width * frameForWidth,  showPhoneBtnLabel.frame.height * frameForHeight)
            favorBackGround.frame.size = CGSizeMake( favorBackGround.frame.width * frameForWidth,  favorBackGround.frame.height * frameForHeight)
            showCancelFavorLabel.frame.size = CGSizeMake( showCancelFavorLabel.frame.width * frameForWidth,  showCancelFavorLabel.frame.height * frameForHeight)
            cancelFavorBtn.frame.size = CGSizeMake( cancelFavorBtn.frame.width * frameForWidth,  cancelFavorBtn.frame.height * frameForHeight)
            kakaoBtn.frame.size = CGSizeMake( kakaoBtn.frame.width * frameForWidth,  kakaoBtn.frame.height * frameForHeight)
        }
        
        
        scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height)
        scrollView.frame.size = CGSizeMake(view.frame.width,view.frame.height)
        
        mapView.layer.cornerRadius = 5
        mapView.layer.masksToBounds = true
        
    }
    func getFileName(fileName:String) -> String {
        let docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0] as! String
        let fullName = docPath.stringByAppendingPathComponent(fileName)
        return fullName
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "GoWeb"){
            var WebPageVC = segue.destinationViewController as! WebPageController
            WebPageVC.url = _detailModelData.elements.valueForKey("homePage") as! String
        }
    }
    @IBAction func actPhoneCall(sender: AnyObject) {
        if (phoneLabel.text == ""){
            var alert = UIAlertView(title: "", message: "전화번호가 없어요", delegate: self, cancelButtonTitle: "취소")
            alert.show()
        }else {
            var alert = UIAlertView(title: "전화걸기", message: "전화 거시겠습니까?", delegate: self, cancelButtonTitle: "취소")
            alert.addButtonWithTitle("전화걸기")
            alert.show()
        }
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
    @IBAction func actCancelFavor(sender: AnyObject){
        arrFavorite.removeObjectAtIndex(indexPathRow)
        let path = getFileName("myFavorite.plist")
        arrFavorite.writeToFile(path, atomically: true)
        var alert = UIAlertView(title: "즐겨찾기", message: "즐겨찾기 메뉴에 제거 되었습니다!", delegate: self, cancelButtonTitle: "확인")
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

    @IBAction func actKaKaoLink(sender: AnyObject) {
        
        let mainText = "\t\t[부산 문화 정보]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startLabel.text!+" ~ \n\t\t"+endLabel.text!+"\n 전화하기 : "+phoneLabel.text!
        let mainTextMusical = "\t\t[[부산 문화 정보]]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startLabel.text!+"\n 전화하기 : "+phoneLabel.text!
        let mainLabel = KakaoTalkLinkObject.createLabel(mainText)
        let mainLabelMusical = KakaoTalkLinkObject.createLabel(mainTextMusical)
        
        if KOAppCall.canOpenKakaoTalkAppLink() {
                KOAppCall.openKakaoTalkAppLink([mainLabel])
            
        } else {
            println("cannot open kakaotalk.")
        }
        
    }

}
