//
//  ViewController.swift
//  flipTacToe
//
//  Created by Jantzen Lee on 5/10/18.
//  Copyright © 2018 Jantzen Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var playerTurn: Bool = true
    let GravDirection = ["Down","Right","Up","Left"]
    var Direction = 0
    var BoardArray = Array(repeating: Array(repeating: 0, count: 7), count: 7)
    var PointArray = Array(repeating: Array(repeating: 0, count: 7), count: 7)
    var XCount: Int = 0
    var YCount: Int = 0
    var counter: Int = 1
    var sign = 1 //Determines the display according to which player makes the move
    var triggerCount: Int = 0
    let colorRed = UIColor(red: 1, green:0, blue: 0, alpha: 1)
    let colorBlack = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    var location = 0
    var qCounter = 0
    var checkCount = 0
    
    @IBOutlet weak var DebugLabel: UILabel!
    
    @IBOutlet var Squares: [UILabel]!
    @IBOutlet weak var GravityDirectionLabel: UILabel!
    @IBOutlet weak var PlayerTurnLabel: UILabel!
    
    
    @IBAction func RotateCCW(_ sender: UIButton)
    {
        if (Direction < 3) { Direction = Direction+1}
        else {Direction = 0}
        RunGame()
    }
    
    @IBAction func RotateCW(_ sender: UIButton)
    {
        if (Direction > 0) { Direction = Direction-1}
        else {Direction = 3}
        RunGame()
    }
    
    @IBAction func ResetButton(_ sender: UIButton)
    {
        counter = 1
        XCount = 0
        YCount = 0
        
        while counter <= 49
        {
            Squares[counter - 1].textColor = colorBlack
            BoardArray[XCount][YCount] = 0
            YCount = YCount + 1
            
            if YCount > 6
            {
                YCount = 0
                XCount = XCount+1
            }
            counter = counter+1
        }
        Direction = 0
        RunGame()
        playerTurn = true
        PlayerTurnLabel.text = "Player 1"
    }

    @IBAction func TopButton(_ sender: UIButton) {
        if Direction == 0 && BoardArray[sender.tag - 1] [6] == 0
        {
            BoardArray[sender.tag - 1] [6] = sign
            RunGame()
        }
    }
    
    @IBAction func LeftButton(_ sender: UIButton) {
        if Direction == 1 && BoardArray[0] [sender.tag - 1] == 0
        {
            BoardArray[0] [sender.tag - 1] = sign
            RunGame()
        }
    }
    
    @IBAction func BottomButton(_ sender: UIButton) {
        if Direction == 2 && BoardArray[sender.tag - 1] [0] == 0
        {
            BoardArray[sender.tag - 1] [0] = sign
            RunGame()
        }
    }
    
    @IBAction func RightButton(_ sender: UIButton) {
        if Direction == 3 && BoardArray[6] [sender.tag - 1] == 0
        {
            BoardArray[6] [sender.tag - 1] = sign
            RunGame()
        }
    }
    
    func RunGame()
    {
        RunGravity()
        ChangeSquares()
        CheckForPoints()
        playerTurn = !playerTurn
        if playerTurn
        {
            PlayerTurnLabel.text = "Player 1"
            sign = 1
        }
        else
        {
            PlayerTurnLabel.text = "Player 2"
            sign = -1
        }
        GravityDirectionLabel.text = GravDirection[Direction]
    } // End RunGame()
    
    func ChangeSquares()
    {
        XCount = 0
        YCount = 0
        counter  = 1
        
        while counter <= 49
        {
            switch BoardArray[XCount][YCount]{
            case 1:
                Squares[counter - 1].text = "O"
            case -1:
                Squares[counter - 1].text = "X"
            default:
                Squares[counter - 1].text = "  "
            }
            
            counter = counter + 1
            XCount = XCount + 1
            if XCount > 6
            {
                XCount = 0
                YCount = YCount + 1
            }
        }
    }
    
    func RunGravity()
    {
        counter = 1
        triggerCount = 0
        switch Direction
        {
        case 0: // Gravity Down
            XCount = 0
            YCount = 0
            while counter <= 49
            {
                if BoardArray[XCount][YCount] != 0
                {
                    if triggerCount != YCount
                    {
                        BoardArray[XCount][triggerCount] = BoardArray[XCount][YCount]
                        BoardArray[XCount][YCount] = 0
                    }
                    triggerCount = triggerCount + 1
                }
                YCount = YCount + 1
                
                if YCount > 6
                {
                    YCount = 0
                    XCount = XCount+1
                    triggerCount = 0
                }
                counter = counter+1
            }
        case 1: //Gravity Right
            XCount = 6
            YCount = 0
            while counter <= 49
            {
                if BoardArray[XCount][YCount] != 0{
                    if triggerCount != (6-XCount){
                        BoardArray[6-triggerCount][YCount] = BoardArray[XCount][YCount]
                        BoardArray[XCount][YCount] = 0
                    }
                    triggerCount = triggerCount + 1
                }
                XCount = XCount - 1
                
                if XCount < 0{
                    XCount = 6
                    YCount = YCount+1
                    triggerCount = 0
                }
                counter = counter+1
            }
        case 2: //Gravity Up
            XCount = 0
            YCount = 6
            while counter <= 49
            {
                if BoardArray[XCount][YCount] != 0
                {
                    if triggerCount != (6-YCount)
                    {
                        BoardArray[XCount][6-triggerCount] = BoardArray[XCount][YCount]
                        BoardArray[XCount][YCount] = 0
                    }
                    triggerCount = triggerCount + 1
                }
                YCount = YCount - 1
                
                if YCount < 0
                {
                    YCount = 6
                    XCount += 1
                    triggerCount = 0
                }
                counter += 1
            }
        case 3: //Gravity Left
            XCount = 0
            YCount = 0
            while counter <= 49
            {
                if BoardArray[XCount][YCount] != 0
                {
                    if triggerCount != (XCount)
                    {
                        BoardArray[triggerCount][YCount] = BoardArray[XCount][YCount]
                        BoardArray[XCount][YCount] = 0
                    }
                    triggerCount += 1
                }
                XCount = XCount + 1
                
                if XCount > 6
                {
                    XCount = 0
                    YCount += 1
                    triggerCount = 0
                }
                counter = counter+1
            }
        default: // Should eventually raise error
            print("Direction \(Direction) not valid")
        }
    }
    
    func CheckForPoints()
    {
        //First i am setting point array back to zeros
        for XCount in [0 , 1 , 2 , 3 , 4 , 5 , 6]
        {
            for YCount in [0 , 1 , 2 , 3 , 4 , 5 , 6]
            {
                PointArray[XCount][YCount] = 0
            }
        }
        
        for checkCount in [-1 , 1] {
            counter = 1
            XCount = 0
            YCount = 6
            while counter <= 49 {
                if BoardArray[XCount][YCount] == checkCount {
                    //Check for vertical winner
                    if YCount >= 3 {
                        if abs(BoardArray[XCount][YCount] + BoardArray[XCount][YCount - 1] + BoardArray[XCount][YCount - 2] + BoardArray[XCount][YCount - 3]) == 4 {
                            qCounter = 1
                            PointArray[XCount][YCount]      = 1
                            PointArray[XCount][YCount - 1]  = 1
                            PointArray[XCount][YCount - 2]  = 1
                            PointArray[XCount][YCount - 3]  = 1
                        }
                    }
                    if XCount <= 3{
                        if abs(BoardArray[XCount][YCount] + BoardArray[XCount + 1][YCount] + BoardArray[XCount + 2][YCount] + BoardArray[XCount + 3][YCount]) == 4 {
                            qCounter = 1
                            PointArray[XCount][YCount]      = 1
                            PointArray[XCount + 1][YCount]  = 1
                            PointArray[XCount + 2][YCount]  = 1
                            PointArray[XCount + 3][YCount]  = 1
                        }
                    }
                    if XCount <= 3 && YCount >= 3{
                        if abs(BoardArray[XCount][YCount] + BoardArray[XCount + 1][YCount - 1] + BoardArray[XCount + 2][YCount - 2] + BoardArray[XCount + 3][YCount - 3]) == 4 {
                            qCounter = 1
                            PointArray[XCount][YCount]      = 1
                            PointArray[XCount + 1][YCount - 1]  = 1
                            PointArray[XCount + 2][YCount - 2]  = 1
                            PointArray[XCount + 3][YCount - 3]  = 1
                        }
                    }
                    if XCount >= 3 && YCount >= 3{
                        if abs(BoardArray[XCount][YCount] + BoardArray[XCount - 1][YCount - 1] + BoardArray[XCount - 2][YCount - 2] + BoardArray[XCount - 3][YCount - 3]) == 4 {
                            qCounter = 1
                            PointArray[XCount][YCount]      = 1
                            PointArray[XCount - 1][YCount - 1]  = 1
                            PointArray[XCount - 2][YCount - 2]  = 1
                            PointArray[XCount - 3][YCount - 3]  = 1
                            
                        }
                    }
                }// end of if board array statement
                counter = counter + 1
                XCount = XCount + 1
                if XCount > 6{
                    XCount = 0
                    YCount = YCount - 1
                }
                
            }//end of while loop
        }
        counter = 1
        XCount = 0
        YCount = 6
        while counter <= 49 {
            location = (7 * YCount) + XCount
            if PointArray[XCount][YCount] == 1 {
                Squares[location].textColor = colorRed}
            else {
                Squares[location].textColor = colorBlack }
            counter = counter + 1
            XCount = XCount + 1
            if XCount > 6{
                XCount = 0
                YCount = YCount - 1
            }
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

