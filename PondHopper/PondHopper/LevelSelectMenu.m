//
//  LevelSelectMenu.m
//  PondHopper
//
//  Created by shawn on 10/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectMenu.h"

static const ccColor3B ccBlack={0, 0, 0};
@implementation LevelSelectMenu

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSelectMenu *layer = [LevelSelectMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		self.isTouchEnabled=YES;
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		
		// ask director the the window size
		windowSize = [[CCDirector sharedDirector] winSize];
		
		
		
		//Setup Background
		CCSprite *background;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			CCLOG(@"Loading iPad background");
			//background =[CCSprite spriteWithFile:@"background-ipad.png"];
			background =[CCSprite spriteWithFile:@"menu-ipad.png"];
		}
		else
		{
			CCLOG(@"Loading iPhone background");
			//background =[CCSprite spriteWithFile:@"background.png"];
			background =[CCSprite spriteWithFile:@"menu.png"];
		}
		background.position=ccp(windowSize.width/2,windowSize.height/2);
		[self addChild:background z:0];
		//id liquid=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
		//[background runAction:[CCRepeatForever actionWithAction:liquid]];
		
		//id liquid=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
		//[background runAction:[CCRepeatForever actionWithAction:liquid]];
		
		
		
		[CCMenuItemFont setFontName:@"CHUBBY"];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[CCMenuItemFont setFontSize:48];
		}else{
			[CCMenuItemFont setFontSize:24];
		}		
		CCMenuItem *trainingLevels=[CCMenuItemFont itemFromString:@"KOI POND" target:self selector:@selector(startTraining)];
		CCMenuItem *level1Levels=[CCMenuItemFont itemFromString:@"TURTLE POND" target:self selector:@selector(startLevel1)];
		CCMenuItem *level2Levels=[CCMenuItemFont itemFromString:@"BEAVER POND" target:self selector:@selector(startLevel2)];
		CCMenuItem *level3Levels=[CCMenuItemFont itemFromString:@"SNAKE POND" target:self selector:@selector(startLevel3)];
		CCMenuItem *level4Levels=[CCMenuItemFont itemFromString:@"CATTAIL POND" target:self selector:@selector(startLevel4)];
		CCMenuItem *mainMenuButton=[CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(showMainMenu)];
		//CCMenuItem *creditsMenuItem=[CCMenuItemFont itemFromString:@"Credits" target:self selector:@selector(showCredits)];
		CCMenu *inGameMenu=[CCMenu menuWithItems:trainingLevels,level1Levels,level2Levels,level3Levels,level4Levels,mainMenuButton,nil];
		inGameMenu.position=ccp(windowSize.width/2, windowSize.height/2);
		[inGameMenu setColor:ccYELLOW];
		[inGameMenu alignItemsVertically];
		[self addChild:inGameMenu z:1 tag:0];
		
	}
	return self;
}

-(void)showMainMenu{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuController scene]]];	
}


-(void) startTraining{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[individualLevelSelect trainingScene]]];
}

-(void) startLevel1{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[individualLevelSelect level1]]];
}
-(void) startLevel2{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[individualLevelSelect level2]]];
}
-(void) startLevel3{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[individualLevelSelect level3]]];
}
-(void) startLevel4{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[individualLevelSelect level4]]];
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}


@end
