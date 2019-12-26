//
//  TicTacToeController.swift
//  Vita WatchKit Extension
//
//  Created by Mohith Damarapati on 11/30/19.
//  Copyright © 2019 New York University. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation
import SQLite3

class TicTacToeController: WKInterfaceController {
    
    @IBOutlet weak var boardG1: WKInterfaceGroup!
    @IBOutlet weak var boardG2: WKInterfaceGroup!
    @IBOutlet weak var boardG3: WKInterfaceGroup!
    
    @IBOutlet weak var b11: WKInterfaceButton!
    @IBOutlet weak var b12: WKInterfaceButton!
    @IBOutlet weak var b13: WKInterfaceButton!
    
    @IBOutlet weak var b21: WKInterfaceButton!
    @IBOutlet weak var b22: WKInterfaceButton!
    @IBOutlet weak var b23: WKInterfaceButton!
    
    @IBOutlet weak var b31: WKInterfaceButton!
    @IBOutlet weak var b32: WKInterfaceButton!
    @IBOutlet weak var b33: WKInterfaceButton!
    
    @IBOutlet weak var play: WKInterfaceButton!
    @IBOutlet weak var result: WKInterfaceLabel!
    
    var board: [[Int]] = [[-1,-1,-1], [-1,-1,-1], [-1,-1,-1]]
    var player: Int = 0
    var human: UIImage = #imageLiteral(resourceName: "dany")
    var computer: UIImage = #imageLiteral(resourceName: "arya")
    var blank: UIImage = #imageLiteral(resourceName: "white")
    
    var nextStage = 1
    var contextPass = ["Normal", "0", "0"]
    var playerItem: AVPlayerItem?
    var mplayer:AVPlayer?
    
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
        let insertStatementString = "INSERT INTO anxiety_data (time, heartbeat, bp, level, location, user_id) VALUES (datetime('now','localtime'), '" + String(hb) + "', '" + String(bp) + "', '3', 'Courant Institute', 1);"
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
    
    private func resetBoard() {
        for i in 0...2 {
            for j in 0...2 {
                board[i][j] = -1
            }
        }
        b11.setBackgroundImage(blank); b11.setEnabled(true)
        b12.setBackgroundImage(blank); b12.setEnabled(true)
        b13.setBackgroundImage(blank); b13.setEnabled(true)
        b21.setBackgroundImage(blank); b21.setEnabled(true)
        b22.setBackgroundImage(blank); b22.setEnabled(true)
        b23.setBackgroundImage(blank); b23.setEnabled(true)
        b31.setBackgroundImage(blank); b31.setEnabled(true)
        b32.setBackgroundImage(blank); b32.setEnabled(true)
        b33.setBackgroundImage(blank); b33.setEnabled(true)
        
        result.setText("")
    }
    
    private func disableGame() {
        b11.setEnabled(false)
        b12.setEnabled(false)
        b13.setEnabled(false)
        b21.setEnabled(false)
        b22.setEnabled(false)
        b23.setEnabled(false)
        b31.setEnabled(false)
        b32.setEnabled(false)
        b33.setEnabled(false)
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let modeVal = context as? [String] {
            contextPass = modeVal
        }
        let url = Bundle.main.url(forResource: "musicclip",
               withExtension: "mp3")
       playerItem = AVPlayerItem(url: url!)
       mplayer = AVPlayer(playerItem: playerItem!)
       
       mplayer?.play()
        DispatchQueue.global(qos: .userInteractive).async {
                   sleep(15)
                   let db = self.openDatabase()
                   let bp = Int.random(in: 90..<120)
                   let hb = Int.random(in: 60..<120)
                   if bp>100 || hb>80 {
                       self.insert(db: db, hb: hb, bp: bp)
                       self.play.setTitle("Go Home")
                       self.play.setEnabled(true)
                       self.nextStage = 2
                   } else {
                       self.play.setTitle("Well Done")
                       self.play.setEnabled(true)
                       self.nextStage = 3
                   }
        }
        resetBoard()
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func gameOver()  {
        
        for i in 0...2 {
            if board[i][0] == board[i][1] && board[i][1] == board[i][2] {
                if board[i][0] == 0 {
                    result.setText("You Won :)")
                    disableGame()
                    return
                }
                if board[i][0] == 1 {
                    result.setText("Try Again :(")
                    disableGame()
                    return
                }
            }
        }
        
        for i in 0...2 {
           if board[0][i] == board[1][i] && board[1][i] == board[2][i] {
               if board[0][i] == 0 {
                   result.setText("You Won :)")
                   disableGame()
                   return
               }
               if board[0][i] == 1 {
                   result.setText("Try Again :(")
                   disableGame()
                   return
               }
           }
        }
        
        if (board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
            if (board[0][0] == 0) {
                result.setText("You Won :)")
                disableGame()
                return
            }
            if board[0][0] == 1 {
                result.setText("Try Again :(")
                disableGame()
                return
            }
        }
        
        if (board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
            if (board[0][2] == 0) {
                result.setText("You Won :)")
                disableGame()
                return
            }
            if board[0][2] == 1 {
                result.setText("Try Again :(")
                disableGame()
                return
            }
        }
        
        for i in 0...2 {
            for j in 0...2 {
                if board[i][j] == -1 {
                    return
                }
            }
        }
        
        result.setText("Game Draw")
    }
    
    private func setComputerTurn(x: Int, y: Int) {
        if x == 0 && y == 0 {
            b11.setBackgroundImage(computer)
            b11.setEnabled(false)
        }
        if x == 0 && y == 1 {
            b12.setBackgroundImage(computer)
            b12.setEnabled(false)
        }
        if x == 0 && y == 2 {
            b13.setBackgroundImage(computer)
            b13.setEnabled(false)
        }
        if x == 1 && y == 0 {
            b21.setBackgroundImage(computer)
            b21.setEnabled(false)
        }
        if x == 1 && y == 1 {
            b22.setBackgroundImage(computer)
            b22.setEnabled(false)
        }
        if x == 1 && y == 2 {
            b23.setBackgroundImage(computer)
            b23.setEnabled(false)
        }
        if x == 2 && y == 0 {
            b31.setBackgroundImage(computer)
            b31.setEnabled(false)
        }
        if x == 2 && y == 1 {
            b32.setBackgroundImage(computer)
            b32.setEnabled(false)
        }
        if x == 2 && y == 2 {
            b33.setBackgroundImage(computer)
            b33.setEnabled(false)
        }
    }
    
    private func computerTurn(){
        var emptyCells:[(xIndex: Int, yIndex: Int)] = []
        for i in 0...2 {
            for j in 0...2 {
                if board[i][j] == -1 {
                    emptyCells.append((xIndex: i, yIndex: j))
                }
            }
        }
        if emptyCells.count == 0 {
            gameOver()
        } else {
            let randomCell = emptyCells.randomElement()
            board[randomCell?.xIndex ?? 0][randomCell?.yIndex ?? 0] = 1
            setComputerTurn(x: randomCell?.xIndex ?? 0, y: randomCell?.yIndex ?? 0)
        }
    }
    
    @IBAction func onClickResetBoard() {
        if nextStage == 1 {
             resetBoard()
        } else if nextStage == 3 {
             self.popToRootController()
             pushController(withName: "WelcomeController", context: contextPass)
        } else if nextStage == 2 {
             self.popToRootController()
             pushController(withName: "GoHomeController", context: nil)
        }
    }
    
    @IBAction func onClickCell11() {
        b11.setBackgroundImage(human)
        b11.setEnabled(false)
        board[0][0] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
    
    @IBAction func onClickCell12() {
        b12.setBackgroundImage(human)
        b12.setEnabled(false)
        board[0][1] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
    
    @IBAction func onClickCell13() {
        b13.setBackgroundImage(human)
        b13.setEnabled(false)
        board[0][2] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
    
    @IBAction func onClickCell21() {
        b21.setBackgroundImage(human)
        b21.setEnabled(false)
        board[1][0] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
    
    @IBAction func onClickCell22() {
        b22.setBackgroundImage(human)
        b22.setEnabled(false)
        board[1][1] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
    
    @IBAction func onClickCell23() {
        b23.setBackgroundImage(human)
        b23.setEnabled(false)
        board[1][2] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
    
    @IBAction func onClickCell31() {
        b31.setBackgroundImage(human)
        b31.setEnabled(false)
        board[2][0] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
    
    @IBAction func onClickCell32() {
        b32.setBackgroundImage(human)
        b32.setEnabled(false)
        board[2][1] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
    
    @IBAction func onClickCell33() {
        b33.setBackgroundImage(human)
        b33.setEnabled(false)
        board[2][2] = 0
        DispatchQueue.global(qos: .userInteractive).async {
            usleep(200000)
            self.gameOver()
            self.computerTurn()
            self.gameOver()
        }
    }
}

