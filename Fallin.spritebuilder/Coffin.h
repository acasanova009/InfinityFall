//
//  Coffin.h
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Treasure.h"

@interface Coffin : NSObject

#ifndef ANDROID
<GKGameCenterControllerDelegate>
#endif
@property (nonatomic,readonly) Treasure* treasure;
@property (readonly) BOOL isGameCenterEnabled;

+(id)sharedCoffin;
-(void)burryTreasure;
-(void)authenticateLocalPlayerAndFindTreasure;

-(void)presentLeaderBoard;

@end
