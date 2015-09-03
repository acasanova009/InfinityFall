//
//  Armor.m
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Armor.h"

@implementation Armor

-(void)didLoadFromCCB
{
    [self.physicsBody setCollisionType:ArmorType];
    [self.physicsBody setCollisionCategories:@[object,armor]];
    [self.physicsBody setCollisionMask:@[cow,auraShield]];
}

-(void)explode
{
    [[OALSimpleAudio sharedInstance]playEffect:@"3.wav" volume:1.2f pitch:1.0f pan:1.0f loop:NO];
    [self removeFromParent];
}
@end
