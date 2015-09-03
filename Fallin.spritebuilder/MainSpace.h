//
//  MainSpace.h
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Space.h"
#import "MainSpaceScrollView.h"
@interface MainSpace : Space
@property (readonly)  MainSpaceScrollView * scroll;
-(void)setOwner:(CCNode*)node;
@end
