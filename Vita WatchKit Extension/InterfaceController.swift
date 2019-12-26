//
//  InterfaceController.swift
//  Vita WatchKit Extension
//
//  Created by Mohith Damarapati on 11/29/19.
//  Copyright © 2019 New York University. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var normal: WKInterfaceButton!
    @IBOutlet weak var sports: WKInterfaceButton!
    @IBOutlet weak var sleep: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
    }
    
    @IBAction func onClickNormal() {
        pushController(withName: "WelcomeController", context: ["Normal", "0", "0"])
    }
    
    @IBAction func onClickSports() {
        pushController(withName: "WelcomeController", context: ["Sports", "0", "0"])
    }
    
    @IBAction func onClickSleep() {
           pushController(withName: "WelcomeController", context: ["Sleep", "0", "0"])
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
