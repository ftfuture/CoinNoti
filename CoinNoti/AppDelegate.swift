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
        if(UserDefaults.standard.integer(forKey:"COINNOTIINTERVAL")==0){
            UserDefaults.standard.set(5, forKey:"COINNOTIINTERVAL")
            UserDefaults.standard.set(NSOnState, forKey: "COINNOTIETHSTATE")
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(UserDefaults.standard.integer(forKey:"COINNOTIINTERVAL")), target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }
    func changeTimeInterval(_ sender: AnyObject?) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(UserDefaults.standard.integer(forKey:"COINNOTIINTERVAL")), target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        print("changeTimerInterval : ", UserDefaults.standard.integer(forKey:"COINNOTIINTERVAL"))
    }
    
    func update() {
        let price = coinData
        let titleText = " \(price)"
        statusItem.title = titleText
        
        print("Update - ",NSDate(), " ", price)
    }
    
    var coinData: String {
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



