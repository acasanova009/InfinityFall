//
//  Cow.h
//  Fallin
//
//  Created by Alfonso on 5/1/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FallingObjects.h"
#import "cocos2d.h"
#import "CowLifeProtocol.h"
#import "Counter.h"

@interface Cow : CCNode <CCPhysicsCollisionDelegate>
{
    
}
@property (nonatomic,readonly)BOOL isPowerActive;
@property (nonatomic,readonly)BOOL isSequelOfPower;
@property (nonatomic,readonly)BOOL isCowDead;
@property (nonatomic,readonly)BOOL isCowPerformingDead;
@property (nonatomic,readonly) BOOL isParachuteActive;
@property (nonatomic,setter = setReadyToPlay:) BOOL isReadyToPlay;

@property (nonatomic,assign) Counter *counter;
@property (nonatomic,assign) id <CowLifeProtocol> delegate;

-(BOOL)activatePower;
-(void)resetCow;
@end
