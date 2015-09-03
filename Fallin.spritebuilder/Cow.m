//
//  Cow.m
//  Fallin
//
//  Created by Alfonso on 5/1/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Cow.h"
#import <CoreMotion/CoreMotion.h>
#import "Coffin.h"
#import "Diamond.h"
#import "Boulder.h"
#define timesAccel 100

#define DEBUGG 1
@implementation Cow
{
    CMMotionManager *_motionManager;
    CGRect windowFrame;
    

    //No reseting req.
    CCNode* _visualArmor;
    CCNode* _visualParachute;
    CCSprite* _visualCow;
    CCNode* _aura;
    CCNode* _body;
    CCNode * _visualPower;
    
    float affectedScale;
    
    CCParticleSystem *_visibleCowParticle;
    
    CCNode * _visibleAura;
    
    float initialPositionY;
    
    double auraTime;
    int _tinySize;
    NSMutableArray * consumableObjects;
    
    int diamondsEaten;
    
    //Implicit

    BOOL _isAuraActive;
    BOOL _isArmorActive;
}
-(void)didLoadFromCCB
{
    [self resetCow];
    
    _isReadyToPlay = NO;
    [_visualPower setVisible:NO];
    
    [_visualCow setZOrder:1000];
    [_visualArmor setZOrder:++_visualCow.zOrder];
    
    initialPositionY = self.position.y;
    _motionManager =  [[CMMotionManager alloc] init];
    [_motionManager startAccelerometerUpdates];
    windowFrame =[CCDirector sharedDirector].view.bounds;
    [_body.physicsBody setCollisionType:CowType];
    [_body.physicsBody setCollisionGroup:menu];
    [_body.physicsBody setCollisionCategories:@[cow]];
    [_body.physicsBody setCollisionMask:@[object,aura]];

    
}
#pragma mark Class Behavior
-(BOOL)activatePower
{
    BOOL canActivatePower = NO;

    if ([_counter isPowerReady] && !_isPowerActive && self.position.y>windowFrame.size.height/3 && !_isParachuteActive) {
        
        canActivatePower = YES;
        [[OALSimpleAudio sharedInstance]playEffect:@"5.wav" loop:NO];
        [self activatePower:YES];
        [_counter consumeDiamonds];
    }
    
    return canActivatePower;
}
-(void)resetCow
{

    diamondsEaten = 0;
    affectedScale = 1.0f;
    for (CCNode * n in consumableObjects)
        [n removeFromParent];
    [_visibleCowParticle setVisible:YES];
    consumableObjects = [NSMutableArray array];
    [_counter resetCounter];
    auraTime = 0;
    _isCowDead = NO;
    _tinySize = 2;
    _isSequelOfPower = NO;
    _isPowerActive = NO;
    _isCowPerformingDead = NO;
    [self activateArmor:NO];
    [self activatePower:NO];
    [self activateAuraShield:NO];
    [self activateParachute:NO];
    
}
#pragma mark - Update
- (void)update:(CCTime)delta {

    [self moveMoveConsumablesTowardsCow:delta];
    [self tryToRemoveAura:delta];
    [self tryToResetSize:delta];
    [self tryToDeactivatePower:delta];
    [self tryToDeactivateParachute:delta];
    [self tryToPerformDead:delta];
    
    if (_isReadyToPlay) {
        [self tryToRepositionSelf:delta];
        [self calculateHorizontalPosition:delta];
    }
}
-(void)moveMoveConsumablesTowardsCow:(CCTime)delta
{
    for (MovableObject* nodeA in consumableObjects) {
        
        float alfa = delta*150;
        CGPoint this = [self.parent convertToWorldSpace:self.position];
        CGPoint innterP = [self.parent convertToWorldSpace:nodeA.position];
        
        
        float check =fabs(this.y-innterP.y);
        float checkX =fabs(this.x-innterP.x);
        
        static int mr = 2;
        
        //Y checkin
        if (check > mr) {
            
            if (this.y>innterP.y) {
                
                if (self.position.y < initialPositionY) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(getSpeedForCow)]) {
                        CGFloat speed =  [self.delegate getSpeedForCow];
                        innterP.y+=speed;
                    }
                }
                
                innterP.y+= alfa*2;
            }
            else
            {
                innterP.y-= alfa;
            }
        }
        
        
        //X chekin
        if (checkX > mr) {
            
            if (this.x>innterP.x) {
                innterP.x += alfa;
            }else
            {
                innterP.x-= alfa;
            }
        }
        
        [nodeA setPosition:innterP];
    }
    
    
}
-(void)tryToPerformDead:(float)delta
{
    
    static float sec;
    if (_isCowPerformingDead) {
        BOOL initalNotReady = true;
        if (sec <=0 && initalNotReady)
        {
            initalNotReady = false;
            sec =1.0f;
        }
        sec-=delta;
        
        if (sec>0) {//Space For while been
        }
        if (sec <=0) {
            initalNotReady = true;
            _isCowPerformingDead = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(cowJustFinishedPerformingDead)])
                [self.delegate cowJustFinishedPerformingDead];
            sec = 0;
            
        }
    }
}
-(void)tryToRemoveAura:(float)delta
{
    
    
    
    if (_isAuraActive) {
        BOOL initalNotReady = true;
        if (auraTime <=0 && initalNotReady)
        {
            initalNotReady = false;
            auraTime =3;
        }
        auraTime-=delta;
        
        if (auraTime>0) {//Space For while been
        }
        if (auraTime <=0) {
            initalNotReady = true;
            [self activateAuraShield:NO];
            auraTime = 0;
            
        }
    }
}
-(void)tryToResetSize:(CCTime)delta
{
    
    static double sec;

    if (_tinySize !=2) {
        BOOL initalNotReady = true;
        if (sec <=0 && initalNotReady)
        {
            initalNotReady = false;
            sec =5;

        }
        sec-=delta;
        
        if (sec>0) {//Space For while been
        }
        if (sec <=0) {
            initalNotReady = true;
            [self makeSmaller:NO];
            sec = 0;

        }
    }
    
}



-(void)tryToRepositionSelf:(CCTime)delta
{
    if (self.position.y < initialPositionY) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(getSpeedForCow)]) {
           CGFloat speed =  [self.delegate getSpeedForCow];
            [self setPositionForSelf:self.position.x andY:self.position.y +  speed];
        }
    }
    else
    {
        _isSequelOfPower = NO;
    }
}
-(void)tryToDeactivateParachute:(CCTime)delta
{
    static double sec;
    
    
    if (_isParachuteActive) {
        BOOL initalNotReady = true;
        if (sec <=0 && initalNotReady)
        {
            initalNotReady = false;
            sec =1.0f;
        }
        sec-=delta;
        
        if (sec <=0) {
            initalNotReady = true;
            [self activateParachute:NO];
            sec = 0;
            
        }
    }
    
}
-(void)tryToDeactivatePower:(CCTime)delta
{
    static double sec;
    static CGFloat newY;

    
    if (_isPowerActive) {
        BOOL initalNotReady = true;
        if (sec <=0 && initalNotReady)
        {
            initalNotReady = false;
            sec =1.5f;
            newY = self.position.y;
        }
        sec-=delta;

        
        newY-=delta*150;

        if (sec<0.5f) {
            newY -=delta/1000;
        }
        
        if (sec>0) {
            
            [self setPositionForSelf:self.position.x andY:newY];
        }
        if (sec <=0) {
            initalNotReady = true;
            [self activatePower:NO];
            sec = 0;
            newY = 0;

        }
    }
}
-(void)setPositionForSelf:(float)x andY:(float)y
{
    
    self.position = CGPointMake(x,y);
    [_aura setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    [_body setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    
}
-(void)calculateHorizontalPosition:(CCTime)delta
{
    if (_isCowPerformingDead) return;
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = self.position.x + acceleration.x  * 1500 * delta;
    newXPosition = clampf(newXPosition, 0, windowFrame.size.width);
    float rotation = acceleration.x*50;
    float invRotation = rotation*-2;

    [self setRotation:(rotation)];
    [_visibleCowParticle setRotation:invRotation];
    [_visualParachute setRotation:invRotation];
    [_visibleAura setRotation:rotation*-1];
    [_visualPower setRotation:invRotation];
    [self setPositionForSelf:newXPosition andY:self.position.y];
    
}

#pragma mark - COW COLLISION
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair boulderType:(Boulder *)nodeA cowType:(CCNode *)nodeB
{
    
    if (_isPowerActive || _isArmorActive  ) {
        if (!_isPowerActive)
            [self activateArmor:NO];
        [nodeA explode];
        return;
    }
    
        if (!_isCowDead) {
            [[[Coffin sharedCoffin]treasure] setLastFallDiamonds: diamondsEaten];
            _isCowDead = YES;
            [[OALSimpleAudio sharedInstance]playEffect:@"7.wav"volume:1.5f pitch:1.0f pan:1.0f loop:NO];
            _isCowPerformingDead = YES;
            [nodeA.physicsBody setCollisionMask:@[]];
            CCNode * parent = nodeA.parent;
            CCNode * rip = [CCBReader load:@"ExplodeFlame"];
            [parent addChild:rip];
            CGPoint m = [parent convertToNodeSpace:self.position];
            [rip setPosition:m];
            
            [_visibleCowParticle setVisible:NO];

            if(self.delegate && [self.delegate respondsToSelector:@selector(cowJustDied)])
              [self.delegate cowJustDied];
            
        
    }
}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair armorType:(MovableObject *)nodeA cowType:(CCNode *)nodeB
{
    
    [consumableObjects removeObject:nodeA];
    [self activateArmor:YES];
    [nodeA explode];
    //Change Main Sprites ANimation.
    
}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair parachuteType:(MovableObject *)nodeA cowType:(CCNode *)nodeB
{
    [consumableObjects removeObject:nodeA];
    [self activateParachute:YES];
    [nodeA explode];
}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair tinyFoodType:(CCNode *)nodeA cowType:(CCNode *)nodeB
{
    [nodeA removeFromParent];
    
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair auraType:(MovableObject *)nodeA cowType:(CCNode *)nodeB
{
    
    [consumableObjects removeObject:nodeA];
    [nodeA explode];
    [self activateAuraShield:YES];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair diamondType:(MovableObject *)nodeA cowType:(CCNode *)nodeB
{
 
    [consumableObjects removeObject:nodeA];
    [_counter addDiamond];
    diamondsEaten +=1;
    [nodeA explode];
    
}



#pragma mark AURA_SHIELD COLLISION
-(void)playAbsorb
{
    [[OALSimpleAudio sharedInstance]playEffect:@"6.wav" volume:1.0f pitch:1.0f pan:1.0f loop:NO];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair auraType:(Diamond *)nodeA auraShieldType:(CCNode *)nodeB
{


    [self playAbsorb];

    CGPoint a = [nodeA.parent convertToWorldSpace:nodeA.position];
    [nodeA removeFromParent];
    
    CCNode* newAura =[CCBReader load:@"Aura"];
    [newAura.physicsBody setCollisionMask:@[cow]];
    [self.parent addChild:newAura];
    [newAura setPosition:a];
    [consumableObjects addObject:newAura];
    [self activateAuraShield:YES];


}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair diamondType:(Diamond *)nodeA auraShieldType:(CCNode *)nodeB

{

    [self playAbsorb];
    CGPoint a = [nodeA.parent convertToWorldSpace:nodeA.position];
    [nodeA removeFromParent];
    
    CCNode* newAura =[CCBReader load:@"Diamond"];
    [newAura.physicsBody setCollisionMask:@[cow]];
    [self.parent addChild:newAura];
    [newAura setPosition:a];
    [consumableObjects addObject:newAura];

}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair parachuteType:(Diamond *)nodeA auraShieldType:(CCNode *)nodeB
{
        [self playAbsorb];
    CGPoint a = [nodeA.parent convertToWorldSpace:nodeA.position];
    [nodeA removeFromParent];
    
    CCNode* newAura =[CCBReader load:@"Parachute"];
    [newAura.physicsBody setCollisionMask:@[cow]];
    [self.parent addChild:newAura];
    [newAura setPosition:a];
    [consumableObjects addObject:newAura];
    
}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair armorType:(Diamond *)nodeA auraShieldType:(CCNode *)nodeB
{
        [self playAbsorb];
    CGPoint a = [nodeA.parent convertToWorldSpace:nodeA.position];
    [nodeA removeFromParent];
    
    CCNode* newAura =[CCBReader load:@"Armor"];
    [newAura.physicsBody setCollisionMask:@[cow]];
    [self.parent addChild:newAura];
    [newAura setPosition:a];
    [consumableObjects addObject:newAura];
    
}



#pragma mark -- Powers Activations

-(void)makeSmaller:(BOOL)smallr
{
    _tinySize += !smallr?1:-1;
    if (_tinySize<=1)
        _tinySize =1;
    if (_tinySize>=3) {
        _tinySize=3;
    }
    float scale = _tinySize*0.7f;
    
    
    //    self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:self.contentSize.width/2 andCenter:ccp(self.position.x, self.position.y)];
    //    self.physicsBody
    id scaleUpAction =  [CCActionEaseInOut actionWithAction:[CCActionScaleTo actionWithDuration:2.0f scale:scale] rate:2.0];
    [self.physicsBody setCollisionGroup:menu];
    
    [self runAction:scaleUpAction];
}

-(void)activateParachute:(BOOL)activate
{
    if (_isPowerActive) return;
    _isParachuteActive = activate;

    
    if (activate && _visualParachute ) {
        return;
    }
    
    if (activate) {
        _visualParachute = [CCBReader load:@"CowParachute"];
        [_visualParachute setPosition:ccp(self.contentSize.width/2 ,self.contentSize.height/2 - _body.contentSize.height/2 )];
        [self addChild:_visualParachute];
    }
    else
    {
        [_visualParachute removeFromParent];
        _visualParachute = NULL;
    }
    
}
-(void)activateAuraShield:(BOOL)activate
{
    if (_isAuraActive && activate) {
        auraTime+= activate? 2:0;
        if (auraTime>=4)
            auraTime=4;
        return;
    }
    
    _isAuraActive = activate;
    //AQIU
    
    
    if (_isAuraActive && !_aura) {
        
        
        
        _visibleAura = [CCBReader load:@"CowAuraShield"];
        [_visibleAura setPosition:ccp(self.contentSize.width/2 ,self.contentSize.height/2)];
        [self addChild:_visibleAura];
        
        _aura = [CCNode node];
        [_aura setPhysicsBody:[CCPhysicsBody bodyWithCircleOfRadius:100.0f andCenter:ccp(0, 0)]];
        [_aura.physicsBody setCollisionGroup:menu];
        [_aura.physicsBody setCollisionType:AuraShieldType];
        [_aura.physicsBody setCollisionMask:@[diamond,aura,armor,parachute]];
        [_aura.physicsBody setCollisionCategories:@[auraShield]];
        [self setPositionForSelf:self.position.x andY:self.position.y];
        [self addChild:_aura];
        
    }
    else
    {
        [_visibleAura removeFromParent];
        [_aura removeFromParent];
        _visibleAura = nil;
        _aura = nil;
    }
    
}


-(void)activatePower:(BOOL)activate
{
    if (_isParachuteActive)return;
    _isPowerActive = activate;
    _isSequelOfPower = YES;

    
    
    if (activate) {
        _visualPower = [CCBReader load:@"CowPower"];
        [_visualPower setPosition:ccp(self.contentSize.width/2 ,self.contentSize.height/2)];
        [_visualPower setZOrder:1005];
        [self addChild:_visualPower];
    }
    else
    {
        [_visualPower removeFromParent];
    }
    

    
    
    
}

-(void)activateArmor:(BOOL)activate
{
    
    if (activate && _visualArmor ) {
        return;
    }
    
    _isArmorActive = activate;
    
    if (activate) {
        
        _visualArmor = [CCBReader load:@"CowShield"];
        [_visualArmor setPosition:ccp(self.contentSize.width/2 ,self.contentSize.height/2)];
        
        [self addChild:_visualArmor];
        
    }
    else
    {
        [_visualArmor removeFromParent];
        _visualArmor = NULL;
    }
    
}
-(void)setReadyToPlay:(BOOL)isReadyToPlay
{
    _isReadyToPlay = isReadyToPlay;
    if (_isReadyToPlay) {
        [self setPositionForSelf:windowFrame.size.width/2 andY:initialPositionY];
    }else
    {
        [self setPositionForSelf:(-self.contentSize.width/2) andY:(-self.contentSize.height/2)];
    }
}
@end
