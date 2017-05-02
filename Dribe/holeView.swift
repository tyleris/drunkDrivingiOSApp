//
//  holeView.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/18/17.
//
//

import UIKit

class holeView: UIView {
    
    //MARK: Properties
    
    var holeImageView = UIImageView()
    var animalImageView = UIImageView() //why do these differently? b/c one loads at startup?
    
    let sizeFrameDefault = CGSize(width: 50, height: 50)
    let sizeHoleDefault = CGSize(width: 80, height: 80)
    var target: Bool = false
    var disappearTime: Double = 0
    var isVisible = false
    var animalName: String = "None"
    var holeAspectRatio: CGFloat?
    var animalAspectRatio: CGFloat?
    //random change to delete later
    
    var holeName = "hole"
    
    //MARK: initializers
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //Make frame blue for diagnostic purposes
        //addBackground()
        
        addHole()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("NSCoding not supported")
    }
    
    convenience init(point: CGPoint){
        let sizeFrameDefault = CGSize(width: 150, height: 150)
        let boxFrame = CGRect(origin: point, size: sizeFrameDefault)
        
        self.init(frame: boxFrame)
    }
    
    //MARK: Actions
    
    //Add animal
    func addAnimal(animalName: String, disappearTime: Double){
        
        //If you call addAnimal, and there is already an animal there, then nothing happnes
        if isVisible == false {
        
            //Load animal image
            guard let animalImage = UIImage(named: animalName) else {fatalError("No animal named \(animalName)")}
            
            animalImageView = UIImageView(image: animalImage)

            //Add animal to view
            addSubview(animalImageView)
            
            animalAspectRatio = CGFloat(animalImageView.frame.height / animalImageView.frame.width)
            
            //add animal name to object property
            self.animalName = animalName
            
            isVisible = true
            self.disappearTime = disappearTime
        } else {
            fatalError("Can't call addAnimal when animal already there")
        }
    }
    
    //ToDo: Create func remove animal
    
    func removeAnimal(){
        animalImageView.removeFromSuperview()
        isVisible = false
        animalName = "None"
        //Should it also remove target automatically?
    }
    
    func makeTarget(){
        target = true
    }
    
    func removeTarget(){
        target = false
    }
    
    //Return whether is target or not
    func isTarget()-> Bool{
        return target
    }
    
    //MARK: Private functions
    
    func addHole(){
        
        //Load hole image
        let holeImage = UIImage(named: "hole")
        holeImageView = UIImageView(image: holeImage)
        
        //Add hole to view
        addSubview(holeImageView)
        
        holeAspectRatio = CGFloat(holeImageView.frame.height / holeImageView.frame.width)
        
    }
    
    
    private func addBackground(){
        self.backgroundColor = UIColor.blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Align hole to UIview

        holeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Pin the bottom edge of hole to the margin's bottom edge
        holeImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        printLog("added holeImage constraint bottom anchor")
        
        // Pin the left edge of hole to the margin's left edge
        holeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        printLog("added holeImage constraint leading anchor")
        
        //Constrain height to maintain aspect ratio
        
        guard let AR = holeAspectRatio else {fatalError("aspect ratio not set. Should have been set when addHole called during object load")}
        
        holeImageView.heightAnchor.constraint(equalTo: holeImageView.widthAnchor, multiplier: AR).isActive = true
        printLog("added holeImage height aspect ratio  constraint")
        
        //holeImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        // Pin the right edge of hole to the margin's right edge
        holeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        printLog("added holeImage constraint trailing anchor")
        
        //Align animal
        
        if self.isVisible == true {
            
            animalImageView.translatesAutoresizingMaskIntoConstraints = false
            
            //Pin to animal bottom
            animalImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            printLog("added animalImage constraint bottom anchor")
            
            //Pin to animal left
            animalImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            printLog("added animalImage constraint leading anchor")
            
            //Set animal aspect ratio
            guard let aspectRatio = animalAspectRatio else {fatalError("Aspect ratio not set yet. It should have been set in addAnimal method")}
            printLog("aspect ratio \(aspectRatio)")
            
            animalImageView.heightAnchor.constraint(equalTo: animalImageView.widthAnchor, multiplier: aspectRatio).isActive = true
            printLog("added animalImage constraint height aspect ratio anchor")
            
            //Pin to animal right
            animalImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            printLog("added animalImage constraint trailing anchor")
        }
    }
    
    func printLog(_ text:String){
        //print(text)
    }
}
