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
    var playerTurn: Int = 1
    let gravDirection = ["Down","Right","Up","Left"]
    var direction: Int = 0
    var boardArray = Array(repeating: Array(repeating: 0, count: 7), count: 7)
    var pointArray = Array(repeating: Array(repeating: 0, count: 7), count: 7)
    let colorRed = UIColor(red: 1, green:0, blue: 0, alpha: 1)
    let colorBlack = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let colorBlue = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
    var checkCount: Int = 0
    var player1Score: Int = 0
    var player2Score: Int = 0
    var pointsAdded = false
    
    @IBOutlet weak var DebugLabel: UILabel!
    @IBOutlet var ScoreBoard: [UILabel]!
    @IBOutlet var Squares: [UILabel]!
    @IBOutlet weak var PlayerTurnLabel: UILabel!
    
    @IBOutlet weak var GravArrow: UIImageView!
    @IBAction func RotateCCW(_ sender: UIButton)
    {
        if (direction < 3) { direction += 1}
        else {direction = 0}
        runGame(changeTurn: false)
    }
    @IBOutlet var PlayerLabels: [UILabel]!
    
    @IBAction func RotateCW(_ sender: UIButton)
    {
        if (direction > 0) { direction -= 1}
        else {direction = 3}
        runGame(changeTurn: false)
    }
    
    @IBAction func ResetButton(_ sender: UIButton)
    {
        for i in 0...6
        {
            for j in 0...6
            {
                boardArray[i][j] = 0
            }
        }
        direction = 0
        playerTurn = 1
        runGame(changeTurn: false)
        PlayerTurnLabel.text = "Player 1"
        PlayerLabels[0].isHighlighted = true
        PlayerLabels[1].isHighlighted = false
        PlayerTurnLabel.textColor = colorRed
    }
    
    @IBAction func TopButton(_ sender: UIButton)
    {
        if direction == 0 && boardArray[sender.tag - 1] [6] == 0
        {
            boardArray[sender.tag - 1] [6] = playerTurn
            runGame(changeTurn: true)
            
        }
    }
    @IBOutlet var TopButtonOutlet: [UIButton]!
    
    @IBAction func LeftButton(_ sender: UIButton)
    {
        if direction == 1 && boardArray[0] [sender.tag - 1] == 0
        {
            boardArray[0] [sender.tag - 1] = playerTurn
            runGame(changeTurn: true)
        }
    }
    @IBOutlet var LeftButtonOutlet: [UIButton]!
    
    @IBAction func BottomButton(_ sender: UIButton)
    {
        if direction == 2 && boardArray[sender.tag - 1] [0] == 0
        {
            boardArray[sender.tag - 1] [0] = playerTurn
            runGame(changeTurn: true)
        }
    }
    @IBOutlet var BottomButtonOutlet: [UIButton]!
    
    @IBAction func RightButton(_ sender: UIButton)
    {
        if direction == 3 && boardArray[6] [sender.tag - 1] == 0
        {
            boardArray[6] [sender.tag - 1] = playerTurn
            runGame(changeTurn: true)
        }
    }
    @IBOutlet var RightButtonOutlet: [UIButton]!
    
    func runGame(changeTurn: Bool)
    {
        runGravity()
        changeSquares()
        
        checkForPoints()
        
        while pointsAdded
        {
            runGravity()
            pointsAdded = false
            changeSquares()
            checkForPoints()
        }
        
        if changeTurn {playerTurn = playerTurn * -1}
        if playerTurn == 1
        {
            PlayerTurnLabel.text = "Player 1"
            PlayerLabels[0].isHighlighted = true
            PlayerLabels[1].isHighlighted = false
            PlayerTurnLabel.textColor = colorRed
        }
        else
        {
            PlayerTurnLabel.text = "Player 2"
            PlayerLabels[0].isHighlighted = false
            PlayerLabels[1].isHighlighted = true
            PlayerTurnLabel.textColor = colorBlue
        }
        for i in 0...6
        {
            switch direction
            {
            case 0:
                if i == 0 {rotateImage(angle: 0.0)}
                TopButtonOutlet[i].fadeIn()
                if LeftButtonOutlet[i].alpha != 0 {LeftButtonOutlet[i].fadeOut()}
                if RightButtonOutlet[i].alpha != 0 {RightButtonOutlet[i].fadeOut()}
            case 1:
                if i == 0 {rotateImage(angle: 270.0)}
                LeftButtonOutlet[i].fadeIn()
                if  TopButtonOutlet[i].alpha != 0 {TopButtonOutlet[i].fadeOut()}
                if BottomButtonOutlet[i].alpha != 0 {BottomButtonOutlet[i].fadeOut()}
            case 2:
                if i == 0 {rotateImage(angle: 180.0)}
                BottomButtonOutlet[i].fadeIn()
                if LeftButtonOutlet[i].alpha != 0 {LeftButtonOutlet[i].fadeOut()}
                if RightButtonOutlet[i].alpha != 0 {RightButtonOutlet[i].fadeOut()}
            default:
                if i == 0 {rotateImage(angle: 90.0)}
                if  TopButtonOutlet[i].alpha != 0 {TopButtonOutlet[i].fadeOut()}
                if BottomButtonOutlet[i].alpha != 0 {BottomButtonOutlet[i].fadeOut()}
                RightButtonOutlet[i].fadeIn()
            }
        }
        ScoreBoard[0].text = String(player1Score)
        ScoreBoard[0].textColor = colorRed
        ScoreBoard[1].text = String(player2Score)
        ScoreBoard[1].textColor = colorBlue
    } // End runGame()
    
    func changeSquares()
    {
        var changeLocation = 0
        for i in 0...6
        {
            for j in 0...6
            {
                changeLocation = (7 * j) + i
                switch boardArray[i][j]{
                case 1:
                    Squares[changeLocation].text = "O"
                    Squares[changeLocation].textColor = colorRed
                case -1:
                    Squares[changeLocation].text = "X"
                    Squares[changeLocation].textColor = colorBlue
                default:
                    Squares[changeLocation].text = "  "
                }
            }
        }
    }
    
    func runGravity()
    {
        var gravTriggerCount = 0
        switch direction
        {
        case 0: // Gravity Down
            for i in 0...6
            {
                for j in 0...6
                {
                    if boardArray[i][j] != 0
                    {
                        if gravTriggerCount != j
                        {
                            boardArray[i][gravTriggerCount] = boardArray[i][j]
                            boardArray[i][j] = 0
                        }
                        gravTriggerCount += 1
                    }
                }
                gravTriggerCount = 0
            }
        case 1: //Gravity Right
            for j in 0...6
            {
                for i in (0...6).reversed()
                {
                    if boardArray[i][j] != 0{
                        if gravTriggerCount != (6-i){
                            boardArray[6-gravTriggerCount][j] = boardArray[i][j]
                            boardArray[i][j] = 0
                        }
                        gravTriggerCount += 1
                    }
                }
                gravTriggerCount = 0
            }
        case 2: //Gravity Up
            for i in 0...6
            {
                for j in (0...6).reversed()
                {
                    if boardArray[i][j] != 0
                    {
                        if gravTriggerCount != (6-j)
                        {
                            boardArray[i][6-gravTriggerCount] = boardArray[i][j]
                            boardArray[i][j] = 0
                        }
                        gravTriggerCount += 1
                    }
                }
                gravTriggerCount = 0
            }
        case 3: //Gravity Left
            for j in 0...6
            {
                for i in 0...6
                {
                    if boardArray[i][j] != 0
                    {
                        if gravTriggerCount != (i)
                        {
                            boardArray[gravTriggerCount][j] = boardArray[i][j]
                            boardArray[i][j] = 0
                        }
                        gravTriggerCount += 1
                    }
                }
                gravTriggerCount = 0
            }
        default: // Should eventually raise error
            print("Direction \(direction) not valid")
        }
    }
    
    func checkForPoints()
    {
        //First i am setting point array back to zeros
        for i in 0...6
        {
            for j in 0...6
            {
                pointArray[i][j] = 0
            }
        }
        
        for PlayerCount in [-1 , 1]
        {
            for i in 0...6
            {
                for j in (0...6).reversed()
                {
                    if boardArray[i][j] == PlayerCount
                    {
                        //Check for Vertical
                        if j >= 3
                        {
                            if abs(boardArray[i][j] + boardArray[i][j - 1] + boardArray[i][j - 2] + boardArray[i][j - 3]) == 4
                            {
                                switch PlayerCount{
                                case -1:
                                    player2Score += 1
                                default:
                                    player1Score += 1
                                }
                                pointArray[i][j]      = 1
                                pointArray[i][j - 1]  = 1
                                pointArray[i][j - 2]  = 1
                                pointArray[i][j - 3]  = 1
                            }
                        }
                        //Check for Horizontal
                        if i <= 3
                        {
                            if abs(boardArray[i][j] + boardArray[i + 1][j] + boardArray[i + 2][j] + boardArray[i + 3][j]) == 4
                            {
                                switch PlayerCount{
                                case -1:
                                    player2Score += 1
                                default:
                                    player1Score += 1
                                }
                                pointArray[i][j]      = 1
                                pointArray[i + 1][j]  = 1
                                pointArray[i + 2][j]  = 1
                                pointArray[i + 3][j]  = 1
                            }
                        }
                        //Check for cross \
                        if i <= 3 && j >= 3
                        {
                            if abs(boardArray[i][j] + boardArray[i + 1][j - 1] + boardArray[i + 2][j - 2] + boardArray[i + 3][j - 3]) == 4
                            {
                                switch PlayerCount{
                                case -1:
                                    player2Score += 1
                                default:
                                    player1Score += 1
                                }
                                pointArray[i][j]          = 1
                                pointArray[i + 1][j - 1]  = 1
                                pointArray[i + 2][j - 2]  = 1
                                pointArray[i + 3][j - 3]  = 1
                            }
                        }
                        //Check for cross /
                        if i >= 3 && j >= 3
                        {
                            if abs(boardArray[i][j] + boardArray[i - 1][j - 1] + boardArray[i - 2][j - 2] + boardArray[i - 3][j - 3]) == 4
                            {
                                switch PlayerCount{
                                case -1:
                                    player2Score += 1
                                default:
                                    player1Score += 1
                                }
                                pointArray[i][j]          = 1
                                pointArray[i - 1][j - 1]  = 1
                                pointArray[i - 2][j - 2]  = 1
                                pointArray[i - 3][j - 3]  = 1
                                
                            }
                        }
                    } // end of if board array statement
                    
                } //end of CheckY loop
            } //end of for CheckX loop
        }
        for i in 0...6
        {
            for j in (0...6).reversed()
            {
                if pointArray[i][j] == 1 {pointsAdded = true}
            }
        }
        if pointsAdded{
            for i in 0...6
            {
                for j in (0...6).reversed()
                {
                    if pointArray[i][j] == 1 {boardArray[i][j] = 0}
                }
            }
        }
    }
    
    func delay(delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            closure()
        }
    }
    
    @IBAction func rotateImage(angle: CGFloat) {
        UIView.animate(withDuration: 0.325, animations: {
            self.GravArrow.transform = CGAffineTransform(rotationAngle: (angle * .pi) / 180.0)
        })
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

