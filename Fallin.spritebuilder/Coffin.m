//
//  Coffin.m
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Coffin.h"

@implementation Coffin
{

}
+ (id)sharedCoffin {
    static Coffin *coffin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coffin = [[self alloc] init];
    });
    return coffin;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}
-(void)findTreasure
{
    NSData * data =[NSData dataWithContentsOfURL:[Treasure getTreasureURL]];
    _treasure = (Treasure*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!_treasure) {
         _treasure = [[Treasure alloc]init];
    }
    NSLog(@"");
}
-(void)burryTreasure
{
    [[NSKeyedArchiver archivedDataWithRootObject:self.treasure] writeToURL:[Treasure getTreasureURL] atomically:YES];
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"Coffin; %@",self.treasure ];
}
- (void) authenticateLocalPlayerAndFindTreasure
{
    [self findTreasure];
    
#ifndef ANDROID
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
     localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
    
        if (viewController != nil)
        {
                   [[CCDirector sharedDirector]presentViewController:viewController animated:YES completion:^(){}];
    
               }
        else if (localPlayer.isAuthenticated)
        {
    
            
            [self loadPlayerHighScore];
                _isGameCenterEnabled = YES;
               }
        else
        {

                _isGameCenterEnabled = NO;
               }
         
        };
#endif
}

-(void)presentLeaderBoard
{
    
    
#ifndef ANDROID
    GKLeaderboardViewController *ctrl = [[GKLeaderboardViewController alloc]init];
    if (ctrl)
    {
        ctrl.gameCenterDelegate = self;
        [[CCDirector sharedDirector] presentViewController:ctrl animated:YES completion:^{
            
            [[CCDirector sharedDirector]dismissViewControllerAnimated:YES completion:^{}];
        }];
    }
#endif
}

-(void)loadPlayerHighScore
{
#ifndef ANDROID
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    
    if (leaderboardRequest != nil) {
        leaderboardRequest.identifier = @"fallin.hishscore";
        leaderboardRequest.timeScope  = GKLeaderboardTimeScopeAllTime;
        
        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error){
            if (error != nil) {
                //Handle error
            }
            if (scores != nil) {
//                _treasure.bestDistance = (NSUInteger) leaderboardRequest.localPlayerScore.value;
            }
        }];
    }
#endif

}

@end
