
//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Cow.h"
#import "MainSpace.h"
#import "Coffin.h"
#import "Counter.h"
#import "FallingObjects.h"
#import "MasterBoulder.h"
#import <Twitter/Twitter.h>


#define SPACES_VARIETY	7
#define FIXED_INITIAL_COW_Y 100
#define kPointToCentimeters 128
#define s_Name @"Space"
#define MainSpaceTag @"Space0"

@implementation MainScene
{

    Cow* _cow;
    Counter *_counter;
    CCPhysicsNode * _physicsNode;
    CGRect winFrame;
    int s_MaxToLoad;
    NSMutableArray *spaces;
    BOOL keepScrolling;
    BOOL isGoingToSky;
    NSMutableArray* historyOfSpaces;

    NSUInteger points;
    
    CCLabelTTF * _distanceLabel;
    CCLabelTTF * _diamondsLabel;
    MainSpace* mainSpace;
    
    float speed;
    float backSpeed;
    //when a power is taken, it sets a new speed.
    float powerSpeed;
    //speed behind the power speed.
    float sequelSpeed;

    float ultimateSpeed;
    
    
    float distance;
}
-(void)intialStats
{
    [[MasterBoulder sharedMaster] resetBoulderCount];
    ultimateSpeed =0;
    points = 0;
    isGoingToSky = NO;
    keepScrolling = NO;
    [self showCustomUI:keepScrolling];
    speed = 0;
    backSpeed = 0 ;
    powerSpeed = 0;
    sequelSpeed =0;
    s_MaxToLoad =4;
    [_cow resetCow];
    historyOfSpaces = [NSMutableArray array];
    
    
}
-(void)showCustomUI:(BOOL)show
{
    [_cow setReadyToPlay:show];
    [_counter setVisible:show];
    [_diamondsLabel setVisible:show];
    
}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

//    CGPoint p = [touch locationInNode:self];
    [_cow activatePower];
//    isGoingToSky = YES;

}
-(void)didLoadFromCCB
{
    


    winFrame =[CCDirector sharedDirector].view.bounds;
    self.userInteractionEnabled = YES;
    spaces = [NSMutableArray array];
//    _physicsNode.debugDraw =YES;
    [self loadCow];
    [self intialStats];
    [self loadInitialSpaces];
    
}
-(void)loadCow
{
//
    [_cow setPosition:ccp(winFrame.size.width/2,winFrame.size.height/2)];
    [_cow setDelegate:self];
    [_cow setCounter:_counter];
    [_physicsNode setCollisionDelegate:_cow];
    
}
- (void)getReadyForNewFall:(Space *)space
{

    float distanceForNewFall = winFrame.size.height - (space.position.y+space.contentSize.height/2);
    
    [space setCustomSpeed:distanceForNewFall positive:NO];
    [self intialStats];
    [historyOfSpaces addObject:MainSpaceTag];
    [self createMultipeSpaces:space];
    
}
-(void)update:(CCTime)delta
{
    distance =(unsigned long)points/kPointToCentimeters;
    [_diamondsLabel setString:[NSString stringWithFormat:@"%f",distance]];
    [self checkForNewLevelExplotion];
        if (keepScrolling || isGoingToSky)
            [self runSpacesWithSpeed:[self getSpeed:delta] andDirection:isGoingToSky];
    
    
}
-(void)checkForNewLevelExplotion{
//    
//    int
//    
//    switch (distance) {
//        case <#constant#>:
//            <#statements#>
//            break;
//            
//        default:
//            break;
//    }
    
    
}

-(void)invertSpacesAndClearExtraHistoryReferences
{
    for (int i = 0 ; i<s_MaxToLoad; i++)
        if (historyOfSpaces.count>1)
            [historyOfSpaces removeLastObject];
    NSMutableArray* reversed = [NSMutableArray array];
    NSEnumerator* enumerator = [spaces reverseObjectEnumerator];
    id obj;
    while (obj = [enumerator nextObject])
        [reversed addObject:obj];
    spaces = reversed;
}
- (void)createMultipeSpaces:(Space *)space
{
    [spaces removeObject:space];
    for (Space* s in spaces) {
        [_physicsNode removeChild:s];
    }
    spaces = [NSMutableArray array];
    [spaces addObject:space];

    CGRect s_lastRect = CGRectMake(space.position.x, space.position.y , space.contentSize.width,space.contentSize.height);
    for (int s_Index = 1; s_Index < s_MaxToLoad; s_Index++) {
        
        space = [self createSpaceWithName:[self getNewSpaceNameAndAddReference]];
        
        
        float newY = s_lastRect.origin.y - s_lastRect.size.height/2 - space.contentSize.height/2  ;
        space.position = ccp(winFrame.size.width/2,newY);
        
        [spaces addObject:space];
        [_physicsNode addChild:space];
        // Keep track of this building's CGRect
        s_lastRect = CGRectMake(space.position.x,
                                space.position.y,
                                space.contentSize.width,
                                space.contentSize.height);
    }
}

-(void)loadInitialSpaces
{
    
    
    Space *space = (Space*)[CCBReader load:MainSpaceTag];
    mainSpace = (MainSpace*)space;
    [mainSpace setOwner:self];
    
    
    float newY = winFrame.size.height - space.contentSize.height/2  ;
    space.position = ccp(winFrame.size.width/2,newY);
    
    [historyOfSpaces addObject:MainSpaceTag];
    [spaces addObject:space];
    [_physicsNode addChild:space];
    
    [self createMultipeSpaces:space];
}



-(void)runSpacesWithSpeed:(float)innerSpeed andDirection:(BOOL)direction
{
    Space *savedSpaceMutableIssue = NULL;
    
//    NSMutableArray *newSpacesToCreate = [NSMutableArray array];
    NSMutableArray *newNameSpacesToCreate = [NSMutableArray array];
    for (Space *currentSpace in spaces  ) {
        if (direction)
        {
            if (currentSpace.position.y <= (-currentSpace.contentSize.height/2)) {
                
                NSString* quickName = [self getSpaceNameReferenceFromHistoryAndDelete];
                if (quickName) {
                    [newNameSpacesToCreate addObject:quickName];
                }
                
//                Space* quickSpace = [self getSpaceReferenceFromHistoryAndDelete];
//                if (quickSpace)
//                {
//                    [newSpacesToCreate addObject:quickSpace];
//                }
                
            }
            if ([currentSpace.description isEqualToString:@"SpaceKind1000"]) {
                if (currentSpace.position.y+currentSpace.contentSize.height/2<=winFrame.size.height) {
                    savedSpaceMutableIssue= currentSpace;
                    mainSpace = (MainSpace*)savedSpaceMutableIssue;
                    [mainSpace setOwner:self];

                    break;
                }
            }
        }
        else
        {
            if (currentSpace.position.y > (winFrame.size.height + currentSpace.contentSize.height/2))
                
                [newNameSpacesToCreate addObject:[self getNewSpaceNameAndAddReference]];
//                            [newSpacesToCreate addObject:[self getNewSpaceAndAddReference]];
            
        }
        
        [currentSpace setCustomSpeed:innerSpeed positive:direction];
        
    }
    
    if (savedSpaceMutableIssue)
        [self getReadyForNewFall:savedSpaceMutableIssue];


    if (newNameSpacesToCreate.count) {
        
        
        dispatch_queue_t queue = dispatch_queue_create("com.fallin.mainAlgorithim", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(queue, ^{
            
            for (NSString* spaceName in newNameSpacesToCreate) {
                Space* lastSpace = (Space*)[spaces lastObject];
                Space * newSpaceName  = [self createSpaceWithName:spaceName];
                
               if([newSpaceName respondsToSelector:@selector(setOwner:)])
               {
                    mainSpace = (MainSpace*)newSpaceName;
                   [mainSpace.scroll setHorizontalPage:1 animated:NO];
                }

                
                newSpaceName.position = [self point:direction lastSpace:lastSpace andNewSpace:newSpaceName];
                
                Space*firstSpace  = [spaces firstObject];
                [_physicsNode removeChild:firstSpace cleanup:YES];
                [spaces removeObject:firstSpace];
                
                [spaces addObject:newSpaceName];
                [_physicsNode addChild:newSpaceName];
                
            }
        
        });
        
        
        
    }
    
//    if (newSpacesToCreate.count) {
//        for (Space* newSpaceName in newSpacesToCreate) {
//            
//            
//            
//            Space* lastSpace = (Space*)[spaces lastObject];
//            
//            newSpaceName.position = [self point:direction lastSpace:lastSpace andNewSpace:newSpaceName];
//            
//            Space*firstSpace  = [spaces firstObject];
//            [_physicsNode removeChild:firstSpace cleanup:YES];
//            [spaces removeObject:firstSpace];
//            
//            [spaces addObject:newSpaceName];
//            [_physicsNode addChild:newSpaceName];
//            
//        }
//    }
}
-(CGPoint)point:(BOOL)isPositive lastSpace:(Space*)lastSpace andNewSpace:(Space*)newSpace
{
    float newY;
    if (isPositive)
        newY =lastSpace.position.y+lastSpace.contentSize.height/2+newSpace.contentSize.height/2;
    else
        newY =lastSpace.position.y-lastSpace.contentSize.height/2-newSpace.contentSize.height/2;
    return ccp(lastSpace.position.x, newY);
}
-(float)getSpeed:(float)d
{

    if (isGoingToSky) {
        
        //going up means to be dead.
        if (historyOfSpaces.count == 0)
        {
            backSpeed -= d*10;
             backSpeed =clampf(backSpeed,10 , 15);
        }
        else
            backSpeed += d*100;
        ultimateSpeed = backSpeed;
    }
    
    else if (_cow.isPowerActive) {
        points +=powerSpeed;
        ultimateSpeed =  powerSpeed+=d*20;
    }
    else if (_cow.isSequelOfPower) {
        powerSpeed = 0;
        points +=sequelSpeed;
        ultimateSpeed = 5;
    }
    else if (_cow.isParachuteActive)
    {
        speed-=d;
        speed = clampf(speed, 4, 9);
        points +=speed;
        ultimateSpeed = speed;
    }
    else if(points<4000)
    {
        
        NSLog(@"Current poins: %lu",(unsigned long)points);
        
        speed+=d/50;
        speed = clampf(speed, 4, 8);
        points +=speed;
        ultimateSpeed = speed;
    }else if(points<8000)
    {
        
        NSLog(@"Current poins: %lu",(unsigned long)points);
        
        speed+=d/10;
        speed = clampf(speed, 4, 8);
        points +=speed;
        ultimateSpeed = speed;
    }
    else
    {
        
        NSLog(@"Current poins: %lu",(unsigned long)points);
        
        speed+=d/3;
        speed = clampf(speed, 4, 8);
        points +=speed;
        ultimateSpeed = speed;
    }
    
    return ultimateSpeed;
}
-(Space*)getSpaceReferenceFromHistoryAndDelete
{
    Space* space = NULL;
    if (historyOfSpaces && historyOfSpaces.count>0) {
        NSString* lastName = [historyOfSpaces lastObject];
        
        [historyOfSpaces removeLastObject];
        space = (Space*)[CCBReader load:lastName];
        if (historyOfSpaces.count==0) {
            mainSpace = (MainSpace*)space;
            [mainSpace setOwner:self];

        }
    }
    return space;
    
}
-(Space*)getNewSpaceAndAddReference
{
    
    int buildingType = (arc4random() % SPACES_VARIETY) + 1;
    NSString* currentSpaceName =[NSString stringWithFormat:@"%@%d",s_Name, buildingType];
    [historyOfSpaces addObject:currentSpaceName];
    
    return (Space*)[CCBReader load:currentSpaceName];

}

-(NSString*)getSpaceNameReferenceFromHistoryAndDelete
{
    NSString* lastName = NULL;
    if (historyOfSpaces && historyOfSpaces.count>0) {
         lastName = [historyOfSpaces lastObject];
        
        [historyOfSpaces removeLastObject];
//        space = (Space*)[CCBReader load:lastName];
//        
//        
//        if (historyOfSpaces.count==0) {
//            mainSpace = (MainSpace*)space;
//            [mainSpace setOwner:self];
//            
//        }
    }
    return lastName;
    
}
-(NSString*)getNewSpaceNameAndAddReference
{
    NSString* str =[self checkLastRepetition:[self makeNewSpaceName]];
    [historyOfSpaces addObject:str];
    NSLog(@"%@", str);
    return str;
    
}
-(NSString*)makeNewSpaceName
{
    int buildingType = (arc4random() % SPACES_VARIETY) + 1;
    NSString* currentSpaceName =[NSString stringWithFormat:@"%@%d",s_Name, buildingType];
    return currentSpaceName;
    
}
-(NSString*)checkLastRepetition:(NSString*)nameToCheck
{
        NSEnumerator* en = [historyOfSpaces reverseObjectEnumerator];
        int c = 4;
        NSString* loadedString;
        while (c && (loadedString = [en nextObject])) {
            c--;
            if ([loadedString isEqualToString:nameToCheck]) {
                return [self checkLastRepetition:[self makeNewSpaceName]];
            }
        }
    return nameToCheck;
}

-(Space*)createSpaceWithName:(NSString*)name
{
    if (!name)
        return NULL;
    return  (Space*)[CCBReader load:name];
}
#pragma mark - Cow Delegate
-(void)cowJustDied
{
    [[MasterBoulder sharedMaster] isGoingUp];
    keepScrolling = NO;
    

    [self invertSpacesAndClearExtraHistoryReferences];
}
-(void)cowJustFinishedPerformingDead
{
    
    [_cow setReadyToPlay:NO];
    //No necesary to reset cow, but is nicer.
    [_cow resetCow];
    
    [[[Coffin sharedCoffin] treasure] setLastFallDistance:(points/kPointToCentimeters)];
    isGoingToSky = YES;
    
}
-(CGFloat)getSpeedForCow
{

    return ultimateSpeed;
}


-(void)playButtonPressed
{
    [[OALSimpleAudio sharedInstance]playEffect:@"playButton.wav" loop:NO];

    
    [mainSpace.scroll lastJumpAnimation];
    [mainSpace.scroll setHorizontalScrollEnabled:NO];
    keepScrolling = YES;
    [self showCustomUI:keepScrolling];

}
-(void)faceBookButtonPressed
{
    SLComposeViewController *faceBookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [faceBookPost setInitialText:NSLocalizedString(@"Try to beat me at Infinity Fall! ", @"Suggesting another player to beat me at this game")];
    
    [[CCDirector sharedDirector] presentModalViewController:faceBookPost animated:YES];

}
-(void)settingsButtonPressed
{
}
-(void)rateButtonPressed
{
    
}
-(void)backButtonPressed
{    
    [mainSpace.scroll setHorizontalPage:0 animated:YES];
}
-(void)scoreButtonPressed
{
    [[Coffin sharedCoffin]presentLeaderBoard];
}
-(void)twitterButtonPressed
{
    TWTweetComposeViewController *tweetComposeViewController =
    [[TWTweetComposeViewController alloc] init];
    [tweetComposeViewController setInitialText:NSLocalizedString(@"Try to beat me at Infinity Fall! ", @"Suggesting another player to beat me at this game")];
    [[CCDirector sharedDirector] presentModalViewController:tweetComposeViewController animated:YES];
    
}
@end
