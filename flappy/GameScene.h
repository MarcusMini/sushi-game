//
//  GameScene.h
//  flappy
//

//  Copyright (c) 2016 Marc. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>{
    SKSpriteNode * _perso;
    SKColor * _fond;
    
    CGFloat _widthGround;
    CGFloat _heightGround;
    
    // ---- DEFINE TEXTURE VARIABLE ---- //
    
    SKTexture * _upperTube;
    SKTexture * _downTube;
    SKTexture * _soySauceBottle;
    SKTexture * _droplet;
    
    
    // ---- DEFINE ACTION --- //
    
    SKAction * _animObstacle;
    
    SKNode * _noeudMouvment;
    SKNode * _bar;
    
    SKNode * _ObstacleGroup;
    SKNode * _sauceNode;
    
    BOOL _drapRestart;
    BOOL _disableUserInput;
    
    SKLabelNode * _scoreCounter;
    SKSpriteNode * _citySprite;
    SKSpriteNode * _aSprite;
    int  _scoreNumber;
    
    // create an array of ground array;
    
    
    // Remarks
    
    /* 
     
     Variable set with * are pointers.
     Do not break them... in order to not 
     get EXC_BAD_ACCESS error..
     
     */
    
    
}

@end


