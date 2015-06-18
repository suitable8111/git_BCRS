//
//  DetailDataModel.swift
//  BSPublicReservation
//
//  Created by IT on 2015. 4. 29..
//  Copyright (c) 2015년 KimDaeho. All rights reserved.
//

import Foundation

class DetailDataModel : NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title = NSMutableString()
    var place = NSMutableString()
    var phoneNum = NSMutableString()
    var homePage = NSMutableString()
    var context = NSMutableString()
    var latitude = NSMutableString()
    var longitude = NSMutableString()
    var time = NSMutableString()
    var period = NSMutableString()
    
    
    func beginParsing(tag : String, dataSid : String){
        posts = []
        var stringURL : String = ""
        if tag == "FESTIVAL" {
            stringURL = "http://tourapi.busan.go.kr/openapi/service/CultureInfoService/getFestivalDetail?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&data_sid="
        }
        if tag == "MUSICAL" {
            stringURL = "http://tourapi.busan.go.kr/openapi/service/CultureInfoService/getMusicalDetail?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&data_sid="
        }
        if tag == "MUSICDANCE" {
            stringURL = "http://tourapi.busan.go.kr/openapi/service/CultureInfoService/getMusicDanceDetail?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&data_sid="
        }
        if tag == "EXHIBIT" {
            stringURL = "http://tourapi.busan.go.kr/openapi/service/CultureInfoService/getExhibitDetail?ServiceKey=1T5r8Mn4gUBzHPOVIwQRko%2FeS%2BueuuEIstpSLA%2BKYh1CO8UfnXjTkpNPonuRL0G16faoatKk5mbWZqJMrwJViw%3D%3D&data_sid="
        }
        
        stringURL = stringURL + dataSid
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
            title = NSMutableString.alloc()
            title = ""
            place = NSMutableString.alloc()
            place = ""
            phoneNum = NSMutableString.alloc()
            phoneNum = ""
            homePage = NSMutableString.alloc()
            homePage = ""
            context = NSMutableString.alloc()
            context = ""
            latitude = NSMutableString.alloc()
            latitude = ""
            longitude = NSMutableString.alloc()
            longitude = ""
            time = NSMutableString.alloc()
            time = ""
            period = NSMutableString.alloc()
            period = ""
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString("item"){
            if !title.isEqual(nil){
                elements.setObject(title, forKey: "title")
            }
            if !place.isEqual(nil){
                elements.setObject(place, forKey: "place")
            }
            if !phoneNum.isEqual(nil){
                elements.setObject(phoneNum, forKey: "phoneNum")
            }
            if !homePage.isEqual(nil){
                elements.setObject(homePage, forKey: "homePage")
            }
            if !context.isEqual(nil){
                elements.setObject(context, forKey: "context")
            }
            if !latitude.isEqual(nil){
                elements.setObject(latitude, forKey: "latitude")
            }
            if !longitude.isEqual(nil){
                elements.setObject(longitude, forKey: "longitude")
            }
            if !time.isEqual(nil){
                elements.setObject(time, forKey: "time")
            }
            if !period.isEqual(nil){
                elements.setObject(period, forKey: "period")
            }
        }
        //posts.addObject(elements)
        //println(elements)
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if element.isEqualToString("dataTitle"){
            title.appendString(string!)
        }
        if element.isEqualToString("place"){
            place.appendString(string!)
        }
        if element.isEqualToString("tel"){
            phoneNum.appendString(string!)
        }
        if element.isEqualToString("userHomepage"){
            homePage.appendString(string!)
        }
        if element.isEqualToString("dataContent"){
            context.appendString(string!)
        }
        if element.isEqualToString("wgsx"){
            latitude.appendString(string!)
        }
        if element.isEqualToString("wgsy"){
            longitude.appendString(string!)
        }
        if element.isEqualToString("time"){
            time.appendString(string!)
        }
        if element.isEqualToString("useperiod"){
            period.appendString(string!)
        }

        
    }
}