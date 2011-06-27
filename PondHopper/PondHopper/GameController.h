//
//  ProofOfConcept.h
//  PondHopper
//
//  Created by shawn on 9/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "CCTouchHandler.h"
#import "LillyPad.h"
#import "Character.h"
#import "TBXML.h"
#import "MainMenuController.h"
#import "NoMoreLevelsScene.h"

typedef struct PadLocation {
	int x;
	int y;
} PadLocation;


@interface GameController : CCLayer  {
	int levelGroup;
	
	CCAction *_LargeFrogBlinkAction;
	CCAction *_LargeFrogFlyAction;
	CCAction *_DragonFlyAction;
	CCAction *_TreeFrogAction;
	CCAction *_LilyPadAction;
	CCAction *_LilyPadFlowerAction;
	
}

@property (nonatomic) int levelGroup;
@property (nonatomic, retain) 	CCAction *LargeFrogBlinkAction;
@property (nonatomic, retain) 	CCAction *LargeFrogFlyAction;
@property (nonatomic, retain)	CCAction *DragonFlyAction;
@property (nonatomic, retain) 	CCAction *TreeFrogAction;
@property (nonatomic, retain) 	CCAction *LilyPadAction;
@property (nonatomic, retain) CCAction *LilyPadFlowerAction;


+(id) scene;
+(id) sceneLevelGroup:(int) levelGroup levelNumber:(int) levelNumber;

-(BOOL) isValidMoveFromStart:(PadLocation) startLocation toFinish:(PadLocation) finishLocation forCharacter:(Character *)placingCharacter;
-(void) displayWinner;
-(BOOL) checkForWin;
-(void) loadLevelFromGroup:(int) levelGroup  level:(int)levelNumber;
-(void)goBackLevel;
-(void)nextLevel;
-(void)restartLevel;
-(int) getFinalScore;
//-(void)clearAllLevelScores;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
-(BOOL) isGameCenterAvailable;
-(NSString *)getLevelGroupName:(int)levelGroupNumber;
-(void) clearHighlights;
-(void) showHighlights;
-(int) getLevelScore;
-(void) reportFinalScore:(NSNumber *) finalScore;

@end
