//
//  MovableObject.h
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FallingObjects.h"
#import "cocos2d.h"

@interface MovableObject : CCSprite


@property (nonatomic) BOOL shouldStopScrolling;
-(void)explode;
@end
