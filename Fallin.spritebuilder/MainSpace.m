//
//  MainSpace.m
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MainSpace.h"

@implementation MainSpace
{

   
}

-(void)didLoadFromCCB
{
//{    [_play setTarget:self selector:@selector(playButtonPressed)];
    [_scroll setHorizontalPage:0 animated:NO];
    for (CCNode* n in self.children)
        [n.physicsBody setCollisionGroup:menu];
    
}
-(void)setOwner:(CCNode*)node
{
    [_scroll setOwner:node];
}
@end
