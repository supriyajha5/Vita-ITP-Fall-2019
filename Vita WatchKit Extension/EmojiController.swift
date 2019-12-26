//
//  EmojiController.swift
//  Vita WatchKit Extension
//
//  Created by Mohith Damarapati on 11/29/19.
//  Copyright © 2019 New York University. All rights reserved.
//

import WatchKit
import Foundation
import SQLite3

class EmojiController: WKInterfaceController {

    @IBOutlet weak var swipeVideosR: WKSwipeGestureRecognizer!
    @IBOutlet weak var swipeVideos: WKSwipeGestureRecognizer!
    @IBOutlet weak var video: WKInterfaceMovie!
    @IBOutlet weak var done: WKInterfaceButton!
    var nextStage = false
    var swipeCount = 1
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
    
    func insert(db: OpaquePointer?, hb: Int, bp: Int) {
      let insertStatementString = "INSERT INTO anxiety_data (time, heartbeat, bp, level, location, user_id) VALUES (datetime('now','localtime'), '" + String(hb) + "', '" + String(bp) + "', '2', 'Courant Institute', 1);"
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
        // Configure interface objects here.
        if let modeVal = context as? [String] {
            contextPass = modeVal
        }
        done.setEnabled(false)
        let url = Bundle.main.url(forResource: "got",
        withExtension: "mov")
        video.setPosterImage(WKImage(imageName: "postergot"))
        video.setMovieURL(url!)
        DispatchQueue.global(qos: .userInteractive).async {
            sleep(5)
            let db = self.openDatabase()
            let bp = Int.random(in: 90..<120)
            let hb = Int.random(in: 60..<120)
            if bp>100 || hb>80 {
                self.insert(db: db, hb: hb, bp: bp)
                self.done.setTitle("Play Game")
                self.done.setEnabled(true)
                self.nextStage = true
            } else {
                self.done.setTitle("Well Done")
                self.done.setEnabled(true)
            }
        }
    }
    
    @IBAction func swipeNext(_ sender: Any) {
        if swipeCount == 1 {
            let url = Bundle.main.url(forResource: "movieclip",
            withExtension: "mov")
            video.setPosterImage(WKImage(imageName: "forest"))
            video.setMovieURL(url!)
            swipeCount += 1
        } else if swipeCount == 2 {
            let url = Bundle.main.url(forResource: "gotbloop",
            withExtension: "mov")
            video.setPosterImage(WKImage(imageName: "gotblooppos"))
            video.setMovieURL(url!)
            swipeCount += 1
        } else if swipeCount == 3 {
            let url = Bundle.main.url(forResource: "ysheldon",
            withExtension: "mov")
            video.setPosterImage(WKImage(imageName: "ysheldonpos"))
            video.setMovieURL(url!)
            swipeCount += 1
        }
    }
    
    @IBAction func swipePrev(_ sender: Any) {
        if swipeCount == 4 {
            let url = Bundle.main.url(forResource: "gotbloop",
            withExtension: "mov")
            video.setPosterImage(WKImage(imageName: "gotblooppos"))
            video.setMovieURL(url!)
            swipeCount -= 1
        } else if swipeCount == 3 {
            let url = Bundle.main.url(forResource: "movieclip",
            withExtension: "mov")
            video.setPosterImage(WKImage(imageName: "forest"))
            video.setMovieURL(url!)
            swipeCount -= 1
        } else if swipeCount == 2 {
            let url = Bundle.main.url(forResource: "got",
            withExtension: "mov")
            video.setPosterImage(WKImage(imageName: "postergot"))
            video.setMovieURL(url!)
            swipeCount -= 1
        }
    }
    
    @IBAction func goBack() {
        if nextStage == false {
            self.popToRootController()
            pushController(withName: "WelcomeController", context: contextPass)
        } else {
            self.popToRootController()
            pushController(withName: "TicTacToeController", context: contextPass)
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
