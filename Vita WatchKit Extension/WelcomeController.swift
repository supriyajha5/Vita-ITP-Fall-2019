//
//  WelcomeController.swift
//  Vita WatchKit Extension
//
//  Created by Mohith Damarapati on 11/29/19.
//  Copyright © 2019 New York University. All rights reserved.
//

import WatchKit
import Foundation
import SQLite3

class WelcomeController: WKInterfaceController {

    @IBOutlet weak var bp: WKInterfaceLabel!
    @IBOutlet weak var bpm: WKInterfaceLabel!
    @IBOutlet weak var bloodPre: WKInterfaceLabel!
    @IBOutlet weak var displayMsg: WKInterfaceLabel!
    @IBOutlet weak var mode: WKInterfaceLabel!
    @IBOutlet weak var heartBeat: WKInterfaceLabel!
    
    var listOfBPs = [Int]()
    var listOfHBs = [Int]()
    var ind = Int()
    var timer:Timer = Timer()
    var sensing:Bool = false
    var contextPass = ["Normal", "0", "0"]
    
    var db: OpaquePointer? = nil
    
    func openDatabase() -> OpaquePointer? {
             let dbPath = "/Users/md4289/Desktop/ITP/NYU_Meyers/webapp/site.db"
             if sqlite3_open(dbPath, &db) == SQLITE_OK {
               print("Successfully opened connection to database at \(dbPath)")
               return db
             } else {
               print("Unable to open database. Verify that you created the directory described " +
                 "in the Getting Started section.")
               return nil
             }
             
    }
    
    func query(db: OpaquePointer?) {
      let queryStatementString = "SELECT * FROM User;"
      var queryStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        if sqlite3_step(queryStatement) == SQLITE_ROW {
          let id = sqlite3_column_int(queryStatement, 0)
          let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
          let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
          let name = String(cString: queryResultCol1!)
          let name2 = String(cString: queryResultCol2!)
          print("Query Result:")
          print("\(id) | \(name) | \(name2)" )

        } else {
          print("Query returned no results")
        }
      } else {
        print("SELECT statement could not be prepared")
      }

      // 6
      sqlite3_finalize(queryStatement)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let db = openDatabase()
        
        query(db: db)
        if let modeVal = context as? [String] {
            mode.setText(modeVal[0])
            contextPass = modeVal
            if (modeVal[0] == "Normal") {
                displayMsg.setText("Have a nice day!")
            }
            if (modeVal[0] == "Sleep") {
                displayMsg.setText("Good Night!")
            }
            if (modeVal[0] == "Sports") {
                displayMsg.setText("Enjoy the game!")
            }
            bloodPre.setText(modeVal[1])
            heartBeat.setText(modeVal[2])
        }
    
        for _ in 1...100 {
            listOfBPs.append(Int.random(in: 90..<120))
            listOfHBs.append(Int.random(in: 60..<120))
        }
        ind = 0
        readyValues()
    }
    
     func readyValues() {
        if sensing {
            timer.invalidate()
            sensing = false
        } else if !sensing {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getValues), userInfo: nil, repeats: true)
            sensing = true
        }
    }
    
    @objc func getValues() {
        ind += 1
        if ind < 99 {
            bloodPre.setText(String(listOfBPs[ind]))
            heartBeat.setText(String(listOfHBs[ind]))
            if listOfHBs[ind] > 105 {
                self.popToRootController()
                pushController(withName: "OpticIllusionController", context: contextPass)
                timer.invalidate()
                sensing = false
            }
        } else {
            sensing = true
        }
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
