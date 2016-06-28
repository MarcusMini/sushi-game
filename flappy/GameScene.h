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
    SKTexture * _heartTexture;
    
    
    // ---- DEFINE ACTION --- //
    
    SKAction * _animObstacle;
    
    // ---- DEFINE NODE ---- //
    
    SKNode * _noeudMouvment;
    SKNode * _bar;
    
    SKNode * _ObstacleGroup;
    SKNode * _sauceNode;
    SKNode * _dropletNode;
    SKNode * _scNode;
    SKNode * _heartNode;
    
    
    // ----- sprite node --- //
    
    
    // ---- BOOLEAN ---- //
    
    BOOL _drapRestart;
    BOOL _disableUserInput;
    
    SKLabelNode * _scoreCounter;
    SKSpriteNode * _citySprite;
    SKSpriteNode * _aSprite;
    
    
    // ---- INT ----- //
    
    int  _scoreNumber;
    int _dis;
    int _posNode;
    int _forceX;
    int _less;
    int _life;
    
    // create an array of ground array;
    
    
    // Remarks
    
    /* 
     
     Variable set with * are pointers.
     Do not break them... in order to not 
     get EXC_BAD_ACCESS error..
     
     */
    
    
}

@end


