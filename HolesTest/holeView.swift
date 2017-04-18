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
    
    let holeImageView = UIImageView()
    let animalImageView = UIImageView() //why do these differently? b/c one loads at startup?
    
    let sizeFrameDefault = CGSize(width: 200, height: 168)
    let sizeHoleDefault = CGSize(width: 80, height: 80)
    var target: Bool = false
    
    //MARK: initializers
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addBackground()
        addHole()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("NSCoding not supported")
    }
    
    convenience init(point: CGPoint){
        let sizeFrameDefault = CGSize(width: 200, height: 128 + 0.5 * 80)
        let boxFrame = CGRect(origin: point, size: sizeFrameDefault)
        
        self.init(frame: boxFrame)
    }
    
    //MARK: Actions
    
    //Add animal
    
    func addAnimal(animalName: String){
        
        //Load animal image
        let animalImage = UIImage(named: animalName)
        let animalImageView = UIImageView(image: animalImage)
        
        var animalFrame = animalImageView.frame
        let AnimalHeight = animalFrame.height
        let AnimalWidth = animalFrame.width
        
        //let boxHeight = self.frame.height
        let boxWidth = self.frame.width
        
        //let holeX = holeImageView.frame.origin.x
        let holeY = holeImageView.frame.origin.y
        //Should I gaurd against non valid animal name?
        
        let xPos = 0.5 * (boxWidth - AnimalWidth)
        let yPos = holeY + AnimalHeight
        
        //Set animal to appear right in middle of hole
        animalFrame.origin =  CGPoint(x: xPos, y: yPos)
        
        //Add animal to view
        addSubview(animalImageView)
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
    
    //
    
    //MARK: Private functions
    
    func addHole(){
        
        //Load hole image
        let holeImage = UIImage(named: "hole")
        let holeImageView = UIImageView(image: holeImage)
        
        let w = Double(sizeHoleDefault.width)
        let h = Double(sizeHoleDefault.height)
        
        //Position right 1/2 diff between widths
        let originX = 0.5 * (Double(sizeFrameDefault.width) - w)
        //Position all the way down, except back up hight of hole image
        let originY = Double(sizeFrameDefault.height) - h
        let origin = CGPoint(x:originX, y:originY)
        
        //Create frame for hole
        let holeFrame = CGRect(origin: origin, size: sizeHoleDefault)
        holeImageView.frame = holeFrame
        
        //Add hole to view
        addSubview(holeImageView)
    }
    
    
    func addBackground(){
        self.backgroundColor = UIColor.blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //holeImageView.frame.size = CGSize(width: 40, height: 40)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
