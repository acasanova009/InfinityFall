//
//  Boulder.m
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Boulder.h"
#import "MasterBoulder.h"
@implementation Boulder
{
    BOOL isNormal;
    CCSprite* rocks;
    NSMutableArray * thoseToMakeDisappear;
    int kind;
    int boulderKind;
    
}
-(void)didLoadFromCCB
{
    isNormal = YES;
    [self.physicsBody setCollisionType:BoulderType];
    [self.physicsBody setCollisionCategories:@[object]];
    [self.physicsBody setCollisionMask:@[cow]];
    
    
    void (^newRock)() = ^(){
        if (boulderKind==0) {
            NSString *boulderName = [[MasterBoulder sharedMaster] getNextBoulderName];
            if (boulderName) {
                rocks = (CCSprite*)[CCBReader load:boulderName];
                [rocks setZOrder:1000];
                [self addChild:rocks];
            }
        }
       
    };
    
//    newRock();
    dispatch_queue_t q = dispatch_queue_create("com.rockQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(q, newRock);
//
    
    
    
}
-(int)getKind
{
    return kind;
}
-(void)update:(CCTime)delta
{
    [self tryToBanishRocks:delta];

}
-(void)tryToBanishRocks:(CCTime)delta
{
    static float sec;
    if (!isNormal) {
        BOOL initalNotReady = true;
        if (sec <=0 && initalNotReady)
        {
            
            initalNotReady = false;
            sec =1.0f;
        }
        sec-=delta;
        
            [rocks setOpacity:sec];
        if (sec <=0) {
            initalNotReady = true;
            isNormal = YES;
            sec = 0;
            
        }
    }
    
}
-(void)createNewMagic
{
    CCNode * newMagic;
    switch (kind) {
        case 1:
            newMagic = [CCBReader load:@"Aura"];
            break;
        case 2:
            newMagic = [CCBReader load:@"Parachute"];
            break;
        case 3:
            newMagic = [CCBReader load:@"Diamond"];
            break;
        case 4:
            newMagic = [CCBReader load:@"Armor"];
            break;
            
        default:
            return;
    }
    CCNode * parent = self.parent;
    [newMagic setPosition:self.position];
    [parent addChild:newMagic];
}
-(void)explode
{    
//    [self createNewMagic];
    [self.physicsBody setCollisionMask:@[]];
    isNormal= NO;
    thoseToMakeDisappear = [NSMutableArray arrayWithArray:self.children];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"0.wav" loop:NO];
    
    void (^aBlock)(void);
    aBlock = ^(){
        for (CCNode * kid in thoseToMakeDisappear)
            if (kid != rocks)
                [kid removeFromParent];
        
        CCNode * explodeParticle =[CCBReader load:@"ExplodeParticles"];
        if (explodeParticle){
            [explodeParticle setZOrder:9];
            [self addChild:explodeParticle];
        }

        
    };

    dispatch_queue_t queue = dispatch_queue_create("com.boulder.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, aBlock);
}

@end
