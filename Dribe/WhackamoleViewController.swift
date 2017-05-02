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
    
    //Game play
    let gameLength = 20 as UInt32
    let minAppearTime = 1 as UInt32
    let waitTime = 2.0
    let countInterval = 0.01
    var precision: Double = 10
    //mindless change for testing purposes
    
    //Animals
    let otherAnimalAppearances = 10
    let targetAppearances = 5
    let animalNames = ["camel","chameleon","cock", "dolphin", "fish", "giraffe", "goose", "horse", "moose", "penguin", "pig", "sheep", "turtle", "unicorn"]
    let targetAnimalName = "giraffe"
    let animalNamesNoTarget = ["camel","chameleon","cock", "dolphin", "fish", "goose", "horse", "moose", "penguin", "pig", "sheep", "turtle", "unicorn"]
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
    
    //MARK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //ToDo: move this to static in properties section
        precision = 1/countInterval
        
        //Set game name to be whackamole
        GlobalData.Settings.gameName = GlobalData.Settings.gameNameWhackamole
        
        //Create holes
        createHoles()
        
        //Randomly decide when animals should appear, and which holes
        setAnimalAppearTimes()
        
        //Print summary of appearances
        for i in 0..<(targetAppearances + otherAnimalAppearances){
            printLog("animal: \(appearInfo[i].animal) target: \(appearInfo[i].target) hole \(appearInfo[i].hole) index: \(i) time: \(appearInfo[i].time)")
        }
        
        //Create a timer
        timer = Timer.scheduledTimer(timeInterval: countInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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
            
                printLog("\(appearInfo[i].time) sec: adding animal: \(appearInfo[i].animal), hole \(appearInfo[i].hole)")
                
                printLog("disappear time set to \(holes[data.hole].disappearTime)")
                
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
                
               
            }
        }
    }
    
    private func makeAnimalsDisappear(){
        
        for i in 0..<appearInfo.count {
            
            let j = appearInfo[i].hole //hole number j
            
            //If counter is equal to a hole's disappear time, then make animal disappear
            if (round(counter * precision) >= round(holes[j].disappearTime * precision)) && (holes[j].isVisible == true) {
                
                holes[j].removeAnimal()
                
                if holes[j].isTarget() == true {
                    
                    removeTargetAnimal(holeNum: j)
                
                } else {
                    removeOtherAnimal(holeNum: j)
                }
                
                printLog("\(counter) sec: \(appearInfo[i].animal) disappeared from hole: \(j)" )
            }
        }
    }
    
    func removeTargetAnimal(holeNum: Int){
        
        printLog("removing target animal from hole number \(holeNum)")
        
        //reset target flags
        guard let tap = successTapGesture else {fatalError("There is no successTapGesture recognizer on animal at hole \(holeNum)")}
        holes[holeNum].removeGestureRecognizer(tap)
        holes[holeNum].target = false
        targetVisibleFlag = false
        
        //record and reset reaction times
        lastReactionTimeLabel.text = "Reaction Time: \(roundToDigit(num: reactionCounter, digits: 2))"
        reactionCounterLabel.text = "Reaction counter:"
        reactionTimeAvg += reactionCounter / Double(targetAppearances)
        reactionTimes.append(reactionCounter)
        reactionCounter = 0
        
        //End game if all target animals have appeared
        if targetAnimalShowCount >= targetAppearances {
            endGame()
        }
    }
    
    func removeOtherAnimal(holeNum: Int){
        holes[holeNum].removeGestureRecognizer(failTapGesture!)
    }
    
    //MARK: Navigation
    
    //End game. Segue to results ViewController
    func endGame(){
        printLog("ending game")
        printLog("reaction time avg: \(reactionTimeAvg)")
        
        for i in 0..<targetAppearances {
            printLog("reation time for target \(i): \(reactionTimes[i])")
        }
        
        GlobalData.DataRaw.reactionTime = reactionTimeAvg
        GlobalData.DataRaw.failCount = failCount
        
        //self.dismiss(animated: false, completion: nil)
        timer.invalidate()
        
        guard let mode = GlobalData.Settings.gamemode else {fatalError("gamemode should be set in order to play game")}
        
        switch mode {
            case GlobalData.Settings.gamemodeDataCollection:
                performSegue(withIdentifier:"segueToEnterTestData", sender: self)
            
            case GlobalData.Settings.gamemodeRealisticTestDrunkness:
                
                GlobalData.WhackamoleBaseline.playedBefore = true
                
                guard let rt = GlobalData.WhackamoleBaseline.rt else {fatalError("Shouldn't be playing realisticTestDrunk without a set baseline")}
                
                if reactionTimeAvg >= rt * GlobalData.WhackamoleBaseline.rtMargin {
                    performSegue(withIdentifier:"segueToFailed", sender: self)
                    print("you failed. rt: \(reactionTimeAvg) vs baseline \(rt) times margin \(GlobalData.WhackamoleBaseline.rtMargin)")
                } else {
                    performSegue(withIdentifier:"segueToPassed", sender: self)
                    print("you passed. rt: \(reactionTimeAvg) vs baseline \(rt) times margin \(GlobalData.WhackamoleBaseline.rtMargin)")
                }
            
            case GlobalData.Settings.gamemodeRealisticSetBaseline:
                
                GlobalData.WhackamoleBaseline.playedBefore = true
                
                performSegue(withIdentifier:"segueToBaselineSet", sender: self)
            
            default: fatalError("incorrect gamemode: \(String(describing: GlobalData.Settings.gamemode))")
        }
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Could pass data here, but doing it with global vars instead
        
    }
    
    //MARK: Tap Gesture Recognizers
    
    //Correct guess
    func handleSuccessTap(_ gestureRecognizer: UITapGestureRecognizer){
        
        annoucementLabel.text = "You touched the target!"
        
        var holeNum: Int?
        
        //Get the hole # tapped
        for i in 0..<holes.count {
            if holes[i].target == true {
                holeNum = i
            }
        }
    
        guard let i = holeNum else {fatalError("no target animal set")}
        
        removeTargetAnimal(holeNum: i)
    }
    
    //Failed tap
    func handleFailTap(_ gestureRecognizer: UITapGestureRecognizer){
        annoucementLabel.text = "I'm not the target! seriously."
        failCount += 1
        failsLabel.text = "Fails: \(failCount)"
    }
    
    //Missed tap
    func handleMissTap(_ gestureRecognizer: UITapGestureRecognizer){
        annoucementLabel.text = "You didn't even click an animal."
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
                printLog("added hole number \(idx) at pt \(holes[idx].frame.origin)")
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
            
            //Pick a time and hole for animal appear (then call occupied functions to test for conflict)
            let time = genRndTimeInGame()
            let hole = setHoleNum()
            let targetAnimal = target //ToDo: Uncessary?
            
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
            
            printLog("trying to place animal: \(tries) times")
            if tries >= 50 {fatalError("Failed to set animal appear time: Over 50 tries")}
            
        } while tryAgain == true

    }
    
    //Return whether hole has animal appearing within the waitTime
    private func isHoleAndTimeOccupied(time: Double, holeNum: Int) -> Bool {
        var occupied = false
        
        for i in 0..<appearInfo.count {
            if ((time >= appearInfo[i].time - waitTime) && (time <= appearInfo[i].time + waitTime)) && (holeNum == appearInfo[i].hole) {
                    occupied = true
            }
        }
        return occupied
    }
    
    private func isTimeOccupied(time: Double) -> Bool {
        var occupied = false
        
        for i in 0..<appearInfo.count {
            if ((time >= appearInfo[i].time - waitTime) && (time <= appearInfo[i].time + waitTime)) {
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
                
                holes[idx].translatesAutoresizingMaskIntoConstraints = false
                
                //arrange in x dimmension
                
                let constraintX = NSLayoutConstraint(item: holes[idx], attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: CGFloat(multiplierX), constant: 0)
                
                // constraint.identifier = "ArrangeInX"
                
                mainView.addConstraint(constraintX)
                printLog("added X constraint to hole #\(idx) @ multiple \(multiplierX)")
                
                //Arrange in y dimmension
                
                let constraintY = NSLayoutConstraint(item: holes[idx], attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: CGFloat(multiplierY), constant: 0)
                
                //constraint.identifier = "ArrangeInY"
                
                mainView.addConstraint(constraintY)
                printLog("added Y constraint to hole #\(idx) @ multiple \(multiplierY)")
                
                //Constrain hole width (and height?)
                //Set size to take up in total 50% of open horizantal space
                let multiplier = CGFloat(1 / Double(holesMaxX) / 2)
                
                holes[idx].widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: multiplier).isActive = true
                printLog("added holeuiview width constraint to hole #\(idx) @ multiple \(multiplier)")
                
                holes[idx].heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: multiplier).isActive = true
                
                printLog("added holeview height constraint to hole #\(idx) @ screen width multiplier \(multiplier)")
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
        
        let min = Double(minAppearTime) * Double(precision)
        let int = UInt32(precision * Double(gameLength) - min)
        return (Double(arc4random_uniform(int)) + min)/precision
    }
    
    //Return a random number between two bounds
    private func randomInRange(lo: Int, hi: Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    private func printLog(_ text: String){
        print(text)
    }
    
}

