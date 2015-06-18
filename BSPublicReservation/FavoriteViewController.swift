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
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet var tbView: UITableView!
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        super.viewWillAppear(true)
        let path = getFileName("myFavorite.plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("myFavorite", ofType: "plist")
            fileManager.copyItemAtPath(orgPath!, toPath: path, error: nil)
        }
        arrFavorite = NSMutableArray(contentsOfFile: path)
        tbView.rowHeight = 100;
        tbView.dataSource = self
        tbView.delegate = self
        tbView.backgroundColor = UIColor(red: CGFloat(222/255.0), green: CGFloat(226/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(1.0))
        
        self.navigationItem.rightBarButtonItem = editButtonItem();
        
        backGroundView.frame.size = CGSizeMake(backGroundView.frame.width*(view.frame.width)/375, backGroundView.frame.height*(view.frame.height)/667)
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
        let startLabel = cell.viewWithTag(202) as! UILabel
        let endLabel = cell.viewWithTag(203) as! UILabel
        let placeLabel = cell.viewWithTag(204) as! UILabel
        let imageView = cell!.viewWithTag(205) as! UIImageView
        let placeImage = cell!.viewWithTag(206) as! UIImageView
        let timeImage = cell!.viewWithTag(207) as! UIImageView
        
        imageView.image = UIImage(named: "Cell_BackGround.png")
        placeImage.image = UIImage(named: "Cell_Flog.png")
        timeImage.image = UIImage(named: "Cell_Clock.png")
        b = tbView.visibleCells().count + 1
        if a < b {
            titleLabel.frame.size = CGSizeMake(titleLabel.frame.width*(view.frame.size.width)/375, titleLabel.frame.height*(view.frame.height)/667)
            startLabel.frame.size = CGSizeMake(startLabel.frame.width*(view.frame.size.width)/375, startLabel.frame.height*(view.frame.height)/667)
            endLabel.frame.size = CGSizeMake(endLabel.frame.width*(view.frame.size.width)/375, endLabel.frame.height*(view.frame.height)/667)
            placeLabel.frame.size = CGSizeMake(placeLabel.frame.width*(view.frame.size.width)/375, placeLabel.frame.height*(view.frame.height)/667)
            
            imageView.frame.size = CGSizeMake(imageView.frame.width*(view.frame.size.width)/375, imageView.frame.height)
            placeImage.frame.size = CGSizeMake(placeImage.frame.width*(view.frame.size.width)/375, placeImage.frame.height)
            timeImage.frame.size = CGSizeMake(timeImage.frame.width*(view.frame.size.width)/375, timeImage.frame.height)
            a += 1
        }
        
        let dic = arrFavorite[indexPath.row] as! Dictionary<String,String>
        titleLabel.text = dic["title"]
        startLabel.text = dic["startDate"]
        endLabel.text = dic["endDate"]
        placeLabel.text = dic["place"]
        
        cell.backgroundColor = UIColor(red: CGFloat(222/255.0), green: CGFloat(226/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(0.0))
    
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
}
