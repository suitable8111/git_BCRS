//
//  FavoriteViewController.swift
//  BSPublicReservation
//
//  Created by 김대호 on 2015. 5. 14..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var arrFavorite:NSMutableArray!
    var a : Int = 0
    var b : Int = 0
    var count = 0;
    
    let date = NSDate()
    let formatter = NSDateFormatter()
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet var tbView: UITableView!
    @IBOutlet weak var showFavorLabel: UILabel!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var naviBarView: UIView!
    @IBOutlet weak var favorMainBg: UIImageView!
    override func viewDidLoad() {
        ///////////////contentSize//////////
        let frameForHeight : CGFloat = view.frame.size.height/568
        let frameForWidth : CGFloat = view.frame.size.width/320
        
        tbView.rowHeight = 55 * frameForHeight;
        if(frameForHeight != 1){
            editBtn.frame.origin = CGPoint(x: editBtn.frame.origin.x * frameForWidth, y: editBtn.frame.origin.y * frameForHeight)
            tbView.frame.origin = CGPoint(x: tbView.frame.origin.x * frameForWidth, y: tbView.frame.origin.y * frameForHeight)
            showFavorLabel.frame.origin = CGPoint(x: showFavorLabel.frame.origin.x * frameForWidth, y: showFavorLabel.frame.origin.y * frameForHeight)
            preBtn.frame.origin = CGPoint(x: preBtn.frame.origin.x * frameForWidth, y: preBtn.frame.origin.y * frameForHeight)
            naviBarView.frame.origin = CGPoint(x: naviBarView.frame.origin.x * frameForWidth, y: naviBarView.frame.origin.y * frameForHeight)
            favorMainBg.frame.origin = CGPoint(x: favorMainBg.frame.origin.x * frameForWidth, y: favorMainBg.frame.origin.y * frameForHeight)
            
            
            editBtn.frame.size = CGSizeMake(editBtn.frame.width * frameForWidth,  editBtn.frame.height * frameForHeight)
            tbView.frame.size = CGSizeMake(tbView.frame.width * frameForWidth,  tbView.frame.height * frameForHeight)
            showFavorLabel.frame.size = CGSizeMake(showFavorLabel.frame.width * frameForWidth,  showFavorLabel.frame.height * frameForHeight)
            preBtn.frame.size = CGSizeMake(preBtn.frame.width * frameForWidth,  preBtn.frame.height * frameForHeight)
            naviBarView.frame.size = CGSizeMake(naviBarView.frame.width * frameForWidth,  naviBarView.frame.height * frameForHeight)
            favorMainBg.frame.size = CGSizeMake(favorMainBg.frame.width * frameForWidth,  favorMainBg.frame.height * frameForHeight)
        }
        /////////////////////////////////////
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let path = getFileName("/myFavorite.plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("myFavorite", ofType: "plist")
            do {
                try fileManager.copyItemAtPath(orgPath!, toPath: path)
            } catch _ {
            }
        }
        arrFavorite = NSMutableArray(contentsOfFile: path)
        
        formatter.dateFormat = "yyyy-MM-dd"
        

        tbView.dataSource = self
        tbView.delegate = self
        tbView.backgroundColor = UIColor.whiteColor()
        animateTable()
        
        self.navigationItem.rightBarButtonItem = editButtonItem();
        
    }
    func animateTable(){
        tbView.reloadData()
        let cells = tbView.visibleCells
        let tableHeight : CGFloat = tbView.bounds.size.height
        
        for i in cells {
            let cell : UITableViewCell = i 
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a 
            UIView.animateWithDuration(1.0, delay: 0.02 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    func getFileName(fileName:String) -> String {
        let docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0] 
        let fullName = docPath.stringByAppendingString(fileName)
        return fullName
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavorite.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell! = tbView.dequeueReusableCellWithIdentifier("FavorCell", forIndexPath: indexPath) 
        
        let titleLabel :UILabel = cell.viewWithTag(201) as! UILabel
        let dDayLabel :UILabel = cell.viewWithTag(202) as! UILabel
        
        b = tbView.visibleCells.count + 1
        if a < b {
            titleLabel.frame.size = CGSizeMake(titleLabel.frame.width*(view.frame.size.width)/320, titleLabel.frame.height*(view.frame.height)/568)
            dDayLabel.frame.size = CGSizeMake(dDayLabel.frame.width*(view.frame.size.width)/320, dDayLabel.frame.height*(view.frame.height)/568)
            dDayLabel.frame.origin = CGPoint(x: dDayLabel.frame.origin.x*(view.frame.size.width)/320, y: dDayLabel.frame.origin.y*(view.frame.height)/568)

            a += 1
        }
        let dic = arrFavorite[indexPath.row] as! Dictionary<String,String>
        
        titleLabel.text = dic["title"]
        if(indexPath.row % 2 == 1){
            cell?.backgroundColor = UIColor(red: CGFloat(222/255.0), green: CGFloat(226/255.0), blue: CGFloat(226/255.0), alpha: CGFloat(1.0))
        }else{
            cell?.backgroundColor = UIColor.whiteColor()
        }
        
        if(dic["currentState"] != "MUSICAL"){
            let currentDate = formatter.stringFromDate(date)
            let favorDate = replaceSpeciaChar(dic["startDate"]!)
        
            let date1 = formatter.dateFromString(currentDate)
            let date2 = formatter.dateFromString(favorDate)

        
            let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
            let c1 = cal!.components(NSCalendarUnit.NSDayCalendarUnit, fromDate: date1!, toDate: date2!, options: NSCalendarOptions(rawValue: 0))
        
            if(c1.day < 0) {
                    let favorEndDate = replaceSpeciaChar(dic["endDate"]!)
                    let date3 = formatter.dateFromString(favorEndDate)
                    let c2 = cal!.components(NSCalendarUnit.NSDayCalendarUnit, fromDate: date1!, toDate: date3!, options: NSCalendarOptions(rawValue: 0))
                    dDayLabel.text = String(c2.day)+"일 까지 남음"
                if(c2.day < 0){
                    dDayLabel.text = "지나갔습니다"
                }
            }else {
                    dDayLabel.text = String(c1.day)+"일 후 시작"
            }
        }

        return cell as UITableViewCell
        
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            arrFavorite.removeObjectAtIndex(indexPath.row)
            let path = getFileName("/myFavorite.plist")
            arrFavorite.writeToFile(path, atomically: true)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goFavorDetail"{
            let FavorDetailVC = segue.destinationViewController as! FavorDetailViewController
            FavorDetailVC.titleName = arrFavorite.objectAtIndex(self.tbView.indexPathForSelectedRow!.row).valueForKey("title") as! String
            FavorDetailVC.serialID =  arrFavorite.objectAtIndex(self.tbView.indexPathForSelectedRow!.row).valueForKey("serialID") as! String
            FavorDetailVC.startDate =  arrFavorite.objectAtIndex(self.tbView.indexPathForSelectedRow!.row).valueForKey("startDate") as! String
            FavorDetailVC.endDate =  arrFavorite.objectAtIndex(self.tbView.indexPathForSelectedRow!.row).valueForKey("endDate") as! String
            FavorDetailVC.currentState = arrFavorite.objectAtIndex(self.tbView.indexPathForSelectedRow!.row).valueForKey("currentState") as! String
            FavorDetailVC.indexPathRow = self.tbView.indexPathForSelectedRow!.row
        
        }
    }
    
    
    @IBAction func actEditBtn(sender: AnyObject) {

        if(count % 2 == 0){
            self.tbView.setEditing(true, animated: true)
        }else {
            self.tbView.setEditing(false, animated: true)
        }
        count = count + 1;
    }
    @IBAction func actPrevios(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func replaceSpeciaChar(str:String) -> String {
        let str_change = NSMutableString(string: str)
        str_change.replaceOccurrencesOfString(".", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        
        return str_change as String
    }
    
}
