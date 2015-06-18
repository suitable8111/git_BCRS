//
//  ListViewController.swift
//  BSPublicReservation
//
//  Created by IT on 2015. 4. 28..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import UIKit
import AVFoundation

class ListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    

    //데이타 모델 클래스
    var _modelData:DataModel!
    var _detailModelData:DetailDataModel!
    var indexNum : Int = 0
    var dataSid : String = ""
    var curruntState : String = "MUSICDANCE"
    var searchActive : Bool = false
    var backgroundMusic = AVAudioPlayer()
    var date = NSDate()
    var formatter = NSDateFormatter()
    var clickNum : Int = 0
    //Dynamic TableViewCell var
    var a : Int = 0
    var b : Int = 0
    //애니메이션
    //TABBar버튼들
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var FavorBtn: UIButton!
    
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var thisMonthBtn: UIButton!
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var festivalBtn: UIButton!
    @IBOutlet weak var musicBtn: UIButton!
    @IBOutlet weak var artBtn: UIButton!
    @IBOutlet weak var musicalBtn: UIButton!
    
    var is_current:Bool!
    var dataArray:NSMutableArray!
    var CRDataArray:NSMutableArray!
    
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet var tbView: UITableView!
    @IBOutlet weak var barSearch: UISearchBar!


    func modelData() -> DataModel {
        if(_modelData == nil){
            _modelData = DataModel()
        }
        return _modelData
    }
    func detailModelData() -> DetailDataModel {
        if(_detailModelData == nil){
            _detailModelData = DetailDataModel()
        }
        return _detailModelData
    }
    override func viewWillAppear(animated: Bool) {     
        self.navigationController?.navigationBar.hidden = true
        animateTable()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        backgroundMusic = self.setupAudioPlayerWithFile("HitB", type:"wav")
        backgroundMusic.play()
        
        tbView.dataSource = self
        tbView.delegate = self
        tbView.rowHeight = 70
        barSearch.delegate = self
        
        tbView.backgroundColor = UIColor(red: CGFloat(222/255.0), green: CGFloat(226/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(1.0))
    
        //contentSize//////////////////////////////////
        FavorBtn.center = CGPoint(x: FavorBtn.center.x*(view.center.x)/187.5, y: FavorBtn.center.y)
        menuBtn.center = CGPoint(x: menuBtn.center.x*(view.center.x)/187.5, y: menuBtn.center.y)
        tbView.frame.size = CGSizeMake(tbView.frame.size.width*(view.frame.size.width)/375,tbView.frame.size.height*(view.frame.size.height)/667)
        ////////////////////////////////////////////////
        
        self.modelData()
        self.detailModelData()
        
        
        formatter.dateFormat = "yyyyMM"
        let monthDate = formatter.stringFromDate(date)
        var monthInt = monthDate.toInt()
        self._modelData.beginParsing(curruntState,timeInt: monthInt!)
        dataArray = _modelData.posts
        findTodayObjects()
        
    }
    //테이블뷰 애니메이션
    func animateTable(){
        tbView.reloadData()
        let cells = tbView.visibleCells()
        let tableHeight : CGFloat = tbView.bounds.size.height
        
        for i in cells {
            let cell : UITableViewCell = i as! UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as! UITableViewCell
            UIView.animateWithDuration(1.0, delay: 0.02 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    func getFileName(fileName:String) -> String {
        let docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0] as! String
        let fullName = docPath.stringByAppendingPathComponent(fileName)
        return fullName
    }
    
    ///tableView method
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if is_current == true {
            return CRDataArray.count
        }else {
            return dataArray.count
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tbView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        let titleLabel = cell!.viewWithTag(101) as! UILabel
        
        //contentSize//////////////////////////////////
        b = tbView.visibleCells().count + 1
        if a < b {
            titleLabel.frame.size = CGSizeMake(titleLabel.frame.width*(view.frame.size.width)/375, titleLabel.frame.height*(view.frame.height)/667)
        a += 1
        }
        ///////////////////////////////////////////////
        
        
        dataSid = (dataArray.objectAtIndex(indexPath.row).valueForKey("serialID") as? String)!
        _detailModelData.beginParsing("FESTIVAL", dataSid: dataSid)
        
        if is_current == true{
            titleLabel.text = CRDataArray.objectAtIndex(indexPath.row).valueForKey("title") as? String
        }else {
            titleLabel.text = dataArray.objectAtIndex(indexPath.row).valueForKey("title") as? String
        }
        
        
        if(indexPath.row % 2 == 1){
            cell?.backgroundColor = UIColor(red: CGFloat(222/255.0), green: CGFloat(226/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(1.0))
        }else{
            cell?.backgroundColor = UIColor.whiteColor()
        }
        return cell!
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
    //정보전달 부분
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goDetail"){
        var DetailVC = segue.destinationViewController as! DetailListViewController
        DetailVC.titleName = dataArray.objectAtIndex(self.tbView.indexPathForSelectedRow()!.row).valueForKey("title") as! String
        DetailVC.serialID = dataArray.objectAtIndex(self.tbView.indexPathForSelectedRow()!.row).valueForKey("serialID") as! String
        DetailVC.startDate = dataArray.objectAtIndex(self.tbView.indexPathForSelectedRow()!.row).valueForKey("startDate") as! String
        DetailVC.endDate = dataArray.objectAtIndex(self.tbView.indexPathForSelectedRow()!.row).valueForKey("endDate") as! String
        DetailVC.placeName = _detailModelData.elements.valueForKey("place") as! String
        DetailVC.curruntState = curruntState

        }
    }
    
    
    
    @IBAction func actfestivalSelect(sender: AnyObject) {
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.menuView.frame.size = CGSizeMake(self.menuView.frame.width, 0)
            self.festivalBtn.frame.size = CGSizeMake(self.festivalBtn.frame.width, 0)
            self.artBtn.frame.size = CGSizeMake(self.artBtn.frame.width, 0)
            self.musicalBtn.frame.size = CGSizeMake(self.musicalBtn.frame.width, 0)
            self.musicBtn.frame.size = CGSizeMake(self.musicBtn.frame.width, 0)
            }, completion: nil)
        clickNum = clickNum + 1
        menuBtn.setImage(UIImage(named: "fastival_Name_Bt.png"), forState: UIControlState.Normal)
        curruntState = "FESTIVAL"
    }
    @IBAction func actMusicSelect(sender: AnyObject) {
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.menuView.frame.size = CGSizeMake(self.menuView.frame.width, 0)
            self.festivalBtn.frame.size = CGSizeMake(self.festivalBtn.frame.width, 0)
            self.artBtn.frame.size = CGSizeMake(self.artBtn.frame.width, 0)
            self.musicalBtn.frame.size = CGSizeMake(self.musicalBtn.frame.width, 0)
            self.musicBtn.frame.size = CGSizeMake(self.musicBtn.frame.width, 0)
            }, completion: nil)
        clickNum = clickNum + 1
        menuBtn.setImage(UIImage(named: "Music_Name_Bt.png"), forState: UIControlState.Normal)
        curruntState = "MUSICDANCE"
    }
    @IBAction func actMusicalSelect(sender: AnyObject) {
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.menuView.frame.size = CGSizeMake(self.menuView.frame.width, 0)
            self.festivalBtn.frame.size = CGSizeMake(self.festivalBtn.frame.width, 0)
            self.artBtn.frame.size = CGSizeMake(self.artBtn.frame.width, 0)
            self.musicalBtn.frame.size = CGSizeMake(self.musicalBtn.frame.width, 0)
            self.musicBtn.frame.size = CGSizeMake(self.musicBtn.frame.width, 0)
            }, completion: nil)
        clickNum = clickNum + 1
        menuBtn.setImage(UIImage(named: "Musical_Name_Bt.png"), forState: UIControlState.Normal)
        curruntState = "MUSICAL"
    }
    @IBAction func actArtSelect(sender: AnyObject) {
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.menuView.frame.size = CGSizeMake(self.menuView.frame.width, 0)
            self.festivalBtn.frame.size = CGSizeMake(self.festivalBtn.frame.width, 0)
            self.artBtn.frame.size = CGSizeMake(self.artBtn.frame.width, 0)
            self.musicalBtn.frame.size = CGSizeMake(self.musicalBtn.frame.width, 0)
            self.musicBtn.frame.size = CGSizeMake(self.musicBtn.frame.width, 0)
            }, completion: nil)
        clickNum = clickNum + 1
        menuBtn.setImage(UIImage(named: "Art_Name_Bt.png"), forState: UIControlState.Normal)
        curruntState = "EXHIBIT"
    }

    @IBAction func actMenuSelect(sender: AnyObject) {

        if(clickNum % 2 == 0) {
            UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
                self.menuView.frame.size = CGSizeMake(self.menuView.frame.width, 180)
                self.festivalBtn.frame.size = CGSizeMake(self.festivalBtn.frame.width, 48)
                self.artBtn.frame.size = CGSizeMake(self.artBtn.frame.width, 48)
                self.musicalBtn.frame.size = CGSizeMake(self.musicalBtn.frame.width, 48)
                self.musicBtn.frame.size = CGSizeMake(self.musicBtn.frame.width, 48)
                }, completion: nil)
        }else{
            UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                self.menuView.frame.size = CGSizeMake(self.menuView.frame.width, 0)
                self.festivalBtn.frame.size = CGSizeMake(self.festivalBtn.frame.width, 0)
                self.artBtn.frame.size = CGSizeMake(self.artBtn.frame.width, 0)
                self.musicalBtn.frame.size = CGSizeMake(self.musicalBtn.frame.width, 0)
                self.musicBtn.frame.size = CGSizeMake(self.musicBtn.frame.width, 0)
                }, completion: nil)
        }
        clickNum = clickNum + 1
    }
    @IBAction func actTodayView() {
        findTodayObjects()
        formatter.dateFormat = "yyyyMM"
        let monthDate = formatter.stringFromDate(date)
        var monthInt = monthDate.toInt()
        self._modelData.beginParsing(curruntState,timeInt: monthInt!)
        dataArray = _modelData.posts
        animateTable()
        UIView.animateWithDuration(1.0, delay: 0.02, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.selectImage.transform = CGAffineTransformMakeTranslation(0, 0);
            }, completion: nil)
    }
    @IBAction func actNextMonthView() {
        is_current = false
        formatter.dateFormat = "yyyyMM"
        let monthDate = formatter.stringFromDate(date)
        var monthInt = monthDate.toInt()
        monthInt = monthInt! + 1
        self._modelData.beginParsing(curruntState,timeInt: monthInt!)
        dataArray = _modelData.posts
        animateTable()
        UIView.animateWithDuration(1.0, delay: 0.02, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.selectImage.transform = CGAffineTransformMakeTranslation(130, 0);
            }, completion: nil)
    }
    @IBAction func actThisMonthView() {
        is_current = false
        formatter.dateFormat = "yyyyMM"
        let monthDate = formatter.stringFromDate(date)
        var monthInt = monthDate.toInt()
        self._modelData.beginParsing(curruntState,timeInt: monthInt!)
        dataArray = _modelData.posts
        animateTable()
        UIView.animateWithDuration(1.0, delay: 0.02, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
            self.selectImage.transform = CGAffineTransformMakeTranslation(-131, 0);
            }, completion: nil)
    }
    func findTodayObjects(){
        is_current = true
        CRDataArray = []
        formatter.dateFormat = "yyyyMMdd"
        let currentDate = formatter.stringFromDate(date)
        var currentInt = currentDate.toInt()
        
        for var index = 0; index < dataArray.count; index++ {
            var startDate:Int = replaceSpecialChar(dataArray.objectAtIndex(index).valueForKey("startDate") as! String).toInt()!
            var endDate:Int = replaceSpecialChar(dataArray.objectAtIndex(index).valueForKey("endDate") as! String).toInt()!
            
            if (currentInt > startDate && currentInt < endDate){
                CRDataArray.addObject(dataArray.objectAtIndex(index))
            }else{
                
            }
            
        }
    }
    func replaceSpecialChar(str:String) -> String{
        var str_change = NSMutableString(string: str)
        
        str_change.replaceOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        
        return str_change as String
    }
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        //1
        var path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        var url = NSURL.fileURLWithPath(path!)
        //2
        var error: NSError?
        //3
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        //4
        return audioPlayer!
    }
}