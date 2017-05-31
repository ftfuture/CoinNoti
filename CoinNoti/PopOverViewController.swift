//
//  PopOverViewController.swift
//  CoinNoti
//
//  Created by ftfuture on 2017. 5. 31..
//  Copyright © 2017년 ftfuture. All rights reserved.
//

import Cocoa

class PopOverViewController: NSViewController {
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    @IBOutlet var intervalBtn: NSPopUpButton!
    @IBOutlet var btcBtn: NSButton!
    @IBOutlet var ethBtn: NSButton!
    @IBOutlet var dashBtn: NSButton!
    @IBOutlet var ltcBtn: NSButton!
    @IBOutlet var etcBtn: NSButton!
    @IBOutlet var quitBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intervalBtn.removeAllItems()
        intervalBtn.addItem(withTitle: "5 second")
        intervalBtn.addItem(withTitle: "10 second")
        intervalBtn.addItem(withTitle: "15 second")
        
        intervalBtn.selectItem(at: Int(UserDefaults.standard.double(forKey: "COINNOTIINTERVAL"))/5-1)
        btcBtn.state = UserDefaults.standard.integer(forKey: "COINNOTIBTCSTATE")
        ethBtn.state = UserDefaults.standard.integer(forKey: "COINNOTIETHSTATE")
        dashBtn.state = UserDefaults.standard.integer(forKey: "COINNOTIDASHSTATE")
        ltcBtn.state = UserDefaults.standard.integer(forKey: "COINNOTILTCSTATE")
        etcBtn.state = UserDefaults.standard.integer(forKey: "COINNOTIETCSTATE")
    }
    
    @IBAction func updateIntervalTime(sender: NSButton) {
        print("updateIntervalTime ", intervalBtn.selectedItem?.description ?? "")
        if( sender != intervalBtn) {
         return
        }
        
        switch(intervalBtn.indexOfSelectedItem) {
        case 0: UserDefaults.standard.set(5.0, forKey: "COINNOTIINTERVAL")
            break
        case 1: UserDefaults.standard.set(10.0, forKey: "COINNOTIINTERVAL")
            break
        case 2: UserDefaults.standard.set(15.0, forKey: "COINNOTIINTERVAL")
            break
        default:
            break
        }

        appDelegate.changeTimeInterval(self)
    }
    
    @IBAction func updateCoinCheckState(sender: NSButton) {
        print(updateCoinCheckState)
        switch(sender){
        case btcBtn: print("btcBtn")
        UserDefaults.standard.set(btcBtn.state, forKey:"COINNOTIBTCSTATE")
        break
        case ethBtn: print("ethBtn")
        UserDefaults.standard.set(ethBtn.state, forKey:"COINNOTIETHSTATE")
        break
        case dashBtn: print("dashBtn")
        UserDefaults.standard.set(dashBtn.state, forKey:"COINNOTIDASHSTATE")
        break
        case ltcBtn: print("ltcBtn")
        UserDefaults.standard.set(ltcBtn.state, forKey:"COINNOTILTCSTATE")
        break
        case etcBtn: print("etcBtn")
        UserDefaults.standard.set(etcBtn.state, forKey:"COINNOTIETCSTATE")
        break
        default:
            break
        }
    }
    
    @IBAction func quitCoinNoti(sender: NSButton) {
        NSApplication.shared().terminate(sender)
    }
    
}
