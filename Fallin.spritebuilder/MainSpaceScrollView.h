//
//  MainSpaceScrollView.h
//  Fallin
//
//  Created by Alfonso on 5/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScrollView.h"

@interface MainSpaceScrollView : CCScrollView <CCScrollViewDelegate>
-(void)lastJumpAnimation;
-(void)setOwner:(CCNode*)node;
@end
