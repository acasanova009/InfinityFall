//  SpaceParticles.m
//  Fallin
//
//  Created by Alfonso on 5/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SpaceParticles.h"
#import "FallingObjects.h"
@implementation SpaceParticles
-(void)didLoadFromCCB
{
    [self.physicsBody setCollisionGroup:menu];
}
@end
