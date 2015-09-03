//
//  CowLifeProtocol.h
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CowLifeProtocol <NSObject>

-(void)cowJustDied;
-(void)cowJustFinishedPerformingDead;
-(CGFloat)getSpeedForCow;
@end

