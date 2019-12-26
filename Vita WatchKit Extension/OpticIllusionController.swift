//
//  OpticIllusionController.swift
//  Vita WatchKit Extension
//
//  Created by Mohith Damarapati on 11/30/19.
//  Copyright © 2019 New York University. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation
import SQLite3

class OpticIllusionController: WKInterfaceController {

    @IBOutlet weak var playVisuals: WKInterfaceButton!
    @IBOutlet weak var illusion: WKInterfaceImage!
    var nextStage = false
    var cat: UIImage = #imageLiteral(resourceName: "grid")
    var contextPass = ["Normal", "0", "0"]
    var playerItem: AVPlayerItem?
    var player:AVPlayer?
    
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
    
    func insert(db: OpaquePointer?, hb: Int, bp: Int) {
      let insertStatementString = "INSERT INTO anxiety_data (time, heartbeat, bp, level, location, user_id) VALUES (datetime('now','localtime'), '" + String(hb) + "', '" + String(bp) + "', '1', 'Courant Institute Library', 1);"
      var insertStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
        if sqlite3_step(insertStatement) == SQLITE_DONE {
          print("Successfully inserted row.")
        } else {
          print("Could not insert row.")
        }
      } else {
        print("INSERT statement could not be prepared.")
      }
      sqlite3_finalize(insertStatement)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let url = Bundle.main.url(forResource: "musicclip",
        withExtension: "mp3")
        playerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem!)
        player?.play()
        
        if let modeVal = context as? [String] {
            contextPass = modeVal
        }
        playVisuals.setEnabled(false)
        illusion.setImage(cat)
        DispatchQueue.global(qos: .userInteractive).async {
            sleep(5)
            let db = self.openDatabase()
            let bp = Int.random(in: 90..<120)
            let hb = Int.random(in: 60..<120)
            if bp>100 || hb>80 {
                self.insert(db: db, hb: hb, bp: bp)
                self.playVisuals.setTitle("Play Visuals")
                self.playVisuals.setEnabled(true)
                self.nextStage = true
            } else {
                self.playVisuals.setTitle("Well Done")
                self.playVisuals.setEnabled(true)
            }
        }
        // Configure interface objects here.
    }
    
    @IBAction func goBack() {
        if nextStage == false {
            self.popToRootController()
            pushController(withName: "WelcomeController", context: contextPass)
        } else {
            self.popToRootController()
            pushController(withName: "EmojiController", context: contextPass)
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
