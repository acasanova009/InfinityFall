//
//  Tresure.m
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Treasure.h"

#define kArmorName @"amorName"
#define kParachuteName @"parachuteName"
#define kLeyendName @"leyendName"

#define kDisance @"distance"
#define kDiamons @"diamons"
#define kFastMode @"fastMode"
#define kLastFallDistance @"lfDiamonds"
#define kLastFallDiamonds @"lfDistance"
@implementation Treasure

- (id)init
{
    self = [super init];
    if (self) {
        self.currentArmorName = @"";
        self.currentLeyendName = @"";
        self.currentParachuteName = @"";
        self.bestFastMode = 0;
        
        _bestDistance = 0;
        self.totalDiamonds =0;
        self.lastFallDiamonds = 0;
        [self setLastFallDistance:0];
        
    }
    return self;
}

+(NSURL*)getTreasureURL
{
    NSArray* urls =  [[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [urls[0] URLByAppendingPathComponent:@"treasure"];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Treasure; Armor: %@.  Parachute: %@.  Leyend: %@.  Diamons: %lu.  Distance %lu.  FastMode: %lu.",
            self.currentArmorName,
            self.currentParachuteName,
            self.currentLeyendName,
            (unsigned long)self.totalDiamonds,
            (unsigned long)self.bestDistance,
            (unsigned long)self.bestFastMode
            ];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super init];
    if (self) {

        self.currentArmorName =[aDecoder decodeObjectForKey:kArmorName];
        self.currentLeyendName = [aDecoder decodeObjectForKey:kLeyendName];
        self.currentParachuteName = [aDecoder decodeObjectForKey:kParachuteName];
        
        self.totalDiamonds = [aDecoder decodeIntegerForKey:kDiamons];
        _bestDistance = [aDecoder decodeIntegerForKey:kDisance];
        self.bestFastMode = [aDecoder decodeIntegerForKey:kFastMode];
        
        self.lastFallDiamonds = [aDecoder decodeIntegerForKey:kLastFallDiamonds];
        self.lastFallDistance = [aDecoder decodeIntegerForKey:kLastFallDistance];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.currentArmorName forKey:kArmorName];
    [aCoder encodeObject:self.currentLeyendName forKey:kLeyendName];
    [aCoder encodeObject:self.currentParachuteName forKey:kParachuteName];
    
    [aCoder encodeInteger:self.bestFastMode forKey:kFastMode];
    [aCoder encodeInteger:self.bestDistance  forKey:kDisance];
    [aCoder encodeInteger:self.totalDiamonds forKey:kDiamons];
    
        [aCoder encodeInteger:self.lastFallDistance forKey:kLastFallDistance];
        [aCoder encodeInteger:self.lastFallDiamonds forKey:kLastFallDiamonds];
    
    
}
-(void)addOneDiamond
{
    self.totalDiamonds+=1;
}

-(void)setLastFallDistance:(NSUInteger)lastFallDistance
{
    _lastFallDistance = lastFallDistance;
    if (_lastFallDistance >= _bestDistance) {
        //GGG
        _bestDistance = _lastFallDistance;
    }
}

@end
