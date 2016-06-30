//
//  GameScene.h
//  flappy
//

//  Copyright (c) 2016 Marc. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import AVFoundation;

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
    SKNode * _leftCollider;
    
    
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
    
    
    // ---- SOUND ---- //
    AVAudioPlayer *audio;
}

@end


