//
//  InstructionsController.m
//  PondHopper
//
//  Created by shawn on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InstructionsController.h"

CGSize windowSize;
//static const ccColor3B ccGreen={57, 181, 74};
static const ccColor3B ccBlack={0, 0, 0};

@implementation InstructionsController

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	InstructionsController *layer = [InstructionsController node];
	
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
		
		CCColorLayer *backgroundColor=[CCColorLayer layerWithColor:ccc4(0, 210, 255, 255)];
		[self addChild:backgroundColor z:0];
		
		//Setup Background
		CCSprite *background;
		CCLabelTTF *instructionsLabel;
		NSString *instructionsString=[NSString stringWithFormat:@"Objective: Have the large green frog hop over the other characters to reach the lilly pad with the lotus flower.\n\nRules: \n1) Characters must hop over other characters to move. \n2) Characters can only hop up/down/left/right, not diagonally\n 3)Characters can hop over 1 or 2 characters.\n 4)The Green frog can not sit next to the Dragon Fly"];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			CCLOG(@"Loading iPad background");
			background =[CCSprite spriteWithFile:@"StonePond-ipad.png"];
			[CCMenuItemFont setFontSize:20];
			instructionsLabel=[CCLabelTTF 
							   labelWithString:instructionsString
							   dimensions:windowSize alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:44];
		}
		else
		{
			CCLOG(@"Loading iPhone background");
			background =[CCSprite spriteWithFile:@"StonePond.png"];
			[CCMenuItemFont setFontSize:20];
			instructionsLabel=[CCLabelTTF 
							   labelWithString:instructionsString
							   dimensions:windowSize alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:20];
		}
		background.position=ccp(windowSize.width/2,windowSize.height/2);
		[self addChild:background z:0];
		
		//id liquid=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
		//[background runAction:[CCRepeatForever actionWithAction:liquid]];
		
		
		instructionsLabel.position=ccp(windowSize.width/2,windowSize.height/2.5);
		[instructionsLabel setColor:ccWHITE];
		[self addChild:instructionsLabel z:1];
		
		
		[CCMenuItemFont setFontName:@"CHUBBY"];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[CCMenuItemFont setFontSize:60];
		}else{
			[CCMenuItemFont setFontSize:30];
		}
		//CCMenuItem *startMenuItem=[CCMenuItemFont itemFromString:@"Start" target:self selector:@selector(startGame)];
		CCMenuItem *mainMenuItem=[CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(showMainMenu)];
		CCMenu *inGameMenu=[CCMenu menuWithItems:mainMenuItem,nil];
		inGameMenu.position=ccp(windowSize.width/2, windowSize.height-(.9*windowSize.height));
		[inGameMenu setColor:ccYELLOW];
		[inGameMenu alignItemsVertically];
		[self addChild:inGameMenu z:1];
		
		
	}
	return self;
}

-(void) startGame{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameController scene]]];
	
}

-(void) showMainMenu{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuController scene]]];
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}

@end
