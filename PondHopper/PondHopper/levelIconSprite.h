//
//  levelIconSprite.h
//  PondHopper
//
//  Created by shawn on 10/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface levelIconSprite : CCSprite {
	
}

+(id) createLevelIconForLevel;
-(void) setLevelLabel:(int) levelNumber;
-(void) setComplete:(bool) isComplete;

@end
