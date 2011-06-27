//
//  CreditsController.m
//  PondHopper
//
//  Created by shawn on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreditsController.h"


@implementation CreditsController

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditsController *layer = [CreditsController node];
	
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
			background =[CCSprite spriteWithFile:@"background-ipad.png"];
		}
		else
		{
			CCLOG(@"Loading iPhone background");
			background =[CCSprite spriteWithFile:@"background.png"];
		}
		background.position=ccp(windowSize.width/2,windowSize.height/2);
		[self addChild:background z:0];
		
		id liquid=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
		[background runAction:[CCRepeatForever actionWithAction:liquid]];
		
		
		
		[CCMenuItemFont setFontName:@"CHUBBY"];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[CCMenuItemFont setFontSize:48];
		}else{
			[CCMenuItemFont setFontSize:24];
		}
		
		CCMenuItem *startMenuItem=[CCMenuItemFont itemFromString:@"Start" target:self selector:@selector(startGame)];
		CCMenuItem *instructionsMenuItem=[CCMenuItemFont itemFromString:@"Instructions" target:self selector:@selector(showInstructions)];
		CCMenuItem *creditsMenuItem=[CCMenuItemFont itemFromString:@"Credits" target:self selector:@selector(showCredits)];
		CCMenu *inGameMenu=[CCMenu menuWithItems:startMenuItem,instructionsMenuItem,creditsMenuItem,nil];
		inGameMenu.position=ccp(windowSize.width/2, windowSize.height/2);
		[inGameMenu setColor:ccGreen];
		[inGameMenu alignItemsVertically];
		[self addChild:inGameMenu z:1];
		
		
	}
	return self;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}

@end
