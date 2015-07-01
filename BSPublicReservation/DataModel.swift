//
//  DataModel.swift
//  BSPublicReservation
//
//  Created by IT on 2015. 4. 28..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import Foundation

class DataModel : NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var startDate = NSMutableString()
    var endDate = NSMutableString()
    var serialID = NSMutableString()
    
    func beginParsing(tag : String ,timeInt : Int){
        posts = []
        var stringURL : String = ""
        
        
        if tag == "FESTIVAL" {
            stringURL = "http://tourapi.busan.go.kr/openapi/service/CultureInfoService/getFestivalList?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&date_yyyymm="
            //FestivalList
        }else if tag == "MUSICAL" {
            stringURL = "http://tourapi.busan.go.kr/openapi/service/CultureInfoService/getMusicalList?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&date_yyyymm="
            //MusicalList
        }else if tag == "MUSICDANCE" {
            stringURL = "http://tourapi.busan.go.kr/openapi/service/CultureInfoService/getMusicDanceList?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&date_yyyymm="
            //MusicDance
        }else if tag == "EXHIBIT" {
            stringURL = "http://tourapi.busan.go.kr/openapi/service/CultureInfoService/getExhibitList?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&date_yyyymm="
        }
        
        stringURL = stringURL + String(timeInt)
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
            title1 = NSMutableString.alloc()
            title1 = ""
            startDate = NSMutableString.alloc()
            startDate = ""
            endDate = NSMutableString.alloc()
            endDate = ""
            serialID = NSMutableString.alloc()
            serialID = ""
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title")
            }
            if !startDate.isEqual(nil) {
                elements.setObject(startDate, forKey: "startDate")
            }
            if !endDate.isEqual(nil) {
                elements.setObject(endDate, forKey: "endDate")
            }
            if !serialID.isEqual(nil) {
                elements.setObject(serialID, forKey: "serialID")
            }
            posts.addObject(elements)
        }
       
    }
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if element.isEqualToString("dataTitle"){
            title1.appendString(string!)
        }else if element.isEqualToString("startDate"){
            let newString = string!.stringByReplacingOccurrencesOfString("-", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
            startDate.appendString(newString)
        }else if element.isEqualToString("endDate"){
            let newString = string!.stringByReplacingOccurrencesOfString("-", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
            endDate.appendString(newString)
        }else if element.isEqualToString("dataSid"){
            serialID.appendString(string!)
        }
    }
}