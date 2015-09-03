//
//  MasterBoulder.h
//  Fallin
//
//  Created by Alfonso on 5/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterBoulder : NSObject


+ (id)sharedMaster;
-(NSString*)getNextBoulderName;
-(void)isGoingUp;
-(void)resetBoulderCount;

@end
