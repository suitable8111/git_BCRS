//
//  FcstDataModel.swift
//  BSPublicReservation
//
//  Created by 김대호 on 2015. 8. 19..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import Foundation
class FcstDataModel : NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var element = NSString()
    var elements = NSMutableDictionary()
    
    var category = NSMutableString()
    var fcstDate = NSMutableString()
    var fcstTime = NSMutableString()
    var fcstValue = NSMutableString()
    
    func beginParsing(){
        
        
        var date = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        var yearDate : String = formatter.stringFromDate(date)
        formatter.dateFormat = "HH"
        var timeDate : String = formatter.stringFromDate(date)
        if timeDate.toInt() < 2 || timeDate.toInt() >= 23 {
            timeDate = "23"
            yearDate = String(yearDate.toInt()!-1)
        }else if timeDate.toInt() < 5 && timeDate.toInt() >= 2 {
            timeDate = "02"
        }else if timeDate.toInt() < 8 && timeDate.toInt() >= 5 {
            timeDate = "05"
        }else if timeDate.toInt() < 11 && timeDate.toInt() >= 8 {
            timeDate = "08"
        }else if timeDate.toInt() < 14 && timeDate.toInt() >= 11 {
            timeDate = "11"
        }else if timeDate.toInt() < 17 && timeDate.toInt() >= 14 {
            timeDate = "14"
        }else if timeDate.toInt() < 20 && timeDate.toInt() >= 17 {
            timeDate = "17"
        }else if timeDate.toInt() < 23 && timeDate.toInt() >= 20 {
            timeDate = "20"
        }
        timeDate = timeDate + "00"
        
        //   var stringURL = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService/ForecastSpaceData?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&nx=97&ny=74&pageNo=1&numOfRows=224&base_date=20150818&base_time=1100"
        var stringURL = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService/ForecastSpaceData?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&nx=97&ny=74&pageNo=1&numOfRows=224&"
        stringURL += String(format: "base_date=%-12@&base_time=%-12@", yearDate,timeDate)
        
        
        var url = NSURL(string: stringURL)
        
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        element = elementName
        if(elementName as NSString).isEqualToString("item"){
            elements = NSMutableDictionary.alloc()
            elements = [:]
            category = NSMutableString.alloc()
            category = ""
            fcstDate = NSMutableString.alloc()
            fcstDate = ""
            fcstTime = NSMutableString.alloc()
            fcstTime = ""
            fcstValue = NSMutableString.alloc()
            fcstValue = ""
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString("item"){
            if !category.isEqual(nil) {
                elements.setObject(category, forKey: "category")
            }
            if !fcstDate.isEqual(nil) {
                elements.setObject(fcstDate, forKey: "fcstDate")
            }
            if !fcstTime.isEqual(nil) {
                elements.setObject(fcstTime, forKey: "fcstTime")
            }
            if !fcstValue.isEqual(nil) {
                elements.setObject(fcstValue, forKey: "fcstValue")
            }
            posts.addObject(elements)
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if element.isEqualToString("category"){
            category.appendString(string!)
        }else if element.isEqualToString("fcstDate"){
            fcstDate.appendString(string!)
        }else if element.isEqualToString("fcstTime"){
            fcstTime.appendString(string!)
        }else if element.isEqualToString("fcstValue"){
            fcstValue.appendString(string!)
        }
    }
}