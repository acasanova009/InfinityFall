//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "CowLifeProtocol.h"
@interface MainScene : CCNode <CowLifeProtocol>

-(void)playButtonPressed;
-(void)faceBookButtonPressed;
-(void)scoreButtonPressed;
-(void)settingsButtonPressed;
-(void)twitterButtonPressed;
-(void)rateButtonPressed;
-(void)backButtonPressed;
@end
