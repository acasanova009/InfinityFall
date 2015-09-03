//
//  EndGame.m
//  Fallin
//
//  Created by Alfonso on 5/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "EndGame.h"
#import "Coffin.h"
@implementation EndGame
{
        CCLabelTTF * _distance;
        CCLabelTTF * _diamonds;
        CCLabelTTF * _bestDistance;
        CCLabelTTF * _totalDiamonds;
}
-(void)update:(CCTime)delta
{
    Treasure*tr = [[Coffin sharedCoffin]treasure];
    [_distance setString: [NSString  stringWithFormat:@"%lum",(unsigned long)tr.lastFallDistance]];
    [_diamonds setString: [NSString  stringWithFormat:@"%lu",(unsigned long)tr.lastFallDiamonds]];
    
    
    [_bestDistance setString: [NSString  stringWithFormat:@"%lum",(unsigned long)tr.bestDistance]];
    [_totalDiamonds setString: [NSString  stringWithFormat:@"%lu",(unsigned long)tr.totalDiamonds]];
    
}
@end
