//
//  SettingsMenuController.h
//  PondHopper
//
//  Created by shawn on 10/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainMenuController.h"

@interface SettingsMenuController : CCLayer <UIAlertViewDelegate> {

}

+(id) scene;
-(id) init;

-(void)restartAllLevels;
-(void)clearAllLevelScores;
-(void)showMainMenu;

@end
