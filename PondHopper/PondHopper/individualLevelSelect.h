//
//  individualLevelSelect.h
//  PondHopper
//
//  Created by shawn on 10/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "levelIconSprite.h"
#import "MenuGrid.h"
#import "GameController.h"
#include "MainMenuController.h"

@interface individualLevelSelect : CCLayer {
	int levelGroup;
}


@property (nonatomic) 	int levelGroup;

+(id) scene;
+(id) trainingScene;
+(id) level1;
+(id) level2;
+(id) level3;
+(id) level4;
-(id) init;
-(void) loadLevels:(int) levelToLoad;
//-(id) initWithDifficulty:(int) difficulty;

@end
