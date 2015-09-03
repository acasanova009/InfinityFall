//
//  Diamond.m
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Diamond.h"
#import "Coffin.h"
@implementation Diamond

-(void)didLoadFromCCB
{
    
//    NSLog(@"Mr %@", self.dontScroll ? @"true" : @"false");
//    self.dontScroll = YES;=
//    NSLog(@"Mr %@", self.dontScroll ? @"true" : @"false");
    [self.physicsBody setCollisionType:DiamondType];
    [self.physicsBody setCollisionCategories:@[object,diamond]];
    [self.physicsBody setCollisionMask:@[cow,auraShield]];
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Diamond"];
}
-(void)explode
{
    
    [[[Coffin sharedCoffin] treasure] addOneDiamond];
    [[OALSimpleAudio sharedInstance]playEffect:@"2.wav" volume:1.0f pitch:1.0f pan:1.0f loop:NO];
    [self removeFromParent];
}
@end
