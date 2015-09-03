//
//  Space.m
//  Fallin
//
//  Created by Alfonso on 5/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Space.h"
#import "MovableObject.h"
@implementation Space

{
    int spaceKind;
}
-(void)setCustomSpeed:(float)speed positive:(BOOL)up
{
    if (up) {
        [self setPosition:ccp(self.position.x, self.position.y-speed)];
        for (CCNode* n in self.children) {
            [n setPosition:ccp(n.position.x, n.position.y-speed)];
        }
    }
    else{
        [self setPosition:ccp(self.position.x, self.position.y+speed)];
        for (CCNode* n in self.children) {
            
//            
//            if ([n.description isEqualToString:@"Diamond"]) {
//                MovableObject* momo = (MovableObject*)n;
//                if (momo.shouldStopScrolling) {
//                    break;
//                }
//                
//            }
                [n setPosition:ccp(n.position.x, n.position.y+speed)];
        
        }
    }
}


-(void)didLoadFromCCB
{
//    self.physicsBody se

//    for (CCSprite* spr in self.children) {
//        [spr.physicsBody setCollisionMask:@[cow]];
//        [spr.physicsBody setCollisionCategories:@[batch]];
//    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"SpaceKind%d",spaceKind];
}
@end
