//
//  flappyUI.swift
//  flappy
//
//  Created by Marc on 25/06/2016.
//  Copyright © 2016 Marc. All rights reserved.
//

import SpriteKit


class startViewController : UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startView : SKView = self.view as! SKView
        startView.showsFPS = true
        startView.showsNodeCount = true
        
        
        // create the game scene by instanting the class which is an extends of the skscene
        
        let startScene = createUI(size: startView.bounds.size)
        
        //  let loose = looseUI(size: startView.bounds.size)
        
        startScene.scaleMode = .AspectFill
        startView.presentScene(startScene)
    }
}

// @objc prefix allow objective c to call the swift class


@objc class createUI : SKScene{
    
    // create the button
    
    let soundButton : SKSpriteNode = SKSpriteNode(imageNamed: "sound")
    let startButton = SKSpriteNode(imageNamed: "start")
    
    let bg_color : SKColor = UIColor.init(colorLiteralRed: 120 / 255, green: 156 / 255, blue: 176 / 255, alpha: 1.0)
    
    // get the score
    
    let score = UserScore().getScore()

    
    override init(size : CGSize){
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToView(view: SKView) {
        // main func here
        self.backgroundColor = bg_color
        posButton()
        createButton()
        setLabelScore()
        chooseImage()
    }
    
    
    // reset the sound button by checking the preference
    func chooseImage() -> Bool{
        let pref : Bool =  SoundPreference().getSoundPref()
        print(pref)
        if pref != false{
           soundButton.texture = SKTexture(imageNamed: "sound")
        } else{
           soundButton.texture = SKTexture(imageNamed: "nosound")
        }
        
        
        return pref
    }
    
    
    func setLabelScore(){
        let labelScore = SKLabelNode.init(text: "Your high-score is \(score)")
        labelScore.position = CGPointMake(self.frame.size.width / 2, 20)
        self.addChild(labelScore)
    }
    
    
    func setName(){
        // set the name of the button in order to know which has been touch
        startButton.name = "start";
        soundButton.name = "sound";
    }
    
    
    func posButton(){
        startButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 50)
        soundButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
    }
    
    
    func createButton(){
        
        // change button image 
        
        
        self.addChild(startButton)
        self.addChild(soundButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        
        if startButton.containsPoint(touch.locationInNode(self)){
            // instantiate the game scene
            print("click la")
            let transition = SKTransition.fadeWithDuration(2.0)
            let gameScene = GameScene(size: self.view!.bounds.size)
            self.scene!.view?.presentScene(gameScene, transition : transition)
        }
        else if soundButton.containsPoint(touch.locationInNode(self)){
            let currentpref = chooseImage()
            
            SoundPreference().setSounds(!currentpref)
            chooseImage()
            
            // control the sound
            
        }
        
    }
}



@objc class UILoose : SKScene{
    
    var scoreValue : Int = 0
    // define a color constant
    
    let score_bg = SKColor.init(colorLiteralRed: 94 / 255, green: 165 / 255, blue: 204 / 255, alpha: 0.5)
    let replayBut : SKSpriteNode = SKSpriteNode(imageNamed: "restart")
    let menuButton : SKSpriteNode = SKSpriteNode(imageNamed: "menu")
    let transition = SKTransition.fadeWithDuration(2.0)
    
    
    init(size : CGSize, userScore : Int){
        scoreValue = userScore
        
        let oldScore = UserScore().getScore()
        
        if oldScore < scoreValue{
            UserScore().setScore(scoreValue)
        }
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToView(view: SKView) {
        // main func here
        self.backgroundColor = score_bg
        showScore()
        addButton()
    }
    
    func showScore(){
        let scoreText : SKLabelNode = SKLabelNode.init(fontNamed: "slkscrb-1")
        
        // positionning the text
        
        scoreText.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        
        scoreText.text = "Your score is \(String(scoreValue))";

        self.addChild(scoreText)
    }
    
    
    func addButton(){
        
        
        replayBut.position = CGPointMake(self.frame.size.width / 2 - 90, self.frame.size.height / 2 - 100)
        
        
        menuButton.position = CGPointMake(self.frame.size.width / 2 + 90, self.frame.size.height / 2 - 100)
        
        // add the button
        self.addChild(replayBut)
        self.addChild(menuButton)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        if replayBut.containsPoint(touch.locationInNode(self)){
            // instantiate the game scene
            
            let gameScene = GameScene(size: self.view!.bounds.size)
            self.scene!.view?.presentScene(gameScene, transition : transition)
        }
        else if menuButton.containsPoint(touch.locationInNode(self)){
            let menuScene = createUI(size: self.view!.bounds.size)
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
    }
    
}

// user pref

class UserScore : NSUserDefaults{
    
    // init the user default object
    let user_defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func setScore(Userscore : Int){
        user_defaults.setInteger(Userscore, forKey: "flappy-sushi-score")
    }
    
    func getScore() -> Int{
        return user_defaults.integerForKey("flappy-sushi-score")
    }
}


class SoundPreference : NSUserDefaults{
    let sound_preference : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func setSounds(ShouldPlay : Bool){
        sound_preference.setBool(ShouldPlay, forKey: "sound_preference")
    }
    
    func getSoundPref() -> Bool{
        return sound_preference.boolForKey("sound_preference")
    }
}


