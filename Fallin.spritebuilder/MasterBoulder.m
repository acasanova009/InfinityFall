//
//  MasterBoulder.m
//  Fallin
//
//  Created by Alfonso on 5/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MasterBoulder.h"


#define BOULDER_VARIETY 6

#define BOUlDER_nextRank 300

#define BOULDER_NAME @"BBoulder"

@implementation MasterBoulder
{
    NSUInteger _currentBoulderCount;

    NSMutableArray *rockSprites;
    NSMutableArray * record;
    BOOL isNormalReading;
}
+ (id)sharedMaster {
    static MasterBoulder *master = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        master = [[self alloc] init];
    });
    return master;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        record = [NSMutableArray array];
        rockSprites = [NSMutableArray array];
        isNormalReading = YES;
        _currentBoulderCount = 0;
        
    }
    return self;
}
-(void)isGoingUp
{
    _currentBoulderCount -=10;
    isNormalReading =NO;
}
-(void)resetBoulderCount
{
    _currentBoulderCount = 0;
    isNormalReading = YES;
}
-(NSUInteger)getCurrentBoulderCount;
{
    return _currentBoulderCount;
}
-(NSString*)getNextBoulderName
{
    _currentBoulderCount += isNormalReading? 1: -1;
    
    int boulderType = [self getNextRandomNumber];
    NSString* boulderName;
    
    //COMPLEXITY 0
    if ([self contains:_currentBoulderCount low:0 high:BOUlDER_nextRank] || _currentBoulderCount <= 0)
        boulderName =nil;
    
    //COMPLEXITY 1
    else if ([self contains:_currentBoulderCount low:BOUlDER_nextRank high:BOUlDER_nextRank*2])
        boulderName =[NSString stringWithFormat:@"BoulderObjects/BoulderSprites/%@1%d",BOULDER_NAME, boulderType];

    //COMPLEXITY 2
    else if ([self contains:_currentBoulderCount low:BOUlDER_nextRank*2 high:BOUlDER_nextRank*3])
        boulderName =[NSString stringWithFormat:@"BoulderObjects/BoulderSprites/%@2%d",BOULDER_NAME, boulderType];
    
    //COMPLEXITY 3
    else// if ([self contains:_currentBoulderCount low:40 high:50]) {
    
        boulderName =[NSString stringWithFormat:@"BoulderObjects/BoulderSprites/%@3%d",BOULDER_NAME, boulderType];
    
    return boulderName;
}
-(int)getNextRandomNumber
{
//    NSNumber *num =  @((arc4random() % BOULDER_VARIETY_lvl_1) + 1);
//    [record addObject:num];
//    for (NSNumber * number in record) {
//        if ([num isEqual:number]) {
//            <#statements#>
//        }
//    }
   return ((arc4random() % BOULDER_VARIETY) + 1);
}
-(BOOL)contains:(NSUInteger)value low:(NSUInteger)low high:(NSUInteger)high
{
    BOOL isDoes = NO;
    if (low <= value && value <high)
        isDoes = YES;
    return isDoes;
}

@end
