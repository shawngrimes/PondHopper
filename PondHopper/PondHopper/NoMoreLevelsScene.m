//
//  NoMoreLevelsScene.m
//  PondHopperLite
//
//  Created by shawn on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NoMoreLevelsScene.h"
#import "SHK.h"

@implementation NoMoreLevelsScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CCLOG(@"Creating no more scenes layer");
	NoMoreLevelsScene *layer = [NoMoreLevelsScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
		CCLOG(@"Creating no more scenes init");
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
		NSString *instructionsString=[NSString stringWithFormat:@"Sorry, no more levels.  Try the full version of Pond Hopper for 5 levels and 125 puzzles."];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			CCLOG(@"Loading iPad background");
			background =[CCSprite spriteWithFile:@"menu-ipad.png"];
			[CCMenuItemFont setFontSize:20];
			instructionsLabel=[CCLabelTTF 
							   labelWithString:instructionsString
							   dimensions:CGSizeMake(300, 400) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:40];
		}
		else
		{
			CCLOG(@"Loading iPhone background");
			background =[CCSprite spriteWithFile:@"menu.png"];
			[CCMenuItemFont setFontSize:20];
			instructionsLabel=[CCLabelTTF 
							   labelWithString:instructionsString
							   dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:20];
		}
		background.position=ccp(windowSize.width/2,windowSize.height/2);
		[self addChild:background z:0];
		
		//id liquid=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
		//[background runAction:[CCRepeatForever actionWithAction:liquid]];
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			instructionsLabel.position=ccp(.65*windowSize.width,windowSize.height-.45*windowSize.height);
		}else {
			instructionsLabel.position=ccp(.65*windowSize.width,windowSize.height-.45*windowSize.height);
		}

		[instructionsLabel setColor:ccWHITE];
		[self addChild:instructionsLabel z:1];
		
		
		[CCMenuItemFont setFontName:@"CHUBBY"];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[CCMenuItemFont setFontSize:60];
		}else{
			[CCMenuItemFont setFontSize:30];
		}
		CCMenuItem *startMenuItem=[CCMenuItemFont itemFromString:@"Buy Pond Hopper" target:self selector:@selector(buyPondHoper)];
		CCMenuItem *mainMenuItem=[CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(showMainMenu)];
		CCMenuItem *shareScoreButton=[CCMenuItemFont itemFromString:@"Share High Score..." target:self selector:@selector(shareLevelScore) ];
		CCMenu *inGameMenu=[CCMenu menuWithItems:startMenuItem,shareScoreButton,mainMenuItem,nil];
		inGameMenu.position=ccp(windowSize.width/2, windowSize.height-(.6*windowSize.height));
		[inGameMenu setColor:ccYELLOW];
		[inGameMenu alignItemsVertically];
		[self addChild:inGameMenu z:1];
		
		
	}
	return self;
}


-(int) getFinalScore{
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	int finalScore=0;
	for (int levelGroupNumber=0; levelGroupNumber<2; levelGroupNumber++) {
		int x=1;
		
		//	[NSString stringWithFormat:@"%i-%@",self.levelGroup,currentLevel]
		while (x<26) {
			//CCLOG(@"Getting score for level %i-%i",levelGroupNumber,x);
			finalScore+=[prefs integerForKey:[NSString stringWithFormat:@"%i-%i",levelGroupNumber,x]];
			x++;
		}
	}
	return finalScore;
	
}



-(void) shareLevelScore{
	int levelFinalScore=[self getFinalScore];
	SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"I beat Pond Hopper Lite with a score of %i http://mcaf.ee/fdb1c", levelFinalScore]];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showInView:[CCDirector sharedDirector].openGLView ];
}


-(NSString *)getLevelGroupName:(int)levelGroupNumber{
	switch (levelGroupNumber) {
		case 0:
			return @"Duck pond";
			break;
		case 1:
			return @"Stone Pond";
			break;
		case 2:
			return @"Turtle Pond";
			break;
		case 3:
			return @"Duck Pond";
			break;
		case 4:
			return @"Stone Pond";
			break;
		default:
			return @"";
			break;
	}
	return @"";
	
	
}


-(void) buyPondHoper{
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=395690775&mt=8&uo=6"]];
	
}

-(void) showMainMenu{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuController scene]]];
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}

@end
