//
//  Counter.m
//  Fallin
//
//  Created by Alfonso on 5/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Counter.h"
#define kMaxCapacity 4
#define kDiamondValue 1
@implementation Counter
{

    int _current;
    
        CCNode*_part0;
        CCNode*_part1;
        CCNode*_part2;
        CCNode*_part3;
    NSArray * nodes;
}
-(void)didLoadFromCCB
{
    nodes = @[_part0,_part1,_part2,_part3];
    _current = 0;
}
-(void)update:(CCTime)delta
{
    //Improve Self Knowing of max scale size.
//[    _inn setScale:(float)0.03*_current];
//    for (CCNode* part in  nodes) {
//        [part setVisible:NO];
//    }
//    switch (_current) {
//        case 1:
//                        [_part0 setVisible:YES];
//            break;
//        case 2:
//                        [_part0 setVisible:YES];
//                        [_part1 setVisible:YES];
//            break;
//        case 3:
//                        [_part0 setVisible:YES];
//                        [_part1 setVisible:YES];
//                        [_part2 setVisible:YES];
//            break;
//        case 4:
//                        [_part0 setVisible:YES];
//                        [_part1 setVisible:YES];
//                        [_part2 setVisible:YES];
//                        [_part3 setVisible:YES];
//            break;
//            
//        default:
//            
//            break;
//    }
    
}
-(void)addDiamond
{
    _current+=kDiamondValue;
    if (_current>=kMaxCapacity)
        _current = kMaxCapacity;
    
   CCNode* part =  nodes[(_current-1)];
    if (!part.visible) {
        [part setVisible:YES];
    }
}
-(BOOL)isPowerReady
{
    BOOL isReady = false;
    if (_current == kMaxCapacity) {
        isReady = true;
    }
    return isReady;
}
-(void)consumeDiamonds
{
    if ([self isPowerReady]) {
        [self resetCounter];
    }
}
-(void)resetCounter
{
    for (CCNode* part in  nodes)
        [part setVisible:NO];
    _current = 0;
}
@end
