//
//  ViewController.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/17/17.
//
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var hole1ImageView: UIImageView!
    @IBOutlet weak var hole2ImageView: UIImageView!
    @IBOutlet weak var hole3ImageView: UIImageView!
    @IBOutlet weak var elephantImageView: UIImageView!
    @IBOutlet weak var badgerImageView: UIImageView!
    @IBOutlet weak var groundhogImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    //ToDo: Move arrays to load function? will I need to define them globally?
    var holes = [UIImageView]()
    var animals = [String: UIImageView]()
    var rectOverHoles = [CGRect]()
    var animalShowTimes = [String: Double]()
    var timer = Timer()
    var counter = 0.0
    var reactionTime = 0.0
    
    let holesMax = 3 //Note right now not programatically linked to # of holes
    let gameLength = 10 as UInt32
    let minAppearTime = 1 as UInt32
    let waitTime = 2.0
    let countInterval = 0.1
    let targetAnimal = "groundhog"
    
    //ToDo create AnimalUIImageView class that is subclass of UIImageView. It should have a show time, hide ttime, and a position (already got that), and clickable (got that)
    //ToDo create a holeUIImageView class that has rect with it, and true/false got animal on it
    
    //ToDo: Create offsets for each animal so they apear right on the hole
    //ToDo: Trim the images so they appear right over the hole
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ToDo: Create hole images programatically so there can be any number of holes
        
        //Create array vars
        holes = [hole1ImageView, hole2ImageView, hole3ImageView]
        animals = ["elephant": elephantImageView, "badger": badgerImageView, "groundhog": groundhogImageView]
        //just create placeholder array to fill later
        for _ in 0..<holesMax {
            rectOverHoles.append(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        
        //Randomly place the holes
        for hole in holes {
            placeHoles(hole: hole, index: holes.index(of: hole)!)
        }
        
        //Randomly decide when animals should appear
        for (name, _) in animals {
            animalShowTimes[name] = generateRandomTime()
        }
        
        //Create a timer
        var timer = Timer.scheduledTimer(timeInterval: countInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        //Create tap button recognizer
        //ToDo: make the tapGestureRecognizer into an object reveal image can use, or pass it?
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        //ToDo: add the gesture recognizer to the reveal image function
        //imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Timers
    
    func update(){
        //Time starts counting
        counter += countInterval
        countLabel.text = "Count: \(counter)"
        
        //start counting reaction time only once the target animal is visible
        if animals[targetAnimal]?.isHidden == false {
            reactionTime += countInterval
        }
        
        //Make animals appears / disappear when counter reaches showTime or hide time for each animal
        for (animalName, animalImage) in animals {
            decideAnimalVisibility(imageView: animalImage, counter: counter, showTime: animalShowTimes[animalName]!)
        }
    }
    
    //MARK: Tap action
    /*
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
        print("Did you just tap me?")
     
        //ToDo: Add if statment to see if you clicked the grounghog
    }
 */
    
    //ToDo: stop timer, record time. Save to avg time. test whether hit no animal, wrong animal, right animal.
    
    //MARK: Private methods
    
    //Place holes on canvas at load, ensuring not on or above another hole
    private func placeHoles(hole: UIImageView, index: Int){
     
        let hW = Double(hole.frame.size.width)
        let hH = Double(hole.frame.size.height)
        let aH = Double((animals["groundhog"]?.frame.size.height)!) //Could change to max animal size
        var sP : CGPoint?
        
        //Ensure new hole doesn't overlap with any existing hole or margin for animal
        var overlapping = false
        var repeatCount = 0
        repeat {
            overlapping = false
            sP = spawnAtRandomPosition()
            let x = Double(sP!.x)
            let y = Double(sP!.y)
        
            let size = CGSize(width: hW, height: aH + 0.5 * hH)
            let point = CGPoint(x: x, y: y - 0.5 * aH)
            
            let rect = CGRect(origin: point, size: size)
        
            //try again if spawnPoint ontop of hole or would be on animal when animal is on it
            //Create function to see if on top of other holes return boolean
            for r in rectOverHoles {
                if r.intersects(rect) {
                    overlapping = true
                }
            }
            rectOverHoles[index] = rect
            repeatCount += 1
            if repeatCount > 50 {fatalError("\(repeatCount) repeats, something is wrong")}
        } while overlapping == true
        
        hole.center = sP!
    }
    
    //Decide whether to hide or unhide object
    private func decideAnimalVisibility(imageView: UIImageView, counter: Double, showTime: Double){

        let hideTime = showTime + waitTime

        //if counter time between show and hide time, then reveal image
        if counter >= showTime && counter <= hideTime && imageView.isHidden == true {
            //reveal image of animal
            revealImage(imageView: imageView)
        } else if counter >= hideTime && imageView.isHidden == false {
            imageView.isHidden = true
            
            //ToDo: make image no longer touchabel. Is this right code below?
            imageView.isUserInteractionEnabled = false
        }
    }
    
    //Reveals an image on a random hole, enables user interaction, makes visible, and on top
    private func revealImage(imageView: UIImageView){
        
        //Place animal feet on center of hole (offset animal up y-axis by 1/2 height)
        let idx = pickHole()
        let x = holes[idx].center.x
        let y = holes[idx].center.y - 0.5 * imageView.frame.size.height
        imageView.center = CGPoint(x: x, y: y)
        
        imageView.isUserInteractionEnabled = true
        imageView.superview?.bringSubview(toFront: imageView)
        imageView.isHidden = false
    }
    
    //Randomly decide which hole to place animal on, ensuring no concurrent overlap
    private func pickHole()-> Int{
        
        let holeIndex = randomInRange(lo: 0, hi: holesMax - 1)
        //var repeatCount = 0
        //var occupied = false
        
        //Ensure it doesn't overlap
        /*
        repeat {
            holeIndex = randomInRange(lo: 0, hi: holesMax - 1)
            if {
                occupied = false
            }
            
        } while occupied == true
        */
        
        return holeIndex
        
        //ToDo: this should return a hole object, not just a number, maybe?
    }
    
    //Generates random time for animal to appear within game time
    private func generateRandomTime() -> Double {
        return Double((arc4random_uniform(gameLength * 10) + 10)/10)
    }
    
    //Return a random point within frame to place something
    private func spawnAtRandomPosition() -> CGPoint {
        
        //ToDo: ensure not on top of any other holes
        
        //Set max and min of frame
        //ToDo: set max min programatically
        let frameMaxHeight = 600 // Int(CGRectGetMaxX(self.frame))
        let frameMinHeight = 64 //Int(CGRectGetMinX(self.frame))
        let frameMaxWidth = 330//Int(CGRectGetMidY(self.frame))
        let frameMinWidth = 50 //Int(CGRectGetMinY(self.frame))
        
        // x coordinate between MinX (left) and MaxX (right):
        let randomX = randomInRange(lo: frameMinWidth, hi: frameMaxWidth)
        
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(lo: frameMinHeight, hi: frameMaxHeight)
        
        let randomPoint = CGPoint(x: randomX, y: randomY)
        return randomPoint
    }
    
    //Return a random number between two bounds
    private func randomInRange(lo: Int, hi: Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
}

