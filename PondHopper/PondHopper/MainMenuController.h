//
//  MainMenuController.h
//  PondHopper
//
//  Created by shawn on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

#import "LevelSelectMenu.h"

#import "GameController.h"
#import "InstructionsController.h"
#import "CreditsController.h"
#include "SettingsMenuController.h"

@interface MainMenuController : CCLayer<GKLeaderboardViewControllerDelegate> {

}



+(id) scene;
-(id) init;

-(void) startGame;
-(void) showInstructions;
-(void) showCredits;
-(BOOL) isGameCenterAvailable;
- (void) authenticateLocalPlayer;
-(void) showScores;
-(void) leaderboardShow;
- (void) showLeaderboard;

@end
