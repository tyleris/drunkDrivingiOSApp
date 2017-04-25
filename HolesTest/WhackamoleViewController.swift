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
    let holesMax = 12
    let holesMaxX = 3
    let holesMaxY = 4
    
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
    var precision: Double = 10
    
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
        createHoles()
        
        //Randomly decide when animals should appear, and which holes
        setAnimalAppearTimes()
        
        //Create a timer
        var timer = Timer.scheduledTimer(timeInterval: countInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        // //dont need this
        
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
        
        //For every animal that needs to appear
        for i in 0..<appearInfo.count {
            
            let data = appearInfo[i]
            
            //If the counter reaches appear time, then make animal appear on hole
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
    
    func createHoles(){
        
        //Create grid of holes
        for j in 0..<(holesMaxY) {
            for i in 0..<(holesMaxX) {
                
                let hole = holeView(point: CGPoint(x: 0, y: 0))
                holes.append(hole)
                
                let idx = ConvertHoleCoordToScalar(x: i, y: j)
                mainView.addSubview(holes[idx])
                print("added hole number \(idx) at pt \(holes[idx].frame.origin)")
            }
        }
        
        createGridLayout() //should it pass the holes? Nah
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
    
    //Add an animal to hole and time that is unoccupied
    private func addAnimal(target: Bool){
        var tries = 0
        var tryAgain = false
        var animal = ""
        
        //Keep trying until find unoccupied hole
        repeat {
            tryAgain = false
            
            //Pick a time and hole for animal appear (later test if there is conflict)
            let time = genRndTimeInGame()
            let hole = setHoleNum()
            let targetAnimal = target
            
            //Pick animal name (based on whether or not target)
            if target == true {
                animal = targetAnimalName
                
                if isTimeOccupied(time: time) == true {
                    tryAgain = true
                }
                
            } else {
                
                //if not target, pick random animal
                let idx = randomInRange(lo: 0, hi: animalNames.count - 2)
                animal = animalNamesNoTarget[idx]
                
                if isHoleAndTimeOccupied(time: time, holeNum: hole) == true {
                    tryAgain = true
                }
            }
    
            //Only append new animal appearence if everything works out
            if tryAgain == false {
                appearInfo += [(time: time, animal: animal, target: targetAnimal, hole: hole)]
            }
            
            tries += 1
            
            print("trying to place animal: \(tries) times")
            if tries >= 50 {fatalError("Failed to set animal appear time: Over 50 tries")}
            
        } while tryAgain == true

    }
    
    //Return whether hole has animal appearing within the waitTime
    private func isHoleAndTimeOccupied(time: Double, holeNum: Int) -> Bool {
        var occupied = false
        
        for i in 0..<appearInfo.count {
            if ((time >= appearInfo[i].time) && (time <= appearInfo[i].time + waitTime)) && (holeNum == appearInfo[i].hole) {
                    occupied = true
            }
        }
        return occupied
    }
    
    private func isTimeOccupied(time: Double) -> Bool {
        var occupied = false
        
        for i in 0..<appearInfo.count {
            if ((time >= appearInfo[i].time) && (time <= appearInfo[i].time + waitTime)) {
                occupied = true
            }
        }
        return occupied
        
    }
    
    //MARK: Layout
    
    //Create grid of holes
    private func createGridLayout(){
        
        //do all holes
        for j in 0..<(holesMaxY) {
            for i in 0..<(holesMaxX) {
                
                let idx = ConvertHoleCoordToScalar(x: i, y: j)
                let multiplierX = (Double(i)+1) * 2 / (Double(holesMaxX) + 1)
                let multiplierY = (Double(j)+1) * 2 / (Double(holesMaxY) + 1)
                let adjX = CGFloat(holes[idx].frame.width) / -2
                let adjY: CGFloat = 0 //CGFloat(holes[idx].frame.height) / -2
                
                holes[idx].translatesAutoresizingMaskIntoConstraints = false
                
                //arrange in x dimmension
                
                let constraintX = NSLayoutConstraint(item: holes[idx], attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: CGFloat(multiplierX), constant: adjX)
                
                // constraint.identifier = "ArrangeInX"
                
                mainView.addConstraint(constraintX)
                print("added X constraint to \(holes[idx]) @ multiple \(multiplierX)")
                
                //Arrange in y dimmension
                
                let constraintY = NSLayoutConstraint(item: holes[idx], attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: CGFloat(multiplierY), constant: adjY)
                
                //constraint.identifier = "ArrangeInY"
                
                mainView.addConstraint(constraintY)
                print("added Y constraint to hole #\(idx) @ multiple \(multiplierY)")
                
                //NEED TO CONSTRAIN HOLE SIZE!
                //
                
            }
        }
    }

    //MARK: math functions
    
    private func roundToDigit(num: Double, digits: Int) -> Double{
        
        return (round(num * Double(digits) * 10) / (Double(digits) * 10))
    }
    
    private func ConvertHoleScalarToCoord(num: Int)-> (Int, Int) {
        
        let x = Int(floor(Double(num) / Double(holesMaxY)))
        let y = Int(remainder(Double(num), Double(holesMaxY)))
        return (x, y)
    }
    
    private func ConvertHoleCoordToScalar(x: Int, y: Int)-> Int {
        
        return x + y * holesMaxX
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

