//
//  MainSpaceScrollView.m
//  Fallin
//
//  Created by Alfonso on 5/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MainSpaceScrollView.h"
#import "MovableView.h"
@implementation MainSpaceScrollView
-(void)setOwner:(CCNode*)node
{
    [((MovableView*)self.contentNode) setOwner:node];
}
-(void)didLoadFromCCB
{
    [self setDelegate:self];
}
-(void)lastJumpAnimation
{
    CGPoint pos = super.scrollPosition;
    pos.x = 2 * super.contentSizeInPoints.width;
//    [self setScrollPosition:pos animated:YES withTime:2.0f];
    
}


//- (void)scrollViewDidScroll:(CCScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(CCScrollView *)scrollView
{
    [[OALSimpleAudio sharedInstance]playEffect:@"6.wav" volume:1.0f pitch:1.0f pan:0 loop:NO];
}
//- (void)scrollViewDidEndDragging:(CCScrollView * )scrollView willDecelerate:(BOOL)decelerate;
//- (void)scrollViewWillBeginDecelerating:(CCScrollView *)scrollView;
//- (void)scrollViewDidEndDecelerating:(CCScrollView *)scrollView;
@end
