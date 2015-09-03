//
//  MovableView.m
//  Fallin
//
//  Created by Alfonso on 5/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MovableView.h"

@implementation MovableView
{
    CCButton*_play;
    CCButton*_play2;
    CCButton*_faceBook;
    CCButton*_twitter;
    CCButton*_score;
    CCButton*_settings;
    CCButton*_rate;
    CCButton*_back;
}
-(void)setOwner:(CCNode *)node
{
    [_play setTarget:node selector:@selector(playButtonPressed)];
    [_play2 setTarget:node selector:@selector(playButtonPressed)];
    [_faceBook setTarget:node selector:@selector(faceBookButtonPressed)];
    [_twitter setTarget:node selector:@selector(twitterButtonPressed)];
    [_score setTarget:node selector:@selector(scoreButtonPressed)];
    [_settings setTarget:node selector:@selector(settingsButtonPressed)];
        [_rate setTarget:node selector:@selector(rateButtonPressed)];
    [_back setTarget:node selector:@selector(backButtonPressed)];
}

@end
