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


    @IBOutlet var tbView: UITableView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let path = getFileName("myFavorite.plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("myFavorite", ofType: "plist")
            fileManager.copyItemAtPath(orgPath!, toPath: path, error: nil)
        }
        
        arrFavorite = NSMutableArray(contentsOfFile: path)

        tbView.rowHeight = 70;
        tbView.dataSource = self
        tbView.delegate = self
        tbView.backgroundColor = UIColor(red: CGFloat(222/255.0), green: CGFloat(226/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(1.0))
        
        self.navigationItem.rightBarButtonItem = editButtonItem();

        tbView.frame.size = CGSizeMake(tbView.frame.width*(view.frame.width)/375, tbView.frame.height*(view.frame.height)/667)
    }
    func getFileName(fileName:String) -> String {
        let docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0] as! String
        let fullName = docPath.stringByAppendingPathComponent(fileName)
        return fullName
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavorite.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell! = tbView.dequeueReusableCellWithIdentifier("FavorCell", forIndexPath: indexPath) as! UITableViewCell
        
        let titleLabel :UILabel = cell.viewWithTag(201) as! UILabel
        let dDayLabel :UILabel = cell.viewWithTag(202) as! UILabel
        
        b = tbView.visibleCells().count + 1
        if a < b {
            titleLabel.frame.size = CGSizeMake(titleLabel.frame.width*(view.frame.size.width)/375, titleLabel.frame.height*(view.frame.height)/667)
            dDayLabel.frame.size = CGSizeMake(dDayLabel.frame.width*(view.frame.size.width)/375, dDayLabel.frame.height*(view.frame.height)/667)

            a += 1
        }
        let dic = arrFavorite[indexPath.row] as! Dictionary<String,String>
        
        titleLabel.text = dic["title"]
        if(indexPath.row % 2 == 1){
            cell?.backgroundColor = UIColor(red: CGFloat(222/255.0), green: CGFloat(226/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(1.0))
        }else{
            cell?.backgroundColor = UIColor.whiteColor()
        }
        
        let dDay = dic["dDay"]
        
        
        if(dDay!.toInt() < 0){
            dDayLabel.text = "지남"
        }else {
            dDayLabel.text = dDay!+"일 남음"
        }

        return cell as UITableViewCell
        
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            arrFavorite.removeObjectAtIndex(indexPath.row)
            let path = getFileName("myFavorite.plist")
            arrFavorite.writeToFile(path, atomically: true)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goFavorDetail"{
            var FavorDetailVC = segue.destinationViewController as! FavorDetailViewController
            FavorDetailVC.serialID =  arrFavorite.objectAtIndex(self.tbView.indexPathForSelectedRow()!.row).valueForKey("serialID") as! String
            FavorDetailVC.startDate =  arrFavorite.objectAtIndex(self.tbView.indexPathForSelectedRow()!.row).valueForKey("startDate") as! String
            FavorDetailVC.endDate =  arrFavorite.objectAtIndex(self.tbView.indexPathForSelectedRow()!.row).valueForKey("endDate") as! String
        
        }
    }
    
    
    @IBAction func actPrevios(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
