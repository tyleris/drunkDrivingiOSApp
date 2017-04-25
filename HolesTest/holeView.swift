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
    
    var holeName = "hole"
    
    //MARK: initializers
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addBackground() //Make frame blue for diagnostic purposes
        addHole()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("NSCoding not supported")
    }
    
    convenience init(point: CGPoint){
        let sizeFrameDefault = CGSize(width: 50, height: 50)
        let boxFrame = CGRect(origin: point, size: sizeFrameDefault)
        
        self.init(frame: boxFrame)
    }
    
    //MARK: Actions
    
    //Add animal
    func addAnimal(animalName: String, disappearTime: Double){
        
        if isVisible == false {
        
            //Load animal image
            let animalImage = UIImage(named: animalName)
            animalImageView = UIImageView(image: animalImage)
            
            //Add animal to view
            addSubview(animalImageView)
            
            //add animal name to object property
            self.animalName = animalName
            
            isVisible = true
            self.disappearTime = disappearTime
        }
    }
    
    //ToDo: Create func remove animal
    
    func removeAnimal(){
        animalImageView.removeFromSuperview()
        isVisible = false
        animalName = "None"
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
        
//        let w = Double(sizeHoleDefault.width)
//        let h = Double(sizeHoleDefault.height)
//        
//        //Position right 1/2 diff between widths
//        let originX = 0.5 * (Double(sizeFrameDefault.width) - w)
//        //Position all the way down, except back up hight of hole image
//        let originY = Double(sizeFrameDefault.height) - h
//        let origin = CGPoint(x:originX, y:originY)
// 
//        //Create frame for hole
//        let holeFrame = CGRect(origin: origin, size: sizeHoleDefault)
//        holeImageView.frame = holeFrame
// 
        //Add hole to view
        addSubview(holeImageView)
        
    }
    
    
    private func addBackground(){
        self.backgroundColor = UIColor.blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Get the superview's layout
        let margins = self.layoutMarginsGuide
        
        //Align hole
        
        holeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Pin the bottom edge of hole to the margin's bottom edge
        holeImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        // Pin the left edge of hole to the margin's left edge
        holeImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true

        //Align animal
        
        if self.isVisible == true {
            animalImageView.translatesAutoresizingMaskIntoConstraints = false
            
            //Pin to animal bottom
            animalImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
            
            //Pin to animal bottom
            animalImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        }
        
        
        //resize hole
        
//        var marginHole = holeImageView.layoutMarginsGuide
//        var marginAnimal = animalImageView.layoutMarginsGuide
        //var marginMax = UILayoutGuide. marginHole + marginAnimal
        

        
    }

}
