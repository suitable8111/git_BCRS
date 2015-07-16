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
    var curruntState : String = ""
    var viewIndexNum : Int = 0
    var moveSeletImageX : CGFloat = 187.5

    //즐겨찾기 배열
    var arrFavorite:NSMutableArray!
    //맵 찾기
    var matchingItems: [MKMapItem] = [MKMapItem]()

    
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
    @IBOutlet weak var kakaoBtn: UIButton!
    //
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var shareBackBtn: UIButton!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var hiddenView: UIView!
    
    //
    
    
    @IBOutlet weak var showShareLabel: UILabel!
    @IBOutlet weak var showKakaoLinkLabel: UILabel!
    @IBOutlet weak var showFaceBookLabel: UILabel!
    @IBOutlet weak var showTwitterLabel: UILabel!
    
    
    //
    @IBOutlet weak var bgImage2: UIImageView!
    @IBOutlet weak var bgImage3: UIImageView!
    @IBOutlet weak var labelsBackGround: UIImageView!
    @IBOutlet weak var cellBackGround: UIImageView!
//    @IBOutlet weak var btnsBackGround: UIImageView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailModelData()
        self._detailModelData.beginParsing(curruntState, dataSid: serialID)
        self.scrollView.delegate = self
        let path = getFileName("myFavorite.plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("myFavorite", ofType: "plist")
            fileManager.copyItemAtPath(orgPath!, toPath: path, error: nil)
        }
        arrFavorite = NSMutableArray(contentsOfFile: path)
        
        let frameForHeight : CGFloat = view.frame.size.height/667
        let frameForWidth : CGFloat = view.frame.size.width/375
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
            //        btnsBackGround.frame.origin = CGPoint(x: btnsBackGround.frame.origin.x * frameForWidth, y: btnsBackGround.frame.origin.y * frameForHeight)
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
            kakaoBtn.frame.origin = CGPoint(x: kakaoBtn.frame.origin.x * frameForWidth, y: kakaoBtn.frame.origin.y * frameForHeight)
            shareBtn.frame.origin = CGPoint(x: shareBtn.frame.origin.x * frameForWidth, y: shareBtn.frame.origin.y * frameForHeight)
            shareBackBtn.frame.origin = CGPoint(x: shareBackBtn.frame.origin.x * frameForWidth, y: shareBackBtn.frame.origin.y * frameForHeight)
            shareView.frame.origin = CGPoint(x: shareView.frame.origin.x * frameForWidth, y: shareView.frame.origin.y * frameForHeight)
            hiddenView.frame.origin = CGPoint(x: hiddenView.frame.origin.x * frameForWidth, y: hiddenView.frame.origin.y * frameForHeight)
            
            showShareLabel.frame.origin = CGPoint(x: showShareLabel.frame.origin.x * frameForWidth, y: showShareLabel.frame.origin.y * frameForHeight)
            showKakaoLinkLabel.frame.origin = CGPoint(x: showKakaoLinkLabel.frame.origin.x * frameForWidth, y: showKakaoLinkLabel.frame.origin.y * frameForHeight)
            showFaceBookLabel.frame.origin = CGPoint(x: showFaceBookLabel.frame.origin.x * frameForWidth, y: showFaceBookLabel.frame.origin.y * frameForHeight)
            showTwitterLabel.frame.origin = CGPoint(x: showTwitterLabel.frame.origin.x * frameForWidth, y: showTwitterLabel.frame.origin.y * frameForHeight)
            
            
            
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
            //        btnsBackGround.frame.size = CGSizeMake( btnsBackGround.frame.width * frameForWidth,  btnsBackGround.frame.height * frameForHeight)
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
            kakaoBtn.frame.size = CGSizeMake( kakaoBtn.frame.width * frameForWidth,  kakaoBtn.frame.height * frameForHeight)
            shareBtn.frame.size = CGSizeMake( shareBtn.frame.width * frameForWidth,  shareBtn.frame.height * frameForHeight)
            shareBackBtn.frame.size = CGSizeMake( shareBackBtn.frame.width * frameForWidth,  shareBackBtn.frame.height * frameForHeight)
            shareView.frame.size = CGSizeMake( shareView.frame.width * frameForWidth,  shareView.frame.height * frameForHeight)
            hiddenView.frame.size = CGSizeMake( hiddenView.frame.width * frameForWidth,  hiddenView.frame.height * frameForHeight)
            
            showShareLabel.frame.size = CGSizeMake( showShareLabel.frame.width * frameForWidth,  showShareLabel.frame.height * frameForHeight)
            showKakaoLinkLabel.frame.size = CGSizeMake( showKakaoLinkLabel.frame.width * frameForWidth,  showKakaoLinkLabel.frame.height * frameForHeight)
            showFaceBookLabel.frame.size = CGSizeMake( showFaceBookLabel.frame.width * frameForWidth,  showFaceBookLabel.frame.height * frameForHeight)
            showTwitterLabel.frame.size = CGSizeMake( showTwitterLabel.frame.width * frameForWidth,  showTwitterLabel.frame.height * frameForHeight)
        }
        scrollView.contentSize =  CGSizeMake(view.frame.width*2, view.frame.height)
        scrollView.frame.size = CGSizeMake(view.frame.width,view.frame.height)
        
        mapView.layer.cornerRadius = 5
        mapView.layer.masksToBounds = true
        shareView.layer.cornerRadius = 5
        shareView.layer.masksToBounds = true
    }
    override func viewWillAppear(animated: Bool) {

        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.hidden = true
        
        titleLabel.text = titleName
        startText.text = startDate
        endText.text = endDate
        gapLabel.text = "~"
        placeLabel.text = _detailModelData.elements.valueForKey("place") as? String
        phoneLabel.text = _detailModelData.elements.valueForKey("phoneNum") as? String
        homePageLabel.text = _detailModelData.elements.valueForKey("homePage") as? String
        timeLabel.text = _detailModelData.elements.valueForKey("time") as? String
        periodLabel.text = _detailModelData.elements.valueForKey("period") as? String
        self.makeMapView()

        if (curruntState == "FESTIVAL"){
            bgImage2.image = UIImage(named: "Fastival_bg2.png")
            bgImage3.image = UIImage(named: "Fastival_bg3.png")
            timeLabel.text = "홈페이지을 참고해주세요!"
            periodLabel.text = "무료!"
        }else if (curruntState == "MUSICAL") {
            startText.text = _detailModelData.elements.valueForKey("time") as? String
            gapLabel.text = ""
            bgImage2.image = UIImage(named: "Musical_bg2.png")
            bgImage3.image = UIImage(named: "Musical_bg3.png")
        }else if (curruntState == "MUSICDANCE"){
            bgImage2.image = UIImage(named: "Music_bg2.png")
            bgImage3.image = UIImage(named: "Music_bg3.png")
        }else if (curruntState == "EXHIBIT"){
            bgImage2.image = UIImage(named: "Art_bg2.png")
            bgImage3.image = UIImage(named: "Art_bg3.png")
        }
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "GoWeb"){
            var WebPageVC = segue.destinationViewController as! WebPageController
            WebPageVC.url = _detailModelData.elements.valueForKey("homePage") as! String
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
    @IBAction func addFavor(sender: AnyObject) {
        var isEqual = false
        if (arrFavorite.count == 0){
            saveFavor()
        }else {
            for var num:Int = 0; num < arrFavorite.count; num = num + 1 {
                if (arrFavorite.objectAtIndex(num).valueForKey("title") as! String == titleName){
                    isEqual = true
                }
            }
            if !isEqual {
                saveFavor()
            }else {
                let alert = UIAlertView(title: "오류", message: "즐겨찾기에 추가된거에요", delegate: self, cancelButtonTitle: "확인")
                alert.show()
            }
        }
        favorBtn.setImage(UIImage(named: "FavorBtn_Add.png"), forState: UIControlState.Normal)
    }
    @IBAction func PhoneCall() {
        if(placeLabel.text == ""){
            var alert = UIAlertView(title: "", message: "전화번호가 없어요", delegate: self, cancelButtonTitle: "취소")
            alert.show()
        }else {
            var alert = UIAlertView(title: "전화걸기", message: "전화 걸어 예약하시겠습니까?", delegate: self, cancelButtonTitle: "취소")
            alert.addButtonWithTitle("전화걸기")
            alert.show()
        }
    }

    @IBAction func actTwitter(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if(curruntState != "MUSICAL"){
                let mainText = "\t\t[부산 문화 정보]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startText.text!+" ~ \n\t\t"+endText.text!+"\n 전화하기 : "+phoneLabel.text!
                twShare.setInitialText(mainText)
            }else{
                let mainTextMusical = "\t\t[[부산 문화 정보]]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startText.text!+"\n 전화하기 : "+phoneLabel.text!
                twShare.setInitialText(mainTextMusical)
            }
            self.presentViewController(twShare, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBAction func actKakao(sender: UIButton) {
//        let mainText = "\t\t[부산 문화 정보]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startText.text!+" ~ \n\t\t"+endText.text!+"\n 전화하기 : "+phoneLabel.text!
//        let mainTextMusical = "\t\t[[부산 문화 정보]]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startText.text!+"\n 전화하기 : "+phoneLabel.text!
//        let mainLabel = KakaoTalkLinkObject.createLabel(mainText)
//        let mainLabelMusical = KakaoTalkLinkObject.createLabel(mainTextMusical)
////        let androidAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.Android, devicetype: KakaoTalkLinkActionDeviceType.Phone, execparam: nil)
////        let iphoneAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.Phone, execparam: nil)
////        let ipadAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.Pad, execparam: nil)
////      let appLink = KakaoTalkLinkObject.createWebButton("앱으로 가기", url: "http://www.naver.com")
//        
//        if KOAppCall.canOpenKakaoTalkAppLink() {
//            if(curruntState != "MUSICAL"){
//                KOAppCall.openKakaoTalkAppLink([mainLabel])
//            }else{
//                KOAppCall.openKakaoTalkAppLink([mainLabelMusical])
//            }
//        } else {
//            println("cannot open kakaotalk.")
//        }
        
    }
    @IBAction func actFaceBook() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
    
            if(curruntState != "MUSICAL"){
                let mainText = "\t\t[부산 문화 정보]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startText.text!+" ~ \n\t\t"+endText.text!+"\n 전화하기 : "+phoneLabel.text!
                fbShare.setInitialText(mainText)
                
            }else{
                let mainTextMusical = "\t\t[[부산 문화 정보]]\n제목 : "+titleLabel.text!+"\n장소 : "+placeLabel.text!+"\n날짜 : "+startText.text!+"\n 전화하기 : "+phoneLabel.text!
                fbShare.setInitialText(mainTextMusical)
            }
            self.presentViewController(fbShare, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
            self.scrollView.contentOffset = CGPointMake(375*self.view.frame.size.width/375, 0)
            }, completion: nil)
    }
    @IBAction func actPrevious(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func actShare(sender: AnyObject) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: nil, animations: {
            self.hiddenView.alpha = CGFloat(0.5)
            self.shareView.transform = CGAffineTransformMakeTranslation(0,-150*self.view.frame.height/667)
            
            }, completion: nil)
    }
    @IBAction func actShareBack(sender: AnyObject) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: nil, animations: {
            self.shareView.transform = CGAffineTransformMakeTranslation(0,0)
            self.hiddenView.alpha = CGFloat(0)
            }, completion: nil)
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
            let placeString : String = _detailModelData.elements.valueForKey("place") as! String
            let resultString : String = "부산" + placeString
            request.naturalLanguageQuery = resultString
            request.region = mapView.region
            
            let search = MKLocalSearch(request: request)
            
            search.startWithCompletionHandler({(response:
                MKLocalSearchResponse!,
                error: NSError!) in
                
                if error != nil {
                    println("Error occured in search: \(error.localizedDescription)")
                    let span = MKCoordinateSpanMake(0.01, 0.01)
                    var location = CLLocationCoordinate2D()
                    
                    location.latitude = 35.158680
                    location.longitude = 129.160367
                    
                    let myRegion = MKCoordinateRegion(center: location , span: span)
                    self.mapView.setRegion(myRegion, animated: true)
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = "해운대 해수욕장"
                    self.mapView.addAnnotation(annotation)
                    
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
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let indexNum = buttonIndex
        if(indexNum == 1){
            let urlStirng = "tel://" + (_detailModelData.elements.valueForKey("phoneNum") as? String)!
            let url:NSURL = NSURL(string: urlStirng)!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    func saveFavor(){
        let path = getFileName("myFavorite.plist")
        let favorTitle : String = titleName
        let favorStartDate : String = startDate
        let favorEndDate : String = endDate
        let favorDataSid : String = serialID
        let favorCurrentState : String = curruntState
        
        let dataDic : Dictionary<String, String> = ["title" : favorTitle, "serialID" : favorDataSid, "currentState" : favorCurrentState, "startDate" : favorStartDate, "endDate" : favorEndDate]
        arrFavorite.addObject(dataDic)
        arrFavorite.writeToFile(path, atomically: true)
        let alert = UIAlertView(title: "즐겨찾기", message: "즐겨찾기에 추가 되었습니다!", delegate: self, cancelButtonTitle: "확인")
        alert.show()
    }
    func getFileName(fileName:String) -> String {
        let docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0] as! String
        let fullName = docPath.stringByAppendingPathComponent(fileName)
        return fullName
    }
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        scrollView.userInteractionEnabled = false
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var indexPage = scrollView.contentOffset.x / scrollView.frame.width
        if(indexPage == 0){
            UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
                self.currentView.transform = CGAffineTransformMakeTranslation(0, 0)
                }, completion: nil)
        }else{
            UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
                self.currentView.transform = CGAffineTransformMakeTranslation(self.moveSeletImageX*indexPage, 0)
                }, completion: nil)
        }
        scrollView.userInteractionEnabled = true
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var indexPage = scrollView.contentOffset.x / scrollView.frame.width
        var frame = scrollView.frame;
        frame.origin.x = frame.size.width * indexPage;
        frame.origin.y  = 0;
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    func replaceSpeciaChar(str:String) -> String {
        var str_change = NSMutableString(string: str)
        str_change.replaceOccurrencesOfString(".", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        return str_change as String
    }
    

}