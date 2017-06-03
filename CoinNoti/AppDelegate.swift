//
//  AppDelegate.swift
//  CoinNoti
//
//  Created by ftfuture on 2017. 5. 31..
//  Copyright © 2017년 ftfuture. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system().statusItem(withLength:NSVariableStatusItemLength)
    let popover = NSPopover()
    var timer: Timer?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        popover.contentViewController = PopOverViewController(nibName: "PopOverViewController", bundle: nil)
        statusItem.action = #selector(AppDelegate.togglePopover(_:))
        
        var timerInterval = UserDefaults.standard.integer(forKey:"COINNOTIINTERVAL")
        if(timerInterval < 5){ timerInterval = 5 }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval), target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }
    
    func changeTimeInterval(_ sender: AnyObject?) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(UserDefaults.standard.integer(forKey:"COINNOTIINTERVAL")), target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        print("changeTimerInterval : ", UserDefaults.standard.integer(forKey:"COINNOTIINTERVAL"))
    }
    
    func update() {
        var price = String()
        var sourceStr = String()
        let sourceType = UserDefaults.standard.integer(forKey: "COINNOTISOURCE")
        
        if(sourceType == 0) { //Bithumb
            sourceStr = "Bithumb"
            price = coinDataBithumb
        } else if(sourceType == 1){ //Coinone
            sourceStr = "Coinone"
            price = coinDataCoinone
        } else { //Korbit
            sourceStr = "Korbit"
            price = coinDataKorbit
        }
        let titleText = " \(price)"
        statusItem.title = titleText
        
        print("Update - ", sourceStr," ",NSDate(), " ", price)
    }
    
    var coinDataBithumb: String {
        // https://www.bithumb.com/u1/US127
        // https://api.bithumb.com/public/ticker/{currency} - ALL
        /*
         status	결과 상태 코드 (정상 : 0000, 정상이외 코드는 에러 코드 참조)
         opening_price	최근 24시간 내 시작 거래금액
         closing_price	최근 24시간 내 마지막 거래금액
         min_price	최근 24시간 내 최저 거래금액
         max_price	최근 24시간 내 최고 거래금액
         average_price	최근 24시간 내 평균 거래금액
         units_traded	최근 24시간 내 Currency 거래량
         volume_1day	최근 1일간 Currency 거래량
         volume_7day	최근 7일간 Currency 거래량
         buy_price	거래 대기건 최대 구매가
         sell_price	거래 대기건 최소 판매가
         date	현재 시간 Timestamp
         */
        
        var coinStr = ""
        let data = try! String(contentsOf:URL(string:"https://api.bithumb.com/public/ticker/ALL")!, encoding:.utf8).parseJSONString as! NSDictionary?
        
        guard let dictData = data?["data"] as! NSDictionary? else {
            return ""
        }
        
        if(UserDefaults.standard.integer(forKey: "COINNOTIBTCSTATE") == NSOnState){
            guard let btcDict = dictData["BTC"] as! NSDictionary? else {
                return ""
            }
            coinStr += "BTC:"+String(btcDict["sell_price"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTIETHSTATE") == NSOnState){
            guard let ethDict = dictData["ETH"] as! NSDictionary? else {
                return ""
            }
            coinStr += " ETH:"+String(ethDict["sell_price"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTIDASHSTATE") == NSOnState){
            guard let dashDict = dictData["DASH"] as! NSDictionary? else {
                return ""
            }
            coinStr += " DASH:"+String(dashDict["sell_price"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTILTCSTATE") == NSOnState){
            guard let ltcDict = dictData["LTC"] as! NSDictionary? else {
                return ""
            }
            coinStr += " LTC:"+String(ltcDict["sell_price"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTIETCSTATE") == NSOnState){
            guard let etcDict = dictData["ETC"] as! NSDictionary? else {
                return ""
            }
            coinStr += " ETC:"+String(etcDict["sell_price"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTIXRPSTATE") == NSOnState){
            guard let xrpDict = dictData["XRP"] as! NSDictionary? else {
                return ""
            }
            coinStr += " XRP:"+String(xrpDict["sell_price"] as! String)
        }
        
        return coinStr as String!
    }
    
    var coinDataCoinone: String {
        // http://doc.coinone.co.kr/#api-Public-Ticker
        // https://api.coinone.co.kr/ticker/?currency=all&format=json
        
        var coinStr = ""
        let data = try! String(contentsOf:URL(string:"https://api.coinone.co.kr/ticker/?currency=all&format=json")!, encoding:.utf8).parseJSONString as! NSDictionary?
        
        if(UserDefaults.standard.integer(forKey: "COINNOTIBTCSTATE") == NSOnState){
            guard let btcDict = data?["btc"] as! NSDictionary? else {
                return ""
            }
            coinStr += "BTC:"+String(btcDict["last"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTIETHSTATE") == NSOnState){
            guard let ethDict = data?["eth"] as! NSDictionary? else {
                return ""
            }
            coinStr += " ETH:"+String(ethDict["last"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTIETCSTATE") == NSOnState){
            guard let etcDict = data?["etc"] as! NSDictionary? else {
                return ""
            }
            coinStr += " ETC:"+String(etcDict["last"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTIXRPSTATE") == NSOnState){
            guard let xrpDict = data?["xrp"] as! NSDictionary? else {
                return ""
            }
            coinStr += " XRP:"+String(xrpDict["last"] as! String)
        }
        
        return coinStr as String!
    }
    
    var coinDataKorbit: String {
        //https://apidocs.korbit.co.kr/#detailed-ticker
        //https://api.korbit.co.kr/v1/ticker?currency_pair=eth_krw
        
        var coinStr = ""
        
        if(UserDefaults.standard.integer(forKey: "COINNOTIBTCSTATE") == NSOnState){
            let data = try! String(contentsOf:URL(string:"https://api.korbit.co.kr/v1/ticker?currency_pair=btc_krw")!, encoding:.utf8).parseJSONString as! NSDictionary?
            coinStr += "BTC:"+String(data?["last"] as! String)
        }
        if(UserDefaults.standard.integer(forKey: "COINNOTIETHSTATE") == NSOnState){
            let data = try! String(contentsOf:URL(string:"https://api.korbit.co.kr/v1/ticker?currency_pair=eth_krw")!, encoding:.utf8).parseJSONString as! NSDictionary?
            coinStr += "ETH:"+String(data?["last"] as! String)
        }
        
        return coinStr as String!
    }
    
    func showPopover(_ sender: AnyObject?){
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}


extension String
{
    var parseJSONString: AnyObject?
    {
        let data = self.data(using:.utf8, allowLossyConversion: false)
        
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                if let jsonResult = message as? NSMutableArray {
                    return jsonResult //Will return the json array output
                } else if let jsonResult = message as? NSMutableDictionary {
                    return jsonResult //Will return the json dictionary output
                } else {
                    return nil
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}



