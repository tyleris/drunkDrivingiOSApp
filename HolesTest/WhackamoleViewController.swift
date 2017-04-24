//
//  WhackamoleViewController.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/17/17.
//
//

import UIKit

class WhackamoleViewController: UIViewController, UIGestureRecognizerDelegate {

    //MARK: Properties
    
    //Storyboard connections
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var elephantImageView: UIImageView!
    @IBOutlet weak var badgerImageView: UIImageView!
    @IBOutlet weak var groundhogImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var annoucementLabel: UILabel!
    @IBOutlet weak var lastReactionTimeLabel: UILabel!
    @IBOutlet weak var failsLabel: UILabel!
    @IBOutlet weak var reactionCounterLabel: UILabel!
    
    //Holes
    var holes = [holeView]()
    let holesMax = 3
    
    //Counters
    var timer = Timer()
    var counter = 0.0
    var reactionCounter = 0.0
    var reactionTimes = [Double]()
    var reactionTimeAvg: Double = 0
    var failCount = 0
    var targetAnimalShowCount = 0
    
    //Passed data
    var segueData = Array<(reactionTimeAvg: Double, failCount: Int)>()
    
    //Game play
    let gameLength = 20 as UInt32
    let minAppearTime = 1 as UInt32
    let waitTime = 2.0
    let countInterval = 0.01
    var precision: Double = 100
    
    //Animals
    let otherAnimalAppearances = 10
    let targetAppearances = 5
    let animalNames = ["camel","chameleon","cock", "dolphin", "fish", "giraffe", "goose", "horse", "moose", "penguin", "pig", "sheep", "snake", "turtle", "unicorn"]
    let targetAnimalName = "giraffe"
    let animalNamesNoTarget = ["camel","chameleon","cock", "dolphin", "fish", "goose", "horse", "moose", "penguin", "pig", "sheep", "snake", "turtle", "unicorn"]
    var targetVisibleFlag = false
    var appearInfo = Array<(time: Double, animal: String, target: Bool, hole: Int)>()
    
    //Canvas
    let marginLeft = 0
    let marginRight = 100
    let marginTop = 200
    let marginBottom = 50
    
    //Tap Gestures
    var successTapGesture: UITapGestureRecognizer?
    var failTapGesture: UITapGestureRecognizer?
    var missTapGesture: UITapGestureRecognizer?
    
    //MARK: ToDos
    /*
    - Make mainFrame into the subview where all holes are placed (will I then need to refer to everything through the mainFrame? Ug. Maybe not worth it. 
    */
    
    //MARK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
    
        precision = 1/countInterval
        
        //Create holes
        for _ in 0..<holesMax {
            createHole()
        }
        
        //Randomly decide when animals should appear, and which holes
        setAnimalAppearTimes()
        
        //Create a timer
        var timer = Timer.scheduledTimer(timeInterval: countInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        
        missTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleMissTap(_:)))
        successTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSuccessTap(_:)))
        failTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFailTap(_:)))

        successTapGesture?.delegate = self
        failTapGesture?.delegate = self
        
        self.view.addGestureRecognizer(missTapGesture!)
        
    }

    //MARK: Timers
    func update(){
        
        //Time starts counting
        counter += countInterval
        
        countLabel.text = "Count: \(roundToDigit(num: counter, digits: 2))"
        
        //start counting reaction time once target animal is visible
        if targetVisibleFlag == true {
            reactionCounter += countInterval
            reactionCounterLabel.text = "Reaction counter: \(roundToDigit(num: reactionCounter, digits: 2))"
        }
        
        //Make animals appears / disappear when counter reaches time for each animal
        makeAnimalsAppear()
        makeAnimalsDisappear()
    
    }
    
    private func makeAnimalsAppear(){
        
        for i in 0..<appearInfo.count {
            
            let data = appearInfo[i]
            
            if round(counter * precision) == round(data.time * precision) {
                
                holes[data.hole].addAnimal(animalName: data.animal, disappearTime: counter + waitTime)
                
                if data.target == true {
                    
                    //make target appear
                    holes[data.hole].addGestureRecognizer(successTapGesture!)
                    targetVisibleFlag = true
                    holes[data.hole].target = true
                    targetAnimalShowCount += 1
                    
                } else {
                    //make wrong animal appear
                    holes[data.hole].addGestureRecognizer(failTapGesture!)
                }
                
                print("\(appearInfo[i].time) sec: animal: \(appearInfo[i].animal), hole \(appearInfo[i].hole)")
                
                print("disappear time set to \(holes[data.hole].disappearTime)")
            }
        }
    }
    
    private func makeAnimalsDisappear(){
        
        for i in 0..<appearInfo.count {
            
            let data = appearInfo[i]
            
            //If counter is equal to a hole's disappear time, then make animal disappear
            if (round(counter * precision) >= round(holes[data.hole].disappearTime * precision)) && (holes[data.hole].isVisible == true) {
                
                holes[data.hole].removeAnimal()
                
                if holes[data.hole].isTarget() == true {
                    holes[data.hole].removeGestureRecognizer(successTapGesture!)
                    holes[data.hole].target = false
                    targetVisibleFlag = false
                    reactionTimeAvg += reactionCounter / Double(targetAppearances)
                    reactionCounter = 0
                    reactionTimes.append(reactionCounter)
                    
                    if targetAnimalShowCount >= targetAppearances {
                        endGame()
                    }
                    
                } else {
                    holes[data.hole].removeGestureRecognizer(failTapGesture!)
                }
                
                print("\(counter) sec: \(data.animal) disappeared from \(data.hole)" )
            }
        }
    }
    
    private func targetDisappear(hole: holeView){
        
    }
    
    private func otherAnimalDisappear(hole: holeView){
        
    }
    
    //MARK: Navigation
    
    //End game. Segue to results ViewController
    func endGame(){
        print("end the game!! mo fo!")
        performSegue(withIdentifier:"segueToResults", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        segueData += [(reactionTimeAvg: reactionTimeAvg, failCount: failCount)]
        
        if let resultsVC = segue.destination as? ResultsViewController {
            resultsVC.segueData = segueData
        }
    }
    
    //MARK: Tap Gesture Recognizers
    
    //Correct guess
    func handleSuccessTap(_ gestureRecognizer: UITapGestureRecognizer){
        
        annoucementLabel.text = "You touched a groundhog. That's cool bro."
        
        //reset target flags
        targetVisibleFlag = false
        for h in holes{
            h.target = false
        }
        
        //Record reaction time
        lastReactionTimeLabel.text = "Reaction Time: \(roundToDigit(num: reactionCounter, digits: 2))"
        reactionTimes.append(reactionCounter)
        reactionTimeAvg += reactionCounter / Double(targetAppearances)
        
        //reset reaction time counter
        reactionCounterLabel.text = "Reaction counter:"
        reactionCounter = 0
        
        if targetAnimalShowCount >= targetAppearances {
            endGame()
        }
    }
    
    //Failed tap
    func handleFailTap(_ gestureRecognizer: UITapGestureRecognizer){
        annoucementLabel.text = "I'm not a groundhog! seriously."
        failCount += 1
        failsLabel.text = "Fails: \(failCount)"
    }
    
    //Missed tap
    func handleMissTap(_ gestureRecognizer: UITapGestureRecognizer){
        annoucementLabel.text = "Lame. You didn't click an animal! You drunk."
        failCount += 1
        failsLabel.text = "Fails: \(failCount)"
    }
    
    //MARK: Helper load methods
    
    func createHole(){
        let hole = holeView(point: CGPoint(x: 0, y: 0))
        
        
        var tryAgain = false
        var tries = 0
        
        repeat {
            tryAgain = false
            var overlap = false
            
            let sP = spawnAtRandomPosition()
            print(sP)
            hole.frame.origin = sP
            
        
            for i in 0..<holes.count {
                print(holes[i].frame.origin)
                if hole.frame.intersects(holes[i].frame) == true {
                    overlap = true
                }
            }
            
            if overlap == false {
                holes.append(hole)
                view.addSubview(hole)
            } else {
                tryAgain = true
            }
            
            tries += 1
            print("trying to place frame: \(tries) times")
            if tries >= 50 {fatalError("Failed to set find a place for hole frame: Over 50 tries")}
        } while tryAgain == true
    }
    
    //Decide when each animal should appear
    private func setAnimalAppearTimes(){
    
        //Create target appearance time within game timeframe
        for _ in 0..<targetAppearances {
            addAnimal(target: true)
        }
        
        //Create other animal appear times
        for _ in 0..<otherAnimalAppearances {
            addAnimal(target: false)
        }
    }
    
    //Add animal to hole and time that is unoccupied
    private func addAnimal(target: Bool){
        var tries = 0
        var tryAgain = false
        var animal = ""
        
        repeat {
            tryAgain = false
            
            if target == true {
                animal = targetAnimalName
            } else {
                let idx = randomInRange(lo: 0, hi: animalNames.count - 2)
                animal = animalNamesNoTarget[idx]
            }
    
            let time = genRndTimeInGame()
            let hole = setHoleNum()
            let targetAnimal = target
            
            if isHoleOccupied(time: time, holeNum: hole) == true {
                tryAgain = true
            } else {
                appearInfo += [(time: time, animal: animal, target: targetAnimal, hole: hole)]
            }
            tries += 1
            
            print("trying to place animal: \(tries) times")
            if tries >= 50 {fatalError("Failed to set animal appear time: Over 50 tries")}
            
        } while tryAgain == true

    }
    
    //Return whether hole has animal appearing within the waitTime
    private func isHoleOccupied(time: Double, holeNum: Int) -> Bool {
        var occupied = false
        
        for i in 0..<appearInfo.count {
            if ((time >= appearInfo[i].time) && (time <= appearInfo[i].time + waitTime)) && (holeNum == appearInfo[i].hole) {
                    occupied = true
            }
        }
        return occupied
    }
    
    private func roundToDigit(num: Double, digits: Int) -> Double{
        
        return (round(num * Double(digits) * 10) / (Double(digits) * 10))
    }
    
    //MARK: Random generators
    
    private func setHoleNum() -> Int {
        return randomInRange(lo: 0, hi: holesMax - 1)
    }
    
    //Return a random point within frame to place something
    private func spawnAtRandomPosition() -> CGPoint {
        
        //Set max and min of frame
        //ToDo: set max min programatically
        let frameMaxHeight = Int(mainView.frame.height) - marginBottom
        let frameMinHeight = marginTop
        let frameMaxWidth = Int(mainView.frame.width) - marginRight
        let frameMinWidth = marginLeft
        
        // x coordinate between MinX (left) and MaxX (right):
        let randomX = randomInRange(lo: frameMinWidth, hi: frameMaxWidth)
        
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(lo: frameMinHeight, hi: frameMaxHeight)
        
        let randomPoint = CGPoint(x: randomX, y: randomY)
        
        return randomPoint
        
    }
    
    //Generates random time for animal to appear within game time
    private func genRndTimeInGame() -> Double {
        
        let int = UInt32(precision * Double(gameLength))
        return (Double(arc4random_uniform(int)) + 1 * precision)/precision
    }
    
    //Return a random number between two bounds
    private func randomInRange(lo: Int, hi: Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
}

