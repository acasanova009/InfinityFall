//
//  Parachute.m
//  Fallin
//
//  Created by Alfonso on 5/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Parachute.h"

@implementation Parachute
{
    int  shouldDeactivatePhysics;
}
-(void)didLoadFromCCB
{
 
    [self.physicsBody setCollisionType:ParachuteType];
    [self.physicsBody setCollisionCategories:@[object,parachute]];
    [self.physicsBody setCollisionMask:@[cow,auraShield]];
    
    if (shouldDeactivatePhysics == 1) {

        self.physicsBody = NULL;
    }
}

-(void)explode
{
    [[OALSimpleAudio sharedInstance]playEffect:@"4.wav" loop:NO];
    [self removeFromParent];
    
}
@end
