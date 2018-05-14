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
    var sign: Int = 1 //Determines the display according to which player makes the move
    let colorRed = UIColor(red: 1, green:0, blue: 0, alpha: 1)
    let colorBlack = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let colorBlue = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
    var checkCount: Int = 0
    var Player1Score: Int = 0
    var Player2Score: Int = 0
    var pointsAdded = false
    
    @IBOutlet weak var DebugLabel: UILabel!
    
    
    @IBOutlet var ScoreBoard: [UILabel]!
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
        var ResetLocation = 0
        for ResetXCount in 0...6
        {
            for ResetYCount in 0...6
            {
                ResetLocation = (7 * ResetYCount) + ResetXCount
                BoardArray[ResetXCount][ResetYCount] = 0
            }
        }
        Direction = 0
        RunGame()
        playerTurn = true
        PlayerTurnLabel.text = "Player 1"
        PlayerTurnLabel.textColor = colorRed
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
        
        while pointsAdded{
            RunGravity()
            pointsAdded = false
            ChangeSquares()
            CheckForPoints()
        }
        playerTurn = !playerTurn
        if playerTurn
        {
            PlayerTurnLabel.text = "Player 1"
            sign = 1
            PlayerTurnLabel.textColor = colorRed
        }
        else
        {
            PlayerTurnLabel.text = "Player 2"
            sign = -1
            PlayerTurnLabel.textColor = colorBlue
        }
        GravityDirectionLabel.text = GravDirection[Direction]
        ScoreBoard[0].text = "Player1 : " + String(Player1Score)
        ScoreBoard[0].textColor = colorRed
        ScoreBoard[1].text = "Player2 : " + String(Player2Score)
        ScoreBoard[1].textColor = colorBlue
    } // End RunGame()
    
    func ChangeSquares()
    {
        var ChangeLocation = 0
        for ChangeXCount in 0...6
        {
            for ChangeYCount in 0...6
            {
                ChangeLocation = (7 * ChangeYCount) + ChangeXCount
                switch BoardArray[ChangeXCount][ChangeYCount]{
                case 1:
                    Squares[ChangeLocation].text = "O"
                    Squares[ChangeLocation].textColor = colorRed
                case -1:
                    Squares[ChangeLocation].text = "X"
                    Squares[ChangeLocation].textColor = colorBlue
                default:
                    Squares[ChangeLocation].text = "  "
                }
            }
        }
    }
    func RunGravity()
    {
        var GravTriggerCount = 0
        switch Direction
        {
        case 0: // Gravity Down
            for GravXCount in 0...6
            {
                for GravYCount in 0...6
                {
                    if BoardArray[GravXCount][GravYCount] != 0
                    {
                        if GravTriggerCount != GravYCount
                        {
                            BoardArray[GravXCount][GravTriggerCount] = BoardArray[GravXCount][GravYCount]
                            BoardArray[GravXCount][GravYCount] = 0
                        }
                        GravTriggerCount += 1
                    }
                }
                GravTriggerCount = 0
            }
        case 1: //Gravity Right
            for GravYCount in 0...6
            {
                for GravXCount in [6,5,4,3,2,1,0]
                {
                    if BoardArray[GravXCount][GravYCount] != 0{
                        if GravTriggerCount != (6-GravXCount){
                            BoardArray[6-GravTriggerCount][GravYCount] = BoardArray[GravXCount][GravYCount]
                            BoardArray[GravXCount][GravYCount] = 0
                        }
                        GravTriggerCount += 1
                    }
                }
                GravTriggerCount = 0
            }
        case 2: //Gravity Up
            for GravXCount in 0...6
            {
                for GravYCount in [6,5,4,3,2,1,0]
                {
                    if BoardArray[GravXCount][GravYCount] != 0
                    {
                        if GravTriggerCount != (6-GravYCount)
                        {
                            BoardArray[GravXCount][6-GravTriggerCount] = BoardArray[GravXCount][GravYCount]
                            BoardArray[GravXCount][GravYCount] = 0
                        }
                        GravTriggerCount += 1
                    }
                }
                GravTriggerCount = 0
            }
        case 3: //Gravity Left
            for GravYCount in 0...6
            {
                for GravXCount in 0...6
                {
                    if BoardArray[GravXCount][GravYCount] != 0
                    {
                        if GravTriggerCount != (GravXCount)
                        {
                            BoardArray[GravTriggerCount][GravYCount] = BoardArray[GravXCount][GravYCount]
                            BoardArray[GravXCount][GravYCount] = 0
                        }
                        GravTriggerCount += 1
                    }
                }
                GravTriggerCount = 0
            }
        default: // Should eventually raise error
            print("Direction \(Direction) not valid")
        }
    }
    
    func CheckForPoints()
    {
        //First i am setting point array back to zeros
        for CheckXCount in [0,1,2,3,4,5,6]
        {
            for CheckYCount in 0...6
            {
                PointArray[CheckXCount][CheckYCount] = 0
            }
        }
        
        for PlayerCount in [-1 , 1]
        {
            for CheckXCount in 0...6
            {
                for CheckYCount in [6,5,4,3,2,1,0]
                {
                    if BoardArray[CheckXCount][CheckYCount] == PlayerCount
                    {
                        //Check for Vertical
                        if CheckYCount >= 3
                        {
                            if abs(BoardArray[CheckXCount][CheckYCount] + BoardArray[CheckXCount][CheckYCount - 1] + BoardArray[CheckXCount][CheckYCount - 2] + BoardArray[CheckXCount][CheckYCount - 3]) == 4
                            {
                                switch PlayerCount{
                                case -1:
                                    Player2Score += 1
                                default:
                                    Player1Score += 1
                                }
                                PointArray[CheckXCount][CheckYCount]      = 1
                                PointArray[CheckXCount][CheckYCount - 1]  = 1
                                PointArray[CheckXCount][CheckYCount - 2]  = 1
                                PointArray[CheckXCount][CheckYCount - 3]  = 1
                            }
                        }
                        //Check for Horizontal
                        if CheckXCount <= 3
                        {
                            if abs(BoardArray[CheckXCount][CheckYCount] + BoardArray[CheckXCount + 1][CheckYCount] + BoardArray[CheckXCount + 2][CheckYCount] + BoardArray[CheckXCount + 3][CheckYCount]) == 4
                            {
                                switch PlayerCount{
                                case -1:
                                    Player2Score += 1
                                default:
                                    Player1Score += 1
                                }
                                PointArray[CheckXCount][CheckYCount]      = 1
                                PointArray[CheckXCount + 1][CheckYCount]  = 1
                                PointArray[CheckXCount + 2][CheckYCount]  = 1
                                PointArray[CheckXCount + 3][CheckYCount]  = 1
                            }
                        }
                        //Check for cross \
                        if CheckXCount <= 3 && CheckYCount >= 3
                        {
                            if abs(BoardArray[CheckXCount][CheckYCount] + BoardArray[CheckXCount + 1][CheckYCount - 1] + BoardArray[CheckXCount + 2][CheckYCount - 2] + BoardArray[CheckXCount + 3][CheckYCount - 3]) == 4
                            {
                                switch PlayerCount{
                                case -1:
                                    Player2Score += 1
                                default:
                                    Player1Score += 1
                                }
                                PointArray[CheckXCount][CheckYCount]      = 1
                                PointArray[CheckXCount + 1][CheckYCount - 1]  = 1
                                PointArray[CheckXCount + 2][CheckYCount - 2]  = 1
                                PointArray[CheckXCount + 3][CheckYCount - 3]  = 1
                            }
                        }
                        //Check for cross /
                        if CheckXCount >= 3 && CheckYCount >= 3
                        {
                            if abs(BoardArray[CheckXCount][CheckYCount] + BoardArray[CheckXCount - 1][CheckYCount - 1] + BoardArray[CheckXCount - 2][CheckYCount - 2] + BoardArray[CheckXCount - 3][CheckYCount - 3]) == 4
                            {
                                switch PlayerCount{
                                case -1:
                                    Player2Score += 1
                                default:
                                    Player1Score += 1
                                }
                                PointArray[CheckXCount][CheckYCount]      = 1
                                PointArray[CheckXCount - 1][CheckYCount - 1]  = 1
                                PointArray[CheckXCount - 2][CheckYCount - 2]  = 1
                                PointArray[CheckXCount - 3][CheckYCount - 3]  = 1
                                
                            }
                        }
                    } // end of if board array statement
                    
                } //end of CheckY loop
            } //end of for CheckX loop
        }
        for CheckXCount in 0...6
        {
            for CheckYCount in [6,5,4,3,2,1,0]
            {
                if PointArray[CheckXCount][CheckYCount] == 1 {pointsAdded = true}
            }
        }
        if pointsAdded{
            for CheckXCount in 0...6
            {
                for CheckYCount in [6,5,4,3,2,1,0]
                {
                    if PointArray[CheckXCount][CheckYCount] == 1 {BoardArray[CheckXCount][CheckYCount] = 0}
                }
            }
        }
    }
    
    func delay(delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            closure()
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

