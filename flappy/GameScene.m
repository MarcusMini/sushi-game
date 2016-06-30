//
//  GameScene.m
//  flappy
//
//  Created by Marc on 31/05/2016.
//  Copyright (c) 2016 Marc. All rights reserved.
//

#import "GameScene.h"
#import "flappy-Swift.h"

@implementation GameScene

static const uint32_t persoCategory = 1 << 0;
static const uint32_t obstacleCategory = 1 << 1;
static const uint32_t scoreCategory = 1 << 2;
static const uint32_t soyDroplet = 1 << 3;
static const uint32_t mondeCategory = 1 << 4;
static const uint32_t killCategory = 1 << 5;


-(id) initWithSize:(CGSize)size {
    
    // init scene
    if(self = [super initWithSize:size]){
        [self createContent];
    }

    
    return self;
}


-(void) createContent{
    
    // get the file path of the sound
    NSURL *url = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource : @"song" ofType: @"mp3"]];
    
    // init the audio player
    
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
    
    
    // --- INIT NODE --- //
    
    _noeudMouvment = [SKNode node];
    _ObstacleGroup = [SKNode node];
    _sauceNode = [SKNode node];
    _dropletNode = [SKNode node];
    _leftCollider = [SKNode node];
    
    // --- INIT VALUE --- //
    
    _less = 400;    // Based value which is use to control the force of the sushi
    
    _life = 4;  // life of the sushi
    
    _forceX = -100; // trick in order to align the droplet of soy sauce
    
    self.physicsWorld.contactDelegate = self;
    
    // loop value
    int looper = 0;
    int looperCity = 0;
    
    // width of the texture
    int sizeT = 0;
    int sizeC = 0;
    
    
    // allow the user to interact with the sushi
    _disableUserInput = NO;
    
    // add the score...
    _scoreNumber = 0;
    _scoreCounter = [SKLabelNode labelNodeWithFontNamed:@"slkscrb.ttf"];
    _scoreCounter.text = 0;
    _scoreCounter.position = CGPointMake(self.size.width / 2, self.size.height / 1.5);
    _scoreCounter.fontSize = 35;
    
    // add background color
    _fond = [SKColor colorWithRed: 120.0 / 255.0 green: 156.0 / 255.0 blue: 176.0 / 255.0 alpha:1.0];
    
    // atlas
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed: @"Sprites"];
    
    
    // ---------- TEXTURE ---------- //
    
    SKTexture *myTexture = [atlas textureNamed:@"ground"];
    SKTexture *city = [atlas textureNamed:@"bg_scenery"];
    SKTexture *user = [atlas textureNamed:@"one"];
    SKTexture *user_two = [atlas textureNamed:@"two"];
    _upperTube = [atlas textureNamed: @"chopstick_one"];
    _downTube = [atlas textureNamed: @"chopstick_two"];
    _soySauceBottle = [atlas textureNamed : @"soy_sauce_bottle"];
    _droplet = [atlas textureNamed:@"soy-sauce-droplet"];
    _heartTexture = [atlas textureNamed:@"heart"];
    
    
    // call create obstacle
    
    
    SKAction *newObstacle = [SKAction performSelector: @selector(createObstacle) onTarget:self];
    SKAction *pause = [SKAction waitForDuration: 2.0];
    SKAction *animNewObs = [SKAction sequence: @[newObstacle, pause]];
    SKAction *animNouvelObstacleContinu = [SKAction repeatActionForever: animNewObs ];
    
    
    // create new soy sauce
    
    SKAction *soySauceAction = [SKAction performSelector: @selector(createSoySauce) onTarget:self];
    SKAction *pauseSauce = [SKAction waitForDuration: 10.0];
    SKAction *animNewSoySauceObstalce = [SKAction sequence:@[soySauceAction, pauseSauce]];
    SKAction *animSauce = [SKAction repeatActionForever: animNewSoySauceObstalce];
    
    // create droplet anim of the soy sauce
    
    SKAction *dropletAction = [SKAction performSelector: @selector(createDropplet) onTarget:self];
    SKAction *pauseDroplet = [SKAction waitForDuration: 1.0];
    SKAction *animDropletObstacle = [SKAction sequence: @[dropletAction, pauseDroplet]];
    SKAction *animDroplet = [SKAction repeatActionForever: animDropletObstacle];
    
    // anim of the restaurant...
    
    SKAction *anim = [SKAction repeatActionForever: [SKAction animateWithTextures: @[user, user_two] timePerFrame:0.2]];
    SKAction *moveLandscape = [SKAction moveByX: -city.size.width * 2  y: 0 duration: 0.1 * city.size.width * 2];
    SKAction *resetLand = [SKAction moveByX:city.size.width * 2 y:0 duration:0];
    SKAction *animLandscape = [SKAction repeatActionForever: [SKAction sequence: @[moveLandscape, resetLand]]];
    

    // anim of the ground (seats)
    
    SKAction *moveGround = [SKAction moveByX: -myTexture.size.width  y: 0 duration: 0.1 * myTexture.size.width];
    
    SKAction *resetGround = [SKAction moveByX:myTexture.size.width  y:0 duration:0];
    SKAction *animSol = [SKAction repeatActionForever: [SKAction sequence: @[moveGround, resetGround]]];
    
    // add texture to user
    
    _perso = [SKSpriteNode spriteNodeWithTexture: user];
    _perso.position = CGPointMake(self.frame.size.width / 6, self.frame.size.height / 2);
    
    
    // add physics to the user
    
    
    _perso.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: _perso.size.height / 2];
    // physics enable
    _perso.physicsBody.dynamic = YES;
    // the user is subject to gravity
    _perso.physicsBody.affectedByGravity = YES;
    // he's not affected by the rotation
    _perso.physicsBody.allowsRotation = NO;
    _perso.physicsBody.velocity = CGVectorMake(0, 0);
    _perso.physicsBody.categoryBitMask = persoCategory;
    _perso.physicsBody.collisionBitMask = mondeCategory | obstacleCategory | soyDroplet;
    _perso.physicsBody.contactTestBitMask = mondeCategory | obstacleCategory | soyDroplet;
    
    
    
    // apply the texture of the seats
    
    
    while(looper < (self.frame.size.width + sizeT)){
        _aSprite = [SKSpriteNode spriteNodeWithTexture: myTexture];
        _aSprite.position = CGPointMake(looper, 50);
        [_aSprite setScale: 1.0];
        [_noeudMouvment addChild: _aSprite];
        looper += _aSprite.size.width;
        [_aSprite runAction: animSol withKey: @"ground"];
        sizeT = _aSprite.size.width;
        
        _heightGround = (CGFloat) _aSprite.size.height;
        _widthGround =  (CGFloat) looper;
        
    }
    
    
    // create an empty sprite which simulated the physics of the ground
    CGSize sizeGround =CGSizeMake(_widthGround * 2, _heightGround * 2 - 15);
    SKNode *ground = [SKNode node];
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: sizeGround];
    ground.physicsBody.dynamic = NO;
    ground.position = CGPointMake(0,0);
    
    ground.physicsBody.categoryBitMask = mondeCategory;
    ground.physicsBody.contactTestBitMask = persoCategory;
    
    
    
    // add the restaurant
    
    while(looperCity < (self.frame.size.width + sizeC)){
        _citySprite = [SKSpriteNode spriteNodeWithTexture: city];
        _citySprite.position = CGPointMake(looperCity, (_heightGround * 2));
        [_citySprite setScale: 1];
        [_noeudMouvment addChild:_citySprite];
        _citySprite.zPosition = -15;
        sizeC = _citySprite.size.width * 2;
        looperCity += _citySprite.size.width;
        [_citySprite runAction: animLandscape withKey: @"restaurant"];
    }
    
    
    // add the left collider in order for the sushi to not get out of the window
    
    
    _leftCollider.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(1.0, self.frame.size.height * 2)];
    
    _leftCollider.position = CGPointMake(0,0);
    _leftCollider.physicsBody.dynamic = NO;
    
    _leftCollider.physicsBody.categoryBitMask = killCategory;
    _leftCollider.physicsBody.contactTestBitMask = persoCategory;
    
    
    [self addChild: _noeudMouvment];
    [_noeudMouvment addChild : ground];
    [_noeudMouvment addChild : _perso];
    [_noeudMouvment addChild: _scoreCounter];
    [_perso runAction: anim];
    [_perso setScale: 0.1];
    [_noeudMouvment addChild: _ObstacleGroup];
    [_noeudMouvment addChild: _sauceNode];
    [_noeudMouvment addChild: _dropletNode];
    [self addChild: _leftCollider];
    [self runAction: animNouvelObstacleContinu withKey :@"obstalceAction"];
    [self runAction: animSauce];
    [self runAction: animDroplet];
    [self setBackgroundColor: _fond];
    [self createHeart];
    
    
    
    // update the gravity
    // start playing the sound
    
    
    // get it's user preference
    bool canWePlay = [[NSUserDefaults standardUserDefaults] boolForKey: @"sound_preference"];
    
    if(canWePlay){
        [audio play];
    }
    
    
    self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
    
    
}

-(void) createObstacle{
    // space
    const double space_const = 100;
    
    int posy = 0;
    
    // get the texture
    CGFloat textureSizeX = 0;
    CGFloat textureSizeY = 0;
    
    textureSizeX = _upperTube.size.width;
    textureSizeY = _upperTube.size.height;
    
    
    // create node
    
    _bar = [SKNode node];
    _bar.position = CGPointMake(self.frame.size.width + (_upperTube.size.width), 0);
    _bar.zPosition = -10;
    
    // posy
    
    posy = arc4random_uniform((self.frame.size.height) / 3);
    
    // define sprite of the chopsticks
    
    SKSpriteNode *downSprite = [SKSpriteNode spriteNodeWithTexture: _upperTube];
    downSprite.position = CGPointMake(0, posy);
    
    SKSpriteNode *upSprite = [SKSpriteNode spriteNodeWithTexture: _downTube];
    upSprite.position = CGPointMake(0, (posy+downSprite.size.height+ space_const));
    
    // add physics and set it
    
    downSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(textureSizeX, textureSizeY)];
    upSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(textureSizeX, textureSizeY)];
    
    downSprite.physicsBody.dynamic = NO;
    upSprite.physicsBody.dynamic = NO;
    
    downSprite.physicsBody.contactTestBitMask = persoCategory;
    downSprite.physicsBody.categoryBitMask = obstacleCategory;

    upSprite.physicsBody.contactTestBitMask = persoCategory;
    upSprite.physicsBody.categoryBitMask = obstacleCategory;
    
    
    // node to get the score using a new collider
    
    
    CGSize sizeCollider = CGSizeMake((downSprite.size.width - 3), (downSprite.size.height - space_const ));
  
    SKNode *scoreNode = [SKSpriteNode spriteNodeWithColor: [SKColor colorWithRed: 0 green:0 blue:0 alpha:0]  size: CGSizeMake((downSprite.size.width - 3), downSprite.size.height - space_const)];
    
    scoreNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: sizeCollider];

    scoreNode.physicsBody.dynamic = NO;
    scoreNode.position = CGPointMake(downSprite.size.width, (downSprite.position.y + (space_const + 50)));
    
    scoreNode.physicsBody.contactTestBitMask = persoCategory;
    scoreNode.physicsBody.categoryBitMask = scoreCategory;
    
    int distance = (self.frame.size.width + (textureSizeX * 2));
    
    // define action
    
    SKAction *bougerObstacle = [SKAction moveByX: -distance y : 0 duration: 0.01 * distance];
    SKAction *supprimerObstacle = [SKAction removeFromParent];
    
     SKAction *animObs = [SKAction repeatActionForever: [SKAction sequence: @[bougerObstacle, supprimerObstacle]]];
    
    [_bar runAction: animObs];
    [_bar addChild : downSprite];
    [_bar addChild : upSprite];
    [_bar addChild: scoreNode];
    [_ObstacleGroup addChild: _bar];
}

-(void) createHeart{
    
    // create life
    
    int counter = 0;
    int invertcounter = 4;
    
    // create the heart and add it on the scene
    while(counter < _life){
        SKSpriteNode *heart = [SKSpriteNode spriteNodeWithTexture: _heartTexture];
        heart.position = CGPointMake((invertcounter * 20 + 20), self.frame.size.height - 20);
        [heart setScale: 0.5];
        [heart setName: @"heart"];
        [self addChild: heart];
        ++counter;
        --invertcounter;
    }
}


-(void) createSoySauce{
    
    // create soy sauce bottle
    
    _scNode = [SKNode node];
    SKSpriteNode *soySauceNode = [SKSpriteNode spriteNodeWithTexture: _soySauceBottle];
    
    // position soy sauce
    soySauceNode.position = CGPointMake(self.frame.size.width + 50, (self.frame.size.height - 10));
    soySauceNode.zPosition = -10;
    [soySauceNode setScale: 0.2];
    
    _dis = (self.frame.size.width + _soySauceBottle.size.width * 2);
    
    // set the actions of the soy sauce bottle
    SKAction *moveSauceBottle = [SKAction moveByX : - _dis y: 0 duration: 0.01 * _dis];
    SKAction *deleteSauceBottle = [SKAction removeFromParent];
    
    SKAction *animSoy = [SKAction repeatActionForever: [SKAction sequence: @[moveSauceBottle, deleteSauceBottle]]];
    
    // run action and add node
    [_scNode addChild: soySauceNode];
    [_scNode runAction: animSoy];
    [_sauceNode addChild: _scNode];
    
}

-(void) createDropplet{
    
    // create the droplet of soy sauce
    CGPoint vPos = [_sauceNode convertPoint:_scNode.position toNode:self];
    
    SKNode *parentDroplet = [SKNode node];
    SKSpriteNode *droplet = [SKSpriteNode spriteNodeWithTexture: _droplet];
    
    droplet.position = CGPointMake((vPos.x + (self.frame.size.width + 50)), self.frame.size.height - 50);
    droplet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: 10.0];
    
    droplet.physicsBody.dynamic = YES;
    droplet.physicsBody.affectedByGravity = YES;
    
    // use force_x to counter force of user
    droplet.physicsBody.velocity = CGVectorMake(_forceX, 0);
    
  
    droplet.zPosition = -5;
    [droplet setScale : 0.5];
    
    droplet.physicsBody.contactTestBitMask = persoCategory | mondeCategory;
    droplet.physicsBody.categoryBitMask = soyDroplet;
    
    SKAction *pause_droplet = [SKAction waitForDuration: 10];
    
    // we want to remove the droplet
    SKAction *delete_droplet = [SKAction removeFromParent];
    
    SKAction *animObs = [SKAction repeatActionForever: [SKAction sequence: @[pause_droplet, delete_droplet]]];
    
    [parentDroplet addChild: droplet];
    [parentDroplet runAction: animObs];
    [_dropletNode addChild : parentDroplet];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_disableUserInput){
        [_perso.physicsBody applyImpulse: CGVectorMake(0,_less)];
    }
}


- (void)didBeginContact:(SKPhysicsContact *) contact {
    if(((contact.bodyA.categoryBitMask & obstacleCategory) == obstacleCategory)){
 
        // stop the game
        if(_noeudMouvment.speed > 0 && _life == 0){
            
             // disable user input
              _noeudMouvment.speed = 0;
              _disableUserInput = YES;
              [audio stop];
              [self reset];
        } else{
            // reduce life of the sushi
            --_life;
            [[self childNodeWithName: @"heart"] removeFromParent];
        }
    }
    else if(((contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory)){
        // score counter
        ++_scoreNumber;
        _scoreCounter.text = [NSString stringWithFormat:@"%i", _scoreNumber];
    }
    else if(contact.bodyA.categoryBitMask == 1){
        // reduce the ability of the user to control it's sushi
        _less = _less - 50;
    }
    else if(((contact.bodyA.categoryBitMask & killCategory) == killCategory)){
        // if the sushi touch the left collider -> user loose
        
        _life = 0;
        [audio stop];
        [self reset];
    }
    else{
        [self removeActionForKey:@"collision"];
    }
}

-(void) reset{
    // remove everything...
    [_ObstacleGroup removeAllChildren];
    [_sauceNode removeAllChildren];
    [_dropletNode removeAllChildren];
    [_noeudMouvment removeAllChildren];
    [self removeAllActions];

    // instantiate the loose UI class -> flappyUI.swift
    SKScene *restart = [[UILoose alloc] initWithSize: self.view.bounds.size userScore: _scoreNumber];
    SKTransition *fadeTransition = [SKTransition fadeWithDuration: 1.0];
    [self.view presentScene : restart  transition : fadeTransition];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
