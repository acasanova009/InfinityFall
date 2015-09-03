//
//  Aura.m
//  Fallin
//
//  Created by Alfonso on 5/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Aura.h"

@implementation Aura

{
    int shouldDeactivatePhysics;
}
-(void)didLoadFromCCB
{
    
        [self.physicsBody setCollisionType:AuraType];
        [self.physicsBody setCollisionCategories:@[aura]];
        [self.physicsBody setCollisionMask:@[cow, auraShield]];
    
    if (shouldDeactivatePhysics == 1) {
        self.physicsBody = NULL;

    }
    
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"Aura"];
}

-(void)explode
{
    [[OALSimpleAudio sharedInstance]playEffect:@"1.wav" volume:3.0f pitch:1.0f pan:1.0f loop:NO];
    [self removeFromParent];
}
@end
