//
//  Tresure.h
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Treasure : NSObject<NSCoding>


@property  NSString *currentArmorName;
@property (nonatomic) NSString *currentParachuteName;
@property (nonatomic) NSString *currentLeyendName;

@property (nonatomic,readonly) NSUInteger bestDistance;
@property (nonatomic) NSUInteger totalDiamonds;
@property (nonatomic) NSUInteger bestFastMode;

@property (nonatomic) NSUInteger lastFallDiamonds;
@property (nonatomic, setter = setLastFallDistance:) NSUInteger lastFallDistance;



-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)initWithCoder:(NSCoder *)aDecoder;

+(NSURL*)getTreasureURL;
-(void)addOneDiamond;

@end
