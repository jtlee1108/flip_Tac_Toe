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
    var Direction: Int = 0
    var BoardArray = Array(repeating: Array(repeating: 0, count: 7), count: 7)
    var PointArray = Array(repeating: Array(repeating: 0, count: 7), count: 7)
    var XCount: Int = 0
    var YCount: Int = 0
    var sign: Int = 1 //Determines the display according to which player makes the move
    var triggerCount: Int = 0
    let colorRed = UIColor(red: 1, green:0, blue: 0, alpha: 1)
    let colorBlack = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    var location: Int = 0
    var checkCount: Int = 0
    
    @IBOutlet weak var DebugLabel: UILabel!
    
    @IBOutlet var Squares: [UILabel]!
    @IBOutlet weak var GravityDirectionLabel: UILabel!
    @IBOutlet weak var PlayerTurnLabel: UILabel!
    
    
    @IBAction func RotateCCW(_ sender: UIButton)
    {
        if (Direction < 3) { Direction += 1}
        else {Direction = 0}
        RunGame()
    }
    
    @IBAction func RotateCW(_ sender: UIButton)
    {
        if (Direction > 0) { Direction -= 1}
        else {Direction = 3}
        RunGame()
    }
    
    @IBAction func ResetButton(_ sender: UIButton)
    {
        for XCount in 0...6
        {
            for YCount in 0...6
            {
                location = (7 * YCount) + XCount
                Squares[location].textColor = colorBlack
                BoardArray[XCount][YCount] = 0
            }
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
        for XCount in 0...6
        {
            for YCount in 0...6
            {
                location = (7 * YCount) + XCount
                switch BoardArray[XCount][YCount]{
                case 1:
                    Squares[location].text = "O"
                case -1:
                    Squares[location].text = "X"
                default:
                    Squares[location].text = "  "
                }
            }
        }
    }
    func RunGravity()
    {
        triggerCount = 0
        switch Direction
        {
        case 0: // Gravity Down
            for XCount in 0...6
            {
                for YCount in 0...6
                {
                    if BoardArray[XCount][YCount] != 0
                    {
                        if triggerCount != YCount
                        {
                            BoardArray[XCount][triggerCount] = BoardArray[XCount][YCount]
                            BoardArray[XCount][YCount] = 0
                        }
                        triggerCount += 1
                    }
                }
                triggerCount = 0
            }
        case 1: //Gravity Right
            for YCount in 0...6
            {
                for XCount in [6,5,4,3,2,1,0]
                {
                    if BoardArray[XCount][YCount] != 0{
                        if triggerCount != (6-XCount){
                            BoardArray[6-triggerCount][YCount] = BoardArray[XCount][YCount]
                            BoardArray[XCount][YCount] = 0
                        }
                        triggerCount += 1
                    }
                }
                triggerCount = 0
            }
        case 2: //Gravity Up
            for XCount in 0...6
            {
                for YCount in [6,5,4,3,2,1,0]
                {
                    if BoardArray[XCount][YCount] != 0
                    {
                        if triggerCount != (6-YCount)
                        {
                            BoardArray[XCount][6-triggerCount] = BoardArray[XCount][YCount]
                            BoardArray[XCount][YCount] = 0
                        }
                        triggerCount += 1
                    }
                }
                triggerCount = 0
            }
        case 3: //Gravity Left
            
            for YCount in 0...6
            {
                for XCount in 0...6
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
                }
                triggerCount = 0
            }
        default: // Should eventually raise error
            print("Direction \(Direction) not valid")
        }
    }
    
    func CheckForPoints()
    {
        //First i am setting point array back to zeros
        for XCount in [0,1,2,3,4,5,6]
        {
            for YCount in 0...6
            {
                PointArray[XCount][YCount] = 0
            }
        }
        
        for checkCount in [-1 , 1]
        {
            for XCount in 0...6
            {
                for YCount in [6,5,4,3,2,1,0]
                {
                    if BoardArray[XCount][YCount] == checkCount
                    {
                        //Check for Vertical
                        if YCount >= 3
                        {
                            if abs(BoardArray[XCount][YCount] + BoardArray[XCount][YCount - 1] + BoardArray[XCount][YCount - 2] + BoardArray[XCount][YCount - 3]) == 4
                            {
                                PointArray[XCount][YCount]      = 1
                                PointArray[XCount][YCount - 1]  = 1
                                PointArray[XCount][YCount - 2]  = 1
                                PointArray[XCount][YCount - 3]  = 1
                            }
                        }
                        //Check for Horizontal
                        if XCount <= 3
                        {
                            if abs(BoardArray[XCount][YCount] + BoardArray[XCount + 1][YCount] + BoardArray[XCount + 2][YCount] + BoardArray[XCount + 3][YCount]) == 4
                            {
                                PointArray[XCount][YCount]      = 1
                                PointArray[XCount + 1][YCount]  = 1
                                PointArray[XCount + 2][YCount]  = 1
                                PointArray[XCount + 3][YCount]  = 1
                            }
                        }
                        //Check for cross \
                        if XCount <= 3 && YCount >= 3
                        {
                            if abs(BoardArray[XCount][YCount] + BoardArray[XCount + 1][YCount - 1] + BoardArray[XCount + 2][YCount - 2] + BoardArray[XCount + 3][YCount - 3]) == 4
                            {
                                PointArray[XCount][YCount]      = 1
                                PointArray[XCount + 1][YCount - 1]  = 1
                                PointArray[XCount + 2][YCount - 2]  = 1
                                PointArray[XCount + 3][YCount - 3]  = 1
                            }
                        }
                        //Check for cross /
                        if XCount >= 3 && YCount >= 3
                        {
                            if abs(BoardArray[XCount][YCount] + BoardArray[XCount - 1][YCount - 1] + BoardArray[XCount - 2][YCount - 2] + BoardArray[XCount - 3][YCount - 3]) == 4
                            {
                                PointArray[XCount][YCount]      = 1
                                PointArray[XCount - 1][YCount - 1]  = 1
                                PointArray[XCount - 2][YCount - 2]  = 1
                                PointArray[XCount - 3][YCount - 3]  = 1
                                
                            }
                        }
                    } // end of if board array statement
                    
                } //end of YCount loop
            } //end of for XCount loop
        }
        for XCount in 0...6
        {
            for YCount in [6,5,4,3,2,1,0]
            {
                location = (7 * YCount) + XCount
                if PointArray[XCount][YCount] == 1 {Squares[location].textColor = colorRed}
                else { Squares[location].textColor = colorBlack}
            }
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

