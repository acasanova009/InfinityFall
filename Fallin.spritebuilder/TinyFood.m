//
//  TinyFood.m
//  Fallin
//
//  Created by Alfonso on 5/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TinyFood.h"

@implementation TinyFood

-(void)didLoadFromCCB
{
    
    [self.physicsBody setCollisionType:TinyFoodType];
    [self.physicsBody setCollisionCategories:@[cow]];
    [self.physicsBody setCollisionMask:@[object,auraShield]];
    
}
@end
