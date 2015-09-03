//
//  Counter.h
//  Fallin
//
//  Created by Alfonso on 5/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Counter : CCNode

-(void)addDiamond;
-(BOOL)isPowerReady;
-(void)consumeDiamonds;
-(void)resetCounter;
@end
