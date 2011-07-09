//
//  ProofOfConcept.m
//  PondHopper
//
//  Created by shawn on 9/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "SHKItem.h"
#import "SHKActionSheet.h"

#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

#include <stdlib.h>

@class FlurryAPI;

LillyPad *lillypads[4][4];

@implementation GameController

@synthesize levelGroup;
@synthesize LargeFrogBlinkAction=_LargeFrogBlinkAction;
@synthesize DragonFlyAction=_DragonFlyAction;
@synthesize TreeFrogAction=_TreeFrogAction;
@synthesize LargeFrogFlyAction=_LargeFrogFlyAction;
@synthesize LilyPadAction=_LilyPadAction;
@synthesize LilyPadFlowerAction=_LilyPadFlowerAction;


Character *movingCharacter;
PadLocation startPoint;
PadLocation finishPoint;
int topPiece=3;
CCSprite *background;
CGSize windowSize;
int currentLevel;
CCLabelTTF *currentLevelLabel;
CCLabelTTF *currentMovesString;

int moveCount=0;
int restartCount;
int minimumMovesToWin;
id liquidAction;
CCAction *backgroundAction;
BOOL dontPlayMusic;
BOOL dontPlaySFX;
ALuint lastPlayedFile;
CDLongAudioSource* bgMusic;



//static const ccColor3B ccGreen={57, 181, 74};


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameController *layer = [GameController node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(id) sceneLevelGroup:(int) levelGroup levelNumber:(int) levelNumber{
	
	if(levelGroup==6){
		CCLOG(@"Show no more levels1111");
		return [NoMoreLevelsScene scene];
	}
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameController *layer = [GameController node];
	layer.levelGroup=levelGroup;
	[layer loadLevelFromGroup:levelGroup  level:levelNumber];
	
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
		
		CCSprite *backgroundFish;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			backgroundFish=[CCSprite spriteWithFile:@"FishUnderWater-ipad.png"];
		}else{
			backgroundFish=[CCSprite spriteWithFile:@"FishUnderWater.png"];
		}
		backgroundFish.position=ccp(windowSize.width/2,windowSize.height/2);
		liquidAction=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
		backgroundAction=[backgroundFish runAction:[CCRepeatForever actionWithAction:liquidAction]];
		[self addChild:backgroundFish z:0];
		
		
//		CCColorLayer *backgroundColor=[CCColorLayer layerWithColor:ccc4(0, 210, 255, 255)];
//		[self addChild:backgroundColor z:0];
		
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sheet-hd.plist"];
//			[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lillyPads-ipad.plist"];
		}else{
//			[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"characters-iphone.plist"];
			[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sheet.plist"];
			
			//CCSpriteBatchNode *batchNode=[CCSpriteBatchNode batchNodeWithFile:@"characters-iphone.png"];
		}
		
		//Setup Background
		//CCSprite *background;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			CCLOG(@"Loading iPad background");
			background =[CCSprite spriteWithFile:@"KoiPond-ipad.png"];
		}
		else
		{
			CCLOG(@"Loading iPhone background");
			background =[CCSprite spriteWithFile:@"KoiPond.png"];
		}
		background.position=ccp(windowSize.width/2,windowSize.height/2);
		[self addChild:background z:0];
		
		
		//Setup Lilly Pads
		for (int x=0; x<4; x++) {
			for (int y=0; y<4; y++) {
				float posX;
				float posY;
				if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				{
					// The device is an iPad running iPhone 3.2 or later.
					//					 posX=((x+1)*80+(x*120));
					posX=((x+1)*71+(x*71)+(x*25))+63;//104
					//					 posY=windowSize.height-(((y+1)*80)+(y*80)+170) ;
					posY=windowSize.height-((y+1)*65 + (y*60) + (y*35) + 250); //232
					CCLOG(@"Pos: %fx%f", posX, posY);
					lillypads[x][y] = [LillyPad spriteWithSpriteFrameName:@"LilyPad.png"];
					lillypads[x][y].isGoal=NO;
					lillypads[x][y].position=ccp(posX, posY);
				}else{
					posX=((x+1)*35.5+(x*23.5)+(x*10.5))+15.5;//104
					//					 posY=windowSize.height-(((y+1)*80)+(y*80)+170) ;
					posY=windowSize.height-((y+1)*30 + (y*30) + (y*17.5) + 105); //232
					CCLOG(@"Pos: %fx%f", posX, posY);
					//if(x==0 && y==0){
					//	lillypads[x][y] = [LillyPad spriteWithSpriteFrameName:@"lotus.png"];
					//	lillypads[x][y].isGoal=YES;
					//}else{
					lillypads[x][y] = [LillyPad spriteWithSpriteFrameName:@"LilyPad.png"];
					lillypads[x][y].isGoal=NO;
					//}
					lillypads[x][y].position=ccp(posX, posY);
				}
				[self addChild:lillypads[x][y] z:1];
				
			}
		}
		NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
		if([prefs integerForKey:@"currentLevel"]!=0){
			currentLevel=[prefs integerForKey:@"currentLevel"];
		}else{
			currentLevel=1;
		}
		self.levelGroup=[prefs integerForKey:@"currentGroup"];
		
		CCLOG(@"Current Level: %i", currentLevel);
		//[NSString stringWithFormat:@"Current Level: %i", currentLevel]
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			currentLevelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %i", currentLevel] fontName:@"CHUBBY" fontSize:44];
		}else{
			currentLevelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %i", currentLevel] fontName:@"CHUBBY" fontSize:22];
		}
//		currentLevelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Current Level: %i", currentLevel] fontName:@"CHUBBY" fontSize:20];
		[currentLevelLabel setColor:ccBLACK];
//		currentLevelLabel.position=ccp(windowSize.width/2, windowSize.height-(.1*windowSize.height));

		//This puts it at the top
		currentLevelLabel.position=ccp(windowSize.width/2, windowSize.height-(.22*windowSize.height));
		
		//This puts it at the bottom
		//currentLevelLabel.position=ccp(windowSize.width/2, (.05*windowSize.height));
		[self addChild:currentLevelLabel z:1 tag:99];

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			currentMovesString=[CCLabelTTF labelWithString:@"" fontName:@"CHUBBY" fontSize:44];
		}else{
			currentMovesString=[CCLabelTTF labelWithString:@"" fontName:@"CHUBBY" fontSize:22];
		}
		[currentMovesString setColor:ccBLACK];
		//This puts it at the top
		//currentMovesString.position=ccp(windowSize.width/2, windowSize.height-(.19*windowSize.height));
		
		//This puts it at the bottom
		currentMovesString.position=ccp(windowSize.width/2, (.05*windowSize.height));
		[self addChild:currentMovesString z:1 tag:0];
		
		[CCMenuItemFont setFontName:@"CHUBBY"];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[CCMenuItemFont setFontSize:48];
		}else{
			[CCMenuItemFont setFontSize:24];
		}
		
		CCMenuItem *restartLevelButtonItem;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			restartLevelButtonItem=[CCMenuItemImage itemFromNormalImage:@"restartIcon-hd.png" selectedImage:@"restartIconSelected-hd.png" target:self selector:@selector(restartLevel)];
		}else{
			restartLevelButtonItem=[CCMenuItemImage itemFromNormalImage:@"restartIcon.png" selectedImage:@"restartIconSelected.png" target:self selector:@selector(restartLevel)];
		}
		CCMenu *restartMenu=[CCMenu menuWithItems:restartLevelButtonItem,nil];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			restartMenu.position=ccp(windowSize.width-44,46);
		}else{
			restartMenu.position=ccp(windowSize.width-22,24);
		}
		[self addChild:restartMenu z:1 tag:77];
		
		CCMenuItem *menuButtonItem=[CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MenuIcon.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MenuIcon-selected.png"] target:self selector:@selector(showGameMenu)];
		CCMenu *menu = [CCMenu menuWithItems:menuButtonItem,nil];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			menu.position=ccp(50, 52);
		}else{
			menu.position=ccp(25, 26);
		}
//		menu.position=ccp(50, windowSize.height-20);
		[self addChild:menu z:1];
		
		moveCount=0;
		restartCount=0;
		
		
//		[self addChild:batchNode z:3 tag:70];
		
		NSMutableArray *lilyPadSplashAnimFrames=[NSMutableArray array];
		[lilyPadSplashAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPad-splash.png"]];
		[lilyPadSplashAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPad.png"]];
         CCAnimation *lilyPadAnim=[CCAnimation animationWithFrames:lilyPadSplashAnimFrames delay:0.2f];
		self.LilyPadAction=[CCAnimate actionWithAnimation:lilyPadAnim restoreOriginalFrame:NO];

		NSMutableArray *lilyPadFlowerSplashAnimFrames=[NSMutableArray array];
		[lilyPadFlowerSplashAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPadFlower-splash.png"]];
		[lilyPadFlowerSplashAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPadFlower.png"]];
		CCAnimation *lilyPadFlowerAnim=[CCAnimation  animationWithFrames:lilyPadFlowerSplashAnimFrames delay:0.2f];
		self.LilyPadFlowerAction=[CCAnimate actionWithAnimation:lilyPadFlowerAnim restoreOriginalFrame:NO];
		
		
		NSMutableArray *fatFrogAnimFrames=[NSMutableArray array];
		[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrogBlink1.png"]];
		[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrogBlink2.png"]];
		[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrogBlink1.png"]];
		[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
		//[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
		
		CCAnimation *fatFrogAnim=[CCAnimation animationWithFrames:fatFrogAnimFrames delay:0.2f];
		self.LargeFrogBlinkAction=[CCAnimate actionWithAnimation:fatFrogAnim restoreOriginalFrame:NO];
		
		NSMutableArray *dragonFlyAnimFrames=[NSMutableArray array];
		[dragonFlyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFlyBlink1.png"]];
		[dragonFlyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFlyBlink2.png"]];
		[dragonFlyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFlyBlink1.png"]];
		[dragonFlyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFly0.png"]];
		
		CCAnimation *dragonFlyAnim=[CCAnimation animationWithFrames:dragonFlyAnimFrames delay:0.2f];
		self.DragonFlyAction =[CCAnimate actionWithAnimation:dragonFlyAnim restoreOriginalFrame:NO];
		
		NSMutableArray *treeFrogAnimFrames=[NSMutableArray array];
		[treeFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrogBlink1.png"]];
		[treeFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrogBlink2.png"]];
		[treeFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrogBlink1.png"]];
		[treeFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrog0.png"]];
		
		CCAnimation *treeFrogAnim=[CCAnimation animationWithFrames:treeFrogAnimFrames delay:0.2f];
		self.TreeFrogAction =[CCAnimate actionWithAnimation:treeFrogAnim restoreOriginalFrame:NO];
		
		NSMutableArray *LargeFrogFlyAnimFrames=[NSMutableArray array];
		for(int frameX=1;frameX<13;frameX++){
			[LargeFrogFlyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"FatFrogMosquito%i.png", frameX]]];	
		}
		
		CCAnimation *LargeFrogFlyAnim=[CCAnimation animationWithFrames:LargeFrogFlyAnimFrames delay:0.1f];
		
		self.LargeFrogFlyAction=[CCAnimate actionWithAnimation:LargeFrogFlyAnim restoreOriginalFrame:YES];
		
//		Character *testFrog=[Character characterWithType:2];
//		[batchNode addChild:testFrog];
//		testFrog.position=ccp(windowSize.width/2, windowSize.height/2);
	
		//[self loadLevel:currentLevel];
		//[self loadLevel:110];
		
		[self schedule:@selector(BlinkSelector:) interval:3.0];
		[self schedule:@selector(FrogFlyEatSelector:) interval:45];
		
	}
	
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	dontPlayMusic=[((NSNumber*)[prefs valueForKey:@"MUSIC"]) integerValue];
	dontPlaySFX=[((NSNumber*)[prefs valueForKey:@"SFX"]) integerValue];
	
	if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]){
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
	
	bgMusic=[[CDAudioManager sharedManager] audioSourceForChannel:kASC_Right];
	
	if(!dontPlaySFX){
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"flyBuzzShort.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"bigCroak.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"bigSplashLoud.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"smallRibbit.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"smallSplashLoud.caf"];
	}
	
	if(!dontPlaySFX){
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"forestSoundsShort.caf"];
		[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(playForestSounds)];
		//[self schedule:@selector(playForestSounds:) interval:4.0];
	}
	
	return self;
}

#pragma mark -
#pragma mark animations
-(void) BlinkSelector: (ccTime) dt{

	if(movingCharacter==nil)
	{
		
			int x = arc4random() % 4;
			int y = arc4random() % 4;
		
			while((lillypads[x][y].characterOnPad.size<1)){
				x=arc4random() %4;
				y=arc4random() %4;
			}

			switch (lillypads[x][y].characterOnPad.size) {
				case 1:
					[lillypads[x][y].characterOnPad runAction:self.TreeFrogAction];
					break;
				case 2:
					[lillypads[x][y].characterOnPad runAction:self.LargeFrogBlinkAction];
					break;

				case 3:
					[lillypads[x][y].characterOnPad runAction:self.DragonFlyAction];
				default:
					break;
			}	
	}
}

-(void) FrogFlyEatSelector: (ccTime) dt{
	
	if(movingCharacter==nil)
	{
		for(int x=0; x<4; x++){
			for (int y=0; y<4; y++){
				if (lillypads[x][y].characterOnPad.size==2) {
					[lillypads[x][y].characterOnPad stopAction:self.LargeFrogBlinkAction];
					[lillypads[x][y].characterOnPad runAction:self.LargeFrogFlyAction];
					[lillypads[x][y].characterOnPad setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
					x=5;y=5;
				}
			}
		}
	}
}

-(void) playForestSounds{
//	if(![bgMusic isPlaying]){
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"forestSoundsShort.caf" loop:YES];
//		[self unschedule:@selector(playForestSounds:)];

//	}
	
	
}

#pragma mark Handle Touches
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return NO;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	CCLOG(@"Touches: %i", [touches count]);
	
	if([self getChildByTag:5]){
		[self removeChild:[self getChildByTag:5] cleanup:YES];
		[self removeChild:[self getChildByTag:6] cleanup:YES];
	}
	
	if([touches count]>1){
		//Display Menu
		//[self showGameMenu];
	}else{
		if([[CCActionManager sharedManager] getActionByTag:44 target:movingCharacter]){
			if(![[[CCActionManager sharedManager] getActionByTag:44 target:movingCharacter] isDone])
			{
				CCLOG(@"Action still running");
				
				return;
			}
		}
		
		UITouch *touch=[[touches allObjects] objectAtIndex:0];
		CGPoint currentTouchLocation = [touch locationInView:[touch view]];
		
		if(![self checkForWin]){
			for (int x=0; x<4; x++) {
				for (int y=0; y<4; y++) {
						if(CGRectContainsPoint([lillypads[x][y] rect], currentTouchLocation)){
							
							CCLOG(@"Found touch in %i x %i", x, y);
							
							if(lillypads[x][y].characterOnPad!=nil){
								CCLOG(@"Character on pad");
								if(movingCharacter!=nil){
									switch (movingCharacter.size) {
										case 1:
											[movingCharacter stopAction:self.TreeFrogAction];
											[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrog0.png"]];
											break;
										case 2:
											[movingCharacter stopAction:self.LargeFrogBlinkAction];
											[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
											break;
										case 3:
											[movingCharacter stopAction:self.DragonFlyAction];
											[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFly0.png"]];
											break;
										default:
											break;
									}
									movingCharacter=nil;
									[self clearHighlights];
								}
								
								lillypads[x][y].characterOnPad.selected=YES;
								movingCharacter=lillypads[x][y].characterOnPad;
								
								if(lastPlayedFile){
									CCLOG(@"Stopping sfx 1");
									[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
								}
								[movingCharacter stopAllActions];
								switch (movingCharacter.size) {
									case 1:
										[movingCharacter stopAction:self.TreeFrogAction];
										//[movingCharacter runAction:self.TreeFrogAction];
										[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrog1.png"]];
										if(!dontPlaySFX){
											lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"smallRibbit.caf"];
										}
										break;
									case 2:
										[movingCharacter stopAction:self.LargeFrogBlinkAction ];
										//[movingCharacter runAction:self.LargeFrogJumpAction];
										[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog1.png"]];
										if(!dontPlaySFX){
											lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"bigCroak.caf"];
										}
										
										break;
									case 3:
										[movingCharacter stopAction:self.DragonFlyAction ];
										[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFly1.png"]];
										//[movingCharacter runAction:self.DragonFlyAction];
										if(!dontPlaySFX){
											lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"flyBuzzShort.caf"];
										}
										break;
									default:
										break;
								}
								
								startPoint.x=x;
								startPoint.y=y;
								finishPoint.x=x;
								finishPoint.y=y;
								//lillypads[x][y].characterOnPad=nil;
								[self showHighlights];
									if(movingCharacter) [self reorderChild:movingCharacter z:3];
							}else{
								CCLOG(@"No Character on pad");
								finishPoint.x=x;
								finishPoint.y=y;
							}
						}
				}
			}
		}
		
		
	}
	CCLOG(@"Touch Start Finish: Start: %ix%i Finish: %ix%i", startPoint.x,startPoint.y,finishPoint.x,finishPoint.y);
}

-(void) clearHighlights{
	for (int x=0; x<4; x++) {
		for (int y=0; y<4; y++) {
			if(lillypads[x][y].isGoal){
				[lillypads[x][y] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPadFlower.png"]];
			}else{
				[lillypads[x][y] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPad.png"]];
			}
		}
	}
}

-(void) showHighlights{
	PadLocation highlightPad;
	for (int x=0; x<4; x++) {
		for (int y=0; y<4; y++) {
			highlightPad.x=x; 	
			highlightPad.y=y;
			//CCLOG(@"Found touch ended in %i x %i", x, y);
			if([self isValidMoveFromStart:startPoint toFinish:highlightPad forCharacter:movingCharacter]){
				if(lillypads[x][y].isGoal){
					[lillypads[x][y] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPadFlower-glow.png"]];
				}else{
					[lillypads[x][y] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPad-glow.png"]];
				}
			}
		}
	}
	
	
}


-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch=[[touches allObjects] objectAtIndex:0];
	CGPoint currentLocation = [touch locationInView:[touch view]];
	if(movingCharacter != nil){
		//CCLOG(@"Moving sprite sized: %i Owned by: %i", movingSprite.size, movingSprite.owner);
		[movingCharacter movePiece:currentLocation];
	}
	
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	//Check if on placeable square, otherwise return to start
	CCLOG(@"ccTouchesEnded Start");
	CCLOG(@"Start: %ix%i Finish: %ix%i", startPoint.x, startPoint.y,finishPoint.x,finishPoint.y);
	UITouch *touch=[[touches allObjects] objectAtIndex:0];
	CGPoint currentLocation = [touch locationInView:[touch view]];
	
	for (int x=0; x<4; x++) {
		for (int y=0; y<4; y++) {
			if(CGRectContainsPoint([lillypads[x][y] rect], currentLocation)){
				finishPoint.x=x; 	
				finishPoint.y=y;
			}
		}
	}
	
	if(movingCharacter!=nil && (startPoint.x==finishPoint.x && startPoint.y==finishPoint.y)){
		CCLOG(@"ccTouchesEnded: Case 1");
		BOOL match=NO;
		for (int x=0; x<4; x++) {
			for (int y=0; y<4; y++) {
				if(CGRectContainsPoint([movingCharacter rect], [lillypads[x][y] correctedPosition])){
					finishPoint.x=x; 	
					finishPoint.y=y;
					CCLOG(@"Found touch ended in %i x %i", x, y);
					if([self isValidMoveFromStart:startPoint toFinish:finishPoint forCharacter:movingCharacter]){
						//CCAction *rippleAction=[CCRipple3D actionWithPosition:movingCharacter.position radius:100.0 waves:20 amplitude:160.0f grid:ccg(32,24) duration:3.0f];
						//[lillypads[finishPoint.x][finishPoint.y] runAction:rippleAction];
						
						[lillypads[x][y] addCharacterToPad:movingCharacter];
						lillypads[x][y].characterOnPad.selected=NO;
						lillypads[startPoint.x][startPoint.y].characterOnPad=nil;
						if(movingCharacter) [self reorderChild:movingCharacter z:2];
						if(movingCharacter.size==3){
							if(lastPlayedFile){
								CCLOG(@"Stopping sfx 2");
								[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
							}	
						}
						switch (movingCharacter.size) {
							case 1:
								[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrog0.png"]];
								if(!dontPlaySFX){
									lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"smallSplashLoud.caf"];
								}
								break;
							case 2:
								[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
								if(!dontPlaySFX){
									lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"bigSplashLoud.caf"];
								}
								break;
							case 3:
								[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFly0.png"]];
								break;
							default:
								break;
						}
						if(lillypads[x][y].isGoal){
							[lillypads[x][y] runAction:self.LilyPadFlowerAction];
						}else{
							[lillypads[x][y] runAction:self.LilyPadAction];
						}
						
						
						
						movingCharacter=nil;
						
						startPoint.x=-1;
						startPoint.y=-1;
						
						moveCount++;
						[currentLevelLabel setString:[NSString stringWithFormat:@"Level: %i-%i (%i moves)", self.levelGroup+1,currentLevel, moveCount]];
						
						match=YES;
						x=4;
						y=4;
						[self clearHighlights];
					}
					
					
				}
			}
		}
		if(!match && (startPoint.x!=finishPoint.x || startPoint.y!=finishPoint.y)){
			CCLOG(@"ccTouchesEnded: Case 2");
			if(lastPlayedFile){
				CCLOG(@"Stopping sfx 2b");
				[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
			}	
			movingCharacter.position=lillypads[startPoint.x][startPoint.y].position;
			switch (movingCharacter.size) {
				case 1:
					[movingCharacter stopAction:self.TreeFrogAction];
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrog0.png"]];
					break;
				case 2:
					[movingCharacter stopAction:self.LargeFrogBlinkAction];
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
					break;
				case 3:
					[movingCharacter stopAction:self.DragonFlyAction];
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFly0.png"]];
					break;
				default:
					break;
			}
			
			if(movingCharacter) [self reorderChild:movingCharacter z:2];
			[self clearHighlights];
			
			[lillypads[startPoint.x][startPoint.y] addCharacterToPad:movingCharacter];
			
			movingCharacter=nil;
			
			
			//Commented for touch testing
			//			movingCharacter=nil;
		}
		else if(!match && (lillypads[startPoint.x][startPoint.y].position.x!=movingCharacter.position.x || lillypads[startPoint.x][startPoint.y].position.y!=movingCharacter.position.y))
		{
			CCLOG(@"ccTouchesEnded: Case 3");
			movingCharacter.position=lillypads[startPoint.x][startPoint.y].position;
			switch (movingCharacter.size) {
				case 1:
					[movingCharacter stopAction:self.TreeFrogAction];
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrog0.png"]];
					break;
				case 2:
					[movingCharacter stopAction:self.LargeFrogBlinkAction];
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
					break;
				case 3:
					[movingCharacter stopAction:self.DragonFlyAction];
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFly0.png"]];
					break;
				default:
					break;
			}
			
			if(movingCharacter) [self reorderChild:movingCharacter z:2];
			[self clearHighlights];
			movingCharacter=nil;
			
		}
	}
	else if(movingCharacter!=nil && (startPoint.x!=finishPoint.x || startPoint.y!=finishPoint.y)) {
		CCLOG(@"ccTouchesEnded: Case 4");
		CCLOG(@"Else: Start: %ix%i Finish: %ix%i", startPoint.x,startPoint.y,finishPoint.x,finishPoint.y);
		if([self isValidMoveFromStart:startPoint toFinish:finishPoint forCharacter:movingCharacter]){
			CCLOG(@"Valid Move");
			id jumpAction=[CCJumpTo actionWithDuration:0.5f position:lillypads[finishPoint.x][finishPoint.y].position height:0.5f jumps:1];
			id soundAction=[CCCallFunc actionWithTarget:self selector:@selector(playSoundJumpSoundEffect)];
			CCAction *jumpAndSoundAction=[CCSequence actions:jumpAction,soundAction,nil];
			jumpAndSoundAction.tag=44;
			[movingCharacter runAction:jumpAndSoundAction];
			
			
			CCLOG(@"Running actions: %i", [[CCActionManager sharedManager] numberOfRunningActionsInTarget:movingCharacter]);
			
			
			//CCAction *rippleAction=[CCRipple3D actionWithPosition:movingCharacter.position radius:100.0 waves:20 amplitude:160.0f grid:ccg(32,24) duration:3.0f];
			//[lillypads[finishPoint.x][finishPoint.y] runAction:rippleAction];
			
		}else{
			if(lastPlayedFile){
				CCLOG(@"Stopping sfx 2b");
				[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
			}	
			CCLOG(@"Not valid move");
			switch (movingCharacter.size) {
				case 1:
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrog0.png"]];
					if(!dontPlaySFX){
						lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"smallSplashLoud.caf"];
					}
					break;
				case 2:
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
					if(!dontPlaySFX){
						lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"bigSplashLoud.caf"];
					}
					break;
				case 3:
					[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFly0.png"]];
					break;
				default:
					break;
			}
			movingCharacter.position=lillypads[startPoint.x][startPoint.y].position;
			[lillypads[startPoint.x][startPoint.y] addCharacterToPad:movingCharacter];
			[self clearHighlights];
			movingCharacter=nil;
			
		}
	}
	
	if([self checkForWin]){
		[self displayWinner];
	}
	
}


-(void) playSoundJumpSoundEffect{
	if(lastPlayedFile){
		CCLOG(@"Stopping sfx 3");
		[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
	}
	
	switch (movingCharacter.size) {
		case 1:
			[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TreeFrog0.png"]];
			if(!dontPlaySFX){
				lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"smallSplashLoud.caf"];
			}
			break;
		case 2:
			[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
			if(!dontPlaySFX){
				lastPlayedFile=[[SimpleAudioEngine sharedEngine] playEffect:@"bigSplashLoud.caf"];
			}
			break;
		case 3:
			[movingCharacter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"DragonFly0.png"]];
			break;
		default:
			break;
	}
	if(lillypads[finishPoint.x][finishPoint.y].isGoal){
		[lillypads[finishPoint.x][finishPoint.y] stopAllActions];
		[lillypads[finishPoint.x][finishPoint.y] runAction:self.LilyPadFlowerAction];
	}else{
		[lillypads[finishPoint.x][finishPoint.y] stopAllActions];
		[lillypads[finishPoint.x][finishPoint.y] runAction:self.LilyPadAction];
	}
	[self clearHighlights];
	[lillypads[finishPoint.x][finishPoint.y] addCharacterToPad:movingCharacter];
	lillypads[finishPoint.x][finishPoint.y].characterOnPad.selected=NO;
	lillypads[startPoint.x][startPoint.y].characterOnPad=nil;
	if(movingCharacter) [self reorderChild:movingCharacter z:2];
	movingCharacter=nil;
	moveCount++;
	[currentLevelLabel setString:[NSString stringWithFormat:@"Level: %i-%i (%i moves)", self.levelGroup+1,currentLevel, moveCount]];

	if([self checkForWin]){
		[self displayWinner];
	}	
}
		



#pragma mark Game Controls
-(void) loadLevelFromGroup:(int) levelGroup  level:(int)levelNumber{
	[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:nil selector:nil];
	if(!dontPlayMusic){
		if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]){
			[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
			[bgMusic stop];
		}
		switch (levelNumber % 5) {
			case 0:
				[[CDAudioManager sharedManager] playBackgroundMusic:@"BlueGrass-60.caf" loop:NO];
				//[bgMusic load:@"BlueGrass-60.caf"];
				//[bgMusic play];
//				[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BlueGrass-60.caf" loop:NO];
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"forestSoundsShort.wav" loop:YES];
				break;
			case 1:
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"CatchThatChicken.caf" loop:NO];
				[[CDAudioManager sharedManager] playBackgroundMusic:@"CatchThatChicken.caf" loop:NO];
				//[bgMusic load:@"CatchThatChicken.caf"];
				//[bgMusic play];
				
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"forestSoundsShort.wav" loop:YES];
				break;
			case 2:
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"GatorSwampStomp.caf" loop:NO];
				[[CDAudioManager sharedManager] playBackgroundMusic:@"GatorSwampStomp.caf" loop:NO];
				//[bgMusic load:@"GatorSwampStomp.caf"];
				//[bgMusic play];
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"forestSoundsShort.wav" loop:YES];
				break;
			case 3:
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"HillbillyHoedown.caf" loop:NO];
				[[CDAudioManager sharedManager] playBackgroundMusic:@"HillbillyHoedown.caf" loop:NO];
				
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"forestSoundsShort.wav" loop:YES];
				break;
			case 4:
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MudCreek.caf" loop:NO];
				[[CDAudioManager sharedManager] playBackgroundMusic:@"MudCreek.caf" loop:NO];
				//[bgMusic load:@"MudCreek.caf"];
				//[bgMusic play];
				//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"forestSoundsShort.wav" loop:YES];
				break;
			default:
				break;
		}
	}
	if(!dontPlaySFX){
	//	[self schedule:@selector(playForestSounds:) interval:4.0];
	}
	
	//Show restart menu item
	[self getChildByTag:77].visible=YES;
	
	if([self getChildByTag:98]){
		[self removeChild:[self getChildByTag:98] cleanup:YES];
	}
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
//	[prefs integerForKey:@"currentGroup"];
	[prefs setInteger:self.levelGroup forKey:@"currentGroup"];
	[prefs setInteger:levelNumber forKey:@"currentLevel"];
	[prefs synchronize];
	currentLevel=levelNumber;

	CCLOG(@"LoadLevel: %i-%i", self.levelGroup, levelNumber);
	
	[currentLevelLabel setString:[NSString stringWithFormat:@"Level: %i-%i", self.levelGroup+1,currentLevel]];
	
	//Remove menu if present:
	if([self getChildByTag:3]){
		if([self getChildByTag:5]){
			[self removeChild:[self getChildByTag:5] cleanup:YES];
			[self removeChild:[self getChildByTag:6] cleanup:YES];
		}
		[self removeChild:[self getChildByTag:4] cleanup:YES];
		[self removeChild:[self getChildByTag:3] cleanup:YES];
		[self removeChild:[self getChildByTag:2] cleanup:YES];
		[self removeChild:[self getChildByTag:1] cleanup:YES];
	}
	if([self getChildByTag:5]){
		[self removeChild:[self getChildByTag:5] cleanup:YES];
		[self removeChild:[self getChildByTag:6] cleanup:YES];
	}
	
	//Remove any existing characters:
	for(int x=0; x<4;x++){
		for (int y=0; y<4; y++){
			if(lillypads[x][y].characterOnPad !=nil){
				[self removeChild:lillypads[x][y].characterOnPad cleanup:YES];
			}
			lillypads[x][y].isGoal=NO;
			[lillypads[x][y] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPad.png"]];
//			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//			{
//				lillypads[x][y].texture=[[CCTextureCache sharedTextureCache] addImage:@"lillyPad-ipad.png"];
//			}else{
//				lillypads[x][y].texture=[[CCTextureCache sharedTextureCache] addImage:@"lillyPad.png"];
//			}
			[lillypads[x][y] removeCharacter];
		}
	}
	
	
	//Set Background
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
	
		switch (levelGroup) {
			case 0:
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"KoiPond-ipad.png"];
				//liquidAction=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
				//backgroundAction=[background runAction:[CCRepeatForever actionWithAction:liquidAction]];
				break;
			case 1:
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"TurtlePond-ipad.png"];
				break;
			case 2:
				
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"BeaverPond-ipad.png"];
//				background =[CCSprite spriteWithFile:@"DuckPond-ipad.png"];
				break;
			case 3:
			
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"SnakePond-ipad.png"];
				//background =[CCSprite spriteWithFile:@"StonePond-ipad.png"];
				break;
			case 4:
				//[background stopAction:backgroundAction];
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"CattailPond-ipad.png"];
				//				background =[CCSprite spriteWithFile:@"StonePond.png"];
				break;
			default:
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"KoiPond-ipad.png"];
				//liquidAction=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
				//backgroundAction=[background runAction:[CCRepeatForever actionWithAction:liquidAction]];
//				background =[CCSprite spriteWithFile:@"background-ipad.png"];
				break;
		}
	}else {
		switch (levelGroup) {
			case 0:
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"KoiPond.png"];
				//liquidAction=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
				//backgroundAction=[background runAction:[CCRepeatForever actionWithAction:liquidAction]];
				//background =[CCSprite spriteWithFile:@"background.png"];
				break;
			case 1:
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"TurtlePond.png"];
				break;
			case 2:
				
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"BeaverPond.png"];
//				background =[CCSprite spriteWithFile:@"DuckPond.png"];
				break;
			case 3:
			
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"SnakePond.png"];
//				background =[CCSprite spriteWithFile:@"StonePond.png"];
				break;
			case 4:
				//[background stopAction:backgroundAction];
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"CattailPond-ipad.png"];
				//				background =[CCSprite spriteWithFile:@"StonePond.png"];
				break;
			default:
				background.texture=[[CCTextureCache sharedTextureCache] addImage:@"KoiPond.png"];
				//liquidAction=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
				//backgroundAction=[background runAction:[CCRepeatForever actionWithAction:liquidAction]];
//				background =[CCSprite spriteWithFile:@"background.png"];
				break;
		}	
	}
	
	
	NSString *levelPath=[[NSBundle mainBundle] resourcePath];
	TBXML *xmlData=[[TBXML alloc] initWithXMLFile:[levelPath stringByAppendingFormat:@"/PondHopperLevels-%i.xml", levelGroup]];
	if (xmlData.rootXMLElement){
		CCLOG(@"Found root element: %@", [TBXML textForElement:xmlData.rootXMLElement]);
		TBXMLElement *xmlLevelElement=[TBXML childElementNamed:@"level" parentElement:xmlData.rootXMLElement];
		int ElementLevelCount;
		ElementLevelCount=1;
		while(xmlLevelElement){
			//[self traverseElement:xmlLevelElement];
			CCLOG(@"Looking for %i, found %@", levelNumber, [TBXML valueOfAttributeNamed:@"levelNumber" forElement:xmlLevelElement]);
			NSString *xmlLevelNumber=[TBXML valueOfAttributeNamed:@"levelNumber" forElement:xmlLevelElement];
			if ([xmlLevelNumber isEqualToString:@"x"]) {
				xmlLevelNumber=[[NSNumber numberWithInt:ElementLevelCount] stringValue];
			}
			
			if (levelNumber == [xmlLevelNumber integerValue]){
				CCLOG(@"Found level to create");
				minimumMovesToWin=[[TBXML valueOfAttributeNamed:@"minimumMovesToWin" forElement:xmlLevelElement] integerValue];
				//Load Goal;
				TBXMLElement *goalElement=[TBXML childElementNamed:@"goal" parentElement:xmlLevelElement];
				int goalX=[[TBXML valueOfAttributeNamed:@"col" forElement:goalElement] integerValue];
				int goalY=[[TBXML valueOfAttributeNamed:@"row" forElement:goalElement] integerValue];
				lillypads[goalX][goalY].isGoal=YES;
				[lillypads[goalX][goalY] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LilyPadFlower.png"]];
				//if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				//{
				//	lillypads[goalX][goalY].texture=[[CCTextureCache sharedTextureCache] addImage:@"lotus-ipad.png"];
				//}else{
				//	lillypads[goalX][goalY].texture=[[CCTextureCache sharedTextureCache] addImage:@"lotus.png"];
				//}
				CCLOG(@"Goal: %i x %i", goalX, goalY);
				
				
				//Load Characters
				TBXMLElement *characterElement =[TBXML childElementNamed:@"character" parentElement:xmlLevelElement];
				while(characterElement){
					//[self traverseElement:characterElement];
					int newCharType=[[TBXML valueOfAttributeNamed:@"type" forElement:characterElement] integerValue];
					if(newCharType>0){
						Character *newCharacter=[Character characterWithType:newCharType];
						int locationX=[[TBXML valueOfAttributeNamed:@"col" forElement:characterElement] integerValue];
						int locationY=[[TBXML valueOfAttributeNamed:@"row" forElement:characterElement] integerValue];
						CCLOG(@"Creating Character of type %i in location: %i x %i", newCharType, locationX, locationY);
						[lillypads[locationX][locationY] addCharacterToPad:newCharacter];
						
						
						
						[self addChild:newCharacter z:2];
					}
					characterElement=characterElement->nextSibling;
				}
				
				[currentLevelLabel setString:[NSString stringWithFormat:@"Level: %i-%i", self.levelGroup+1,currentLevel]];
				
				if(minimumMovesToWin>1){
					[currentMovesString setString:[NSString stringWithFormat:@"Can you solve in %i moves?", minimumMovesToWin]];
				}else{
					[currentMovesString setString:[NSString stringWithFormat:@"Can you solve in %i move?", minimumMovesToWin]];
				}
				 
												   
				
				if(self.levelGroup==0){
					//CCLabelTTF *instructionsLabel;
					int scoreLabelFontSize=0;
					if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
					{
						scoreLabelFontSize=48;
					}else{
						scoreLabelFontSize=24;
					}
					
					CCLabelBMFont *instructionsLabel;
					CCSprite *instructionsBackdrop;
					switch (levelNumber) {
						case 1:
							//instructionsLabel=[CCLabelBMFont labelWithString:@"Jump characters to get Sonny, the large green frog, to the red lotus flower"   fntFile:[NSString stringWithFormat:@"CHUBBY-%i.fnt", scoreLabelFontSize]];
							if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
							{
								instructionsBackdrop=[CCSprite spriteWithFile:@"instructionsUnderlay-hd.png"];
								instructionsLabel=[CCLabelTTF labelWithString:@"Jump characters to get Sonny, the large green frog, to the lotus flower" dimensions:CGSizeMake(400, 400) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
								
							}else{
								instructionsBackdrop=[CCSprite spriteWithFile:@"instructionsUnderlay.png"];
								instructionsLabel=[CCLabelTTF labelWithString:@"Jump characters to get Sonny, the large green frog, to the lotus flower" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
								
							}
							//instructionsBackdrop=[CCColorLayer layerWithColor: ccc4(0x00, 0x00, 0x00, 0x7C)];
							//[instructionsBackdrop changeWidth:200 height:200];
							//instructionsLabel=[CCLabelTTF labelWithString:@"test" fontName:@"lockergnome" fontSize:20];
							instructionsLabel.position=ccp(windowSize.width/2, (.3*windowSize.height));
							instructionsBackdrop.isRelativeAnchorPoint=YES;
							instructionsBackdrop.position=instructionsLabel.position;
							//CCLOG(@"Anchor Point: %@", instructionsBackdrop.anchorPoint);
							instructionsLabel.color=ccYELLOW;
							[self addChild:instructionsBackdrop z:3 tag:5];
							[self addChild:instructionsLabel z:4 tag:6];
							
							break;
						case 2:
							//instructionsLabel=[CCLabelBMFont labelWithString:@"Jump one or two characters at a time" fntFile:[NSString stringWithFormat:@"CHUBBY-%i.fnt", scoreLabelFontSize]];
							//instructionsLabel.dimensions=CGSizeMake(200, 200);
							if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
							{
								instructionsLabel=[CCLabelTTF labelWithString:@"Jump over one or two characters at a time" dimensions:CGSizeMake(400, 400) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
								
								instructionsBackdrop=[CCSprite spriteWithFile:@"instructionsUnderlay-hd.png"];
							}else{
								instructionsLabel=[CCLabelTTF labelWithString:@"Jump over one or two characters at a time" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
								
								instructionsBackdrop=[CCSprite spriteWithFile:@"instructionsUnderlay.png"];
							}
							//instructionsBackdrop=[CCColorLayer layerWithColor: ccc4(0x00, 0x00, 0x00, 0x7C)];
							//[instructionsBackdrop changeWidth:200 height:200];
							//instructionsLabel=[CCLabelTTF labelWithString:@"test" fontName:@"lockergnome" fontSize:20];
							instructionsLabel.position=ccp(windowSize.width *.6, (.3*windowSize.height));
							instructionsBackdrop.isRelativeAnchorPoint=YES;
							instructionsBackdrop.position=instructionsLabel.position;
							//CCLOG(@"Anchor Point: %@", instructionsBackdrop.anchorPoint);
							instructionsLabel.color=ccYELLOW;
							[self addChild:instructionsBackdrop z:3 tag:5];
							[self addChild:instructionsLabel z:4 tag:6];
							
							break;
						case 3:
							//instructionsLabel=[CCLabelBMFont labelWithString:@"Every character can move on the board.  Jump the left small frog toward Sonny, the large frog" fntFile:[NSString stringWithFormat:@"CHUBBY-%i.fnt", scoreLabelFontSize]];
							if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
							{
								instructionsLabel=[CCLabelTTF labelWithString:@"Every character can move on the board.  Jump the small frog on the left toward Sonny, the large frog" dimensions:CGSizeMake(400, 400) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
								
								instructionsBackdrop=[CCSprite spriteWithFile:@"instructionsUnderlay-hd.png"];
							}else{
								instructionsLabel=[CCLabelTTF labelWithString:@"Every character can move on the board.  Jump small frog on the left toward Sonny, the large frog" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
								
								instructionsBackdrop=[CCSprite spriteWithFile:@"instructionsUnderlay.png"];
							}
							//instructionsBackdrop=[CCColorLayer layerWithColor: ccc4(0x00, 0x00, 0x00, 0x7C)];
							//[instructionsBackdrop changeWidth:200 height:200];
							//instructionsLabel=[CCLabelTTF labelWithString:@"test" fontName:@"lockergnome" fontSize:20];
							instructionsLabel.position=ccp(windowSize.width/2, (.3*windowSize.height));
							instructionsBackdrop.isRelativeAnchorPoint=YES;
							instructionsBackdrop.position=instructionsLabel.position;
							//CCLOG(@"Anchor Point: %@", instructionsBackdrop.anchorPoint);
							instructionsLabel.color=ccYELLOW;
							[self addChild:instructionsBackdrop z:3 tag:5];
							[self addChild:instructionsLabel z:4 tag:6];
							
							break;
						case 4:
							//instructionsLabel=[CCLabelBMFont labelWithString:@"Sonny and dragon flys are too big to sit next to each other.  Move the dragon fly to setup your move." fntFile:[NSString stringWithFormat:@"CHUBBY-%i.fnt", scoreLabelFontSize]];
							if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
							{
								instructionsLabel=[CCLabelTTF labelWithString:@"Sonny and dragon flys are too big to sit next to each other.  Move the dragon fly to setup your move." dimensions:CGSizeMake(390, 400) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
								
								instructionsBackdrop=[CCSprite spriteWithFile:@"instructionsUnderlay-hd.png"];
							}else{
								instructionsLabel=[CCLabelTTF labelWithString:@"Sonny and dragon flys are too big to sit next to each other.  Move the dragon fly to setup your move." dimensions:CGSizeMake(195, 200) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
								
								instructionsBackdrop=[CCSprite spriteWithFile:@"instructionsUnderlay.png"];
							}
							//instructionsBackdrop=[CCColorLayer layerWithColor: ccc4(0x00, 0x00, 0x00, 0x7C)];
							//[instructionsBackdrop changeWidth:200 height:200];
							//instructionsLabel=[CCLabelTTF labelWithString:@"test" fontName:@"lockergnome" fontSize:20];
							instructionsLabel.position=ccp(windowSize.width *.6, (.25*windowSize.height));
							instructionsBackdrop.isRelativeAnchorPoint=YES;
							instructionsBackdrop.position=instructionsLabel.position;
							//CCLOG(@"Anchor Point: %@", instructionsBackdrop.anchorPoint);
							instructionsLabel.color=ccYELLOW;
							[self addChild:instructionsBackdrop z:3 tag:5];
							[self addChild:instructionsLabel z:4 tag:6];
							
							break;	
						
						default:
							break;
					}
				}
				
				
				return;
			}
			xmlLevelElement=xmlLevelElement->nextSibling;
			ElementLevelCount++;
		}
	}
	
	if(self.levelGroup==6){
		CCLOG(@"Show no more levels");
		[self showNoMoreLevels];
	}else{
		self.levelGroup++;
		[self loadLevelFromGroup:self.levelGroup level:1];
		
	}
	
	
	
	
}
															 
- (void) traverseElement:(TBXMLElement *)element {
	
	do {
		// Display the name of the element
		CCLOG(@"%@",[TBXML elementName:element]);
		
		// Obtain first attribute from element
		TBXMLAttribute * attribute = element->firstAttribute;
		
		// if attribute is valid
		while (attribute) {
			// Display name and value of attribute to the log window
			CCLOG(@"%@->%@ = %@",
				  [TBXML elementName:element],
				  [TBXML attributeName:attribute],
				  [TBXML attributeValue:attribute]);
			
			// Obtain the next attribute
			attribute = attribute->next;
		}
		
		// if the element has child elements, process them
		if (element->firstChild) 
            [self traverseElement:element->firstChild];
		
		// Obtain next sibling element
	} while ((element = element->nextSibling));  
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
	
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil)
		{
            
        }
    }];
}

-(void)restartLevel{
    if(lastPlayedFile){
		CCLOG(@"Stopping sfx 3");
		[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
	}
	if([self getChildByTag:85]){
		[self removeChild:[self getChildByTag:87] cleanup:YES];
		[self removeChild:[self getChildByTag:85] cleanup:YES];
	}
	moveCount=0;
	restartCount++;
	[self loadLevelFromGroup:self.levelGroup  level:currentLevel];
}

-(void)nextLevel{
    if(lastPlayedFile){
		CCLOG(@"Stopping sfx 3");
		[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
	}
	moveCount=0;
	restartCount=0;
	[self loadLevelFromGroup:self.levelGroup  level:currentLevel];
}

-(void)goBackLevel{
    if(lastPlayedFile){
		CCLOG(@"Stopping sfx 3");
		[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
	}
	moveCount=0;
	restartCount=0;
		[self loadLevelFromGroup:self.levelGroup  level:--currentLevel];
}

-(void) displayWinner{
	if(lastPlayedFile){
		CCLOG(@"Stopping sfx 3");
		[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
	}
	
		if(![self getChildByTag:4].visible){
			
	
			//Hide restart menu icon
			[self getChildByTag:77].visible=NO;
			
			if([self getChildByTag:5]){
				[self removeChild:[self getChildByTag:5] cleanup:YES];
				[self removeChild:[self getChildByTag:6] cleanup:YES];
			}

			int playersScore=1000;
			if((moveCount-minimumMovesToWin)>=0){
			   playersScore=playersScore-((moveCount-minimumMovesToWin) * 50);
			}else{
				playersScore=0;
			}
			/*int bonus=1000;
			
			if(restartCount>0){
				bonus=bonus-(restartCount*100);
				if(bonus<1){
					bonus=0;
				}
			}
			*/
			
		//	playersScore=playersScore+bonus;
			if(playersScore<1){
				playersScore=0;
			}
			CCLOG(@"Player's score: %i", playersScore);
			
			NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
			int levelScore=[prefs integerForKey:[NSString stringWithFormat:@"%i-%i",self.levelGroup,currentLevel]];
			if(playersScore>levelScore){
				[prefs setInteger:playersScore forKey:[NSString stringWithFormat:@"%i-%i",self.levelGroup,currentLevel]];
				[prefs synchronize];
			}
            
            CCLOG(@"Level Finished: %i-%i", self.levelGroup, currentLevel);
            
            
            
            if(self.levelGroup==0 && currentLevel==4){
                [FlurryAPI logEvent:@"COMPLETED_TRAINING"];
            }
            
            if(self.levelGroup==0 && currentLevel==25){
//                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"COMPLETED_POND_0"];
                                [FlurryAPI logEvent:@"COMPLETED_POND_0"];
            }
			
            if(self.levelGroup==1 && currentLevel==25){
//                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"COMPLETED_POND_1"];
                                [FlurryAPI logEvent:@"COMPLETED_POND_1"];
            }
            
			if(self.levelGroup==2 && currentLevel==25){
//                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"COMPLETED_POND_2"];
                                [FlurryAPI logEvent:@"COMPLETED_POND_2"];
            }
            
            if(self.levelGroup==3 && currentLevel==25){
//                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"COMPLETED_POND_3"];
                                [FlurryAPI logEvent:@"COMPLETED_POND_3"];
            }
            
            if(self.levelGroup==4 && currentLevel==25){
//                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"COMPLETED_POND_4"];
                                [FlurryAPI logEvent:@"COMPLETED_POND_4"];
            }
            
            
            switch (currentLevel) {
                case 5:
                    CCLOG(@"Test");
                    NSString *levelFiveComplete = [NSString stringWithFormat:@"COMPLETED_POND_%i_LEVEL_5", self.levelGroup];
//                    [[LocalyticsSession sharedLocalyticsSession] tagEvent:levelFiveComplete];
                    [FlurryAPI logEvent:levelFiveComplete];
                    break;
                case 10:
                    CCLOG(@"Test");
                    NSString *levelTenComplete = [NSString stringWithFormat:@"COMPLETED_POND_%i_LEVEL_10", self.levelGroup];
//                    [[LocalyticsSession sharedLocalyticsSession] tagEvent:levelTenComplete];
                     [FlurryAPI logEvent:levelTenComplete];
                    break;    
                case 15:
                    CCLOG(@"Test");
                    NSString *levelFifteenComplete = [NSString stringWithFormat:@"COMPLETED_POND_%i_LEVEL_15", self.levelGroup];
//                    [[LocalyticsSession sharedLocalyticsSession] tagEvent:levelFifteenComplete];
                     [FlurryAPI logEvent:levelFifteenComplete];
                    break;    
                case 20:
                    CCLOG(@"Test");
                    NSString *levelTwentyComplete = [NSString stringWithFormat:@"COMPLETED_POND_%i_LEVEL_20", self.levelGroup];
//                    [[LocalyticsSession sharedLocalyticsSession] tagEvent:levelTwentyComplete];
                     [FlurryAPI logEvent:levelTwentyComplete];
                    break;    
                case 25:
                    CCLOG(@"Test");
                    NSString *levelTwentyFiveComplete = [NSString stringWithFormat:@"COMPLETED_POND_%i_LEVEL_25", self.levelGroup];
//                    [[LocalyticsSession sharedLocalyticsSession] tagEvent:levelTwentyFiveComplete];
                     [FlurryAPI logEvent:levelTwentyFiveComplete];
                    break;  
                default:
                    break;
            }
			
			CCLayerColor *backdrop=[CCColorLayer layerWithColor: ccc4(0x00, 0x00, 0x00, 0x7C)];
			[self addChild:backdrop z:5 tag:1];
			
			/*
			CCParticleSystemQuad *explosionParticle = [CCParticleSystemQuad particleWithFile:@"winnerExplosion.plist"];
			explosionParticle.autoRemoveOnFinish=YES;
			explosionParticle.position =ccp(windowSize.width/2,windowSize.height/2);
			
			
			[self addChild:explosionParticle z:6 tag:2];
			*/
			
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			{
				[CCMenuItemFont setFontSize:48];
			}else{
				[CCMenuItemFont setFontSize:30];
			}
			
			
			CCMenuItem *nextLevel=[CCMenuItemFont itemFromString:@"Next Level" target:self selector:@selector(nextLevel)];
			CCMenuItem *restartLevel=[CCMenuItemFont itemFromString:@"Restart Level" target:self selector:@selector(goBackLevel) ];
			CCMenuItem *mainMenuButton=[CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(showMainMenu) ];
			CCMenu *menu;
				CCMenuItem *shareScoreButton=[CCMenuItemFont itemFromString:@"Share Pond Score..." target:self selector:@selector(shareLevelScore) ];
				menu=[CCMenu menuWithItems:nextLevel,restartLevel,shareScoreButton,mainMenuButton,nil];
			//menu.position=ccp(windowSize.width/2, windowSize.height-.25*windowSize.height);
			[menu setColor:ccYELLOW];
			[menu alignItemsVertically];
			menu.position=ccp(windowSize.width/2,(.33*windowSize.height));
			[self addChild:menu z:7 tag:3];
			
		//	int finalScore=0;
			
			int pondScore=[self getLevelScore];
			int finalScore=[self getFinalScore];
			
			CCLabelBMFont *scoreLabel;
			int scoreLabelFontSize=0;
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			{
				scoreLabelFontSize=48;
			}else{
				scoreLabelFontSize=24;
			}
			if(playersScore==1000){
		//		[NSString stringWithFormat:@"PERFECT LEVEL!!\nLevel Score: %i\nTotal Score: %i", playersScore, finalScore]
				//scoreLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"PERFECT LEVEL!!\n  Level Score: %i\n  Total Score: %i", playersScore, finalScore]
				//								  fntFile:[NSString stringWithFormat:@"CHUBBY-%i.fnt", scoreLabelFontSize]];
				scoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"PERFECT LEVEL!!\nLevel Score: %i\nPond Score: %i\nTotal Score: %i", playersScore, pondScore, finalScore] 
												dimensions:CGSizeMake(windowSize.width, (.25*windowSize.height)) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
				
				[prefs setInteger:playersScore forKey:[NSString stringWithFormat:@"%i-%i",self.levelGroup,currentLevel]];
				[prefs synchronize];
			}else{
				if(playersScore>levelScore){
					
					//scoreLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"IMPROVED SCORE!!\n  Level Score: %i\n  Total Score: %i", playersScore, finalScore]
					//								  fntFile:[NSString stringWithFormat:@"CHUBBY-%i.fnt", scoreLabelFontSize]];
					scoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"IMPROVED SCORE!!\nLevel Score: %i\nPond Score: %i\nTotal Score: %i", playersScore, pondScore, finalScore] 
												dimensions:CGSizeMake(windowSize.width, (.25*windowSize.height)) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
					[prefs setInteger:playersScore forKey:[NSString stringWithFormat:@"%i-%i",self.levelGroup,currentLevel]];
					[prefs synchronize];
				}else{
					//scoreLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Level Score: %i\nTotal Score: %i", playersScore, finalScore]
					//								  fntFile:[NSString stringWithFormat:@"CHUBBY-%i.fnt", scoreLabelFontSize]];

					scoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level Score: %i\nPond Score: %i\nTotal Score: %i", playersScore, pondScore, finalScore] 
													  dimensions:CGSizeMake(windowSize.width, (.25*windowSize.height)) alignment:UITextAlignmentCenter fontName:@"CHUBBY" fontSize:scoreLabelFontSize];
				}
				
			}
			scoreLabel.anchorPoint = ccp(0.5f, 0.5f);
			scoreLabel.position=ccp(windowSize.width/2,windowSize.height-(.33*windowSize.height));
			
			currentLevel++;
			//	[NSString stringWithFormat:@"%i-%@",levelToLoad,xmlLevelNumber]
			[prefs setInteger:currentLevel forKey:@"currentLevel"];
			[prefs setInteger:self.levelGroup forKey:@"currentGroup"];
			[prefs synchronize];
			
			[self addChild:scoreLabel z:7 tag:4];
			if([self isGameCenterAvailable ]){
				[self performSelectorInBackground:@selector(reportFinalScore:) withObject:[NSNumber numberWithInt:finalScore]];
			}
		}
}

-(int) getLevelScore{
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	int finalScore=0;
		int x=1;
		
		//	[NSString stringWithFormat:@"%i-%@",self.levelGroup,currentLevel]
		while (x<26) {
			//CCLOG(@"Getting score for level %i-%i",self.levelGroup,x);
			finalScore+=[prefs integerForKey:[NSString stringWithFormat:@"%i-%i",self.levelGroup,x]];
			x++;
		}
	return finalScore;
	
}



-(void) shareLevelScore{
	int levelFinalScore=[self getLevelScore];
    [FlurryAPI logEvent:@"SHARING_SCORE"];
	SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"I scored %i in the %@ on Pond Hopper http://mcaf.ee/fdb1c", levelFinalScore, [self getLevelGroupName:self.levelGroup]]];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showInView:[CCDirector sharedDirector].openGLView ];
}


-(NSString *)getLevelGroupName:(int)levelGroupNumber{
	switch (levelGroupNumber) {
		case 0:
			return @"Koi Pond";
			break;
		case 1:
			return @"Cat Tail Pond";
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


-(void)showMainMenu{
    if(lastPlayedFile){
		CCLOG(@"Stopping sfx 3");
		[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
	}
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[self stopAllActions];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuController scene]]];	
}

-(void) reportFinalScore:(NSNumber *) finalScore{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CCLOG(@"Final Score: %i", [finalScore integerValue]);
	if([self isGameCenterAvailable ]){
		[self reportScore:[finalScore integerValue] forCategory:@"com.shawnsbits.PondHopper.highScore"];
	}		
	[pool drain];
}

-(int) getFinalScore{
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	int finalScore=0;
	for (int levelGroupNumber=0; levelGroupNumber<5; levelGroupNumber++) {
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


-(BOOL) isValidMoveFromStart:(PadLocation) startLocation toFinish:(PadLocation) finishLocation forCharacter:(Character *)placingCharacter{
	int checkX=0;
	int checkY=0;
	
	//Is there already a character on that pad?
	if(lillypads[finishLocation.x][finishLocation.y].characterOnPad!=nil){
		CCLOG(@"Character already on finish Pad");
		return NO;
	}
	
	//Did move horizontal or vertical, not diagonal
	if(!((startLocation.x == finishLocation.x) || (startLocation.y==finishLocation.y))){
				CCLOG(@"Moved diagonal");
		return NO;
	}
	
	//Check for DragonFly;
	if(placingCharacter.size>1){
		if (finishLocation.x<3){
			checkX=finishLocation.x+1;
			if(lillypads[checkX][finishLocation.y].characterOnPad !=nil){
				if(lillypads[checkX][finishLocation.y].characterOnPad.size>1){
							CCLOG(@"Dragon fly in x+1");
					return NO;
				}
			}
		}
		if (finishLocation.x>0){
			checkX=finishLocation.x-1;
			if(lillypads[checkX][finishLocation.y].characterOnPad !=nil){
				if(lillypads[checkX][finishLocation.y].characterOnPad.size>1){
					CCLOG(@"Dragon fly in x-1");
					return NO;
				}
			}
		}
		if (finishLocation.y>0){
			checkY=finishLocation.y-1;
			if(lillypads[finishLocation.x][checkY].characterOnPad !=nil){
				if(lillypads[finishLocation.x][checkY].characterOnPad.size>1){
					CCLOG(@"Dragon fly in y-1");
					return NO;
				}
			}
		}
		if (finishLocation.y<3){
			checkY=finishLocation.y+1;
			if(lillypads[finishLocation.x][checkY].characterOnPad !=nil){
				if(lillypads[finishLocation.x][checkY].characterOnPad.size>1){
					CCLOG(@"Dragon fly in y+1");
					return NO;
				}
			}
		}
	}
	
	//Check did jump no more than two characters
	//if x=x then moved vertically
	if(startLocation.x == finishLocation.x){
			//first, diff between the two y's should be no larger than 2
		if(finishLocation.y>startLocation.y){
			if((finishLocation.y-startLocation.y) > 3){
				CCLOG(@"moved more than 2 stops");
				return NO;
			}
			if((finishLocation.y-startLocation.y) == 1){
				CCLOG(@"did not hop, moved 1 space");
				return NO;
			}
			//Now verify there was a character on those spaces
			checkY=finishLocation.y-1;
			while(checkY>startLocation.y){
				if(lillypads[finishLocation.x][checkY].characterOnPad==nil){
					CCLOG(@"Nil character found in jump");
					return NO;
				}
				checkY--;
			}
		}else{
			if((startLocation.y-finishLocation.y) > 3){
				CCLOG(@"moved more than 2 stops");
				return NO;
			}
			if((startLocation.y-finishLocation.y) ==1 ){
				CCLOG(@"Did not hop, moved 1 space");
				return NO;
			}
			//Now verify there was a character on those spaces
			checkY=startLocation.y-1;
			while(checkY>finishLocation.y){
				if(lillypads[finishLocation.x][checkY].characterOnPad==nil){
					CCLOG(@"Nil character found in jump");
					return NO;
				}
				checkY--;
			}
		}
		
		
		
	}else {
		//Moved horizontally
		if(finishLocation.x>startLocation.x){
			if((finishLocation.x-startLocation.x) > 3){
				CCLOG(@"Moved more than two spots");
				return NO;
			}
			if((finishLocation.x-startLocation.x) ==1 ){
				CCLOG(@"Did not hop, moved 1 space");
				return NO;
			}
			//Now verify there was a character on those spaces
			checkX=finishLocation.x-1;
			while(checkX>startLocation.x){
				if(lillypads[checkX][finishLocation.y].characterOnPad==nil){
										CCLOG(@"Nil character found in jump");
					return NO;
				}
				checkX--;
			}
		}else{
			if((startLocation.x-finishLocation.x) > 3){
				CCLOG(@"Moved more than two spots");
				return NO;
			}
			if((startLocation.x-finishLocation.x) ==1 ){
				CCLOG(@"Did not hop, moved 1 space");
				return NO;
			}
			//Now verify there was a character on those spaces
			checkX=startLocation.x-1;
			while(checkX>finishLocation.x){
				if(lillypads[checkX][finishLocation.y].characterOnPad==nil){
										CCLOG(@"Nil character found in jump");
					return NO;
				}
				checkX--;
			}
		}
	}

	
	
	
	return YES;
}

-(BOOL) checkForWin{
	for (int x=0; x<4; x++) {
		for (int y=0; y<4; y++) {
			if(lillypads[x][y].isGoal){
				if(lillypads[x][y].characterOnPad.size==2){
					return YES;
				}else{
					return NO;
				}
			}
		}
	}
	return NO;
	
}

-(BOOL) isGameCenterAvailable
{
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
    return (gcClass && osVersionSupported);
}

#pragma mark inGameMenu
-(void)showGameMenu{
	//		CCColorLayer *background=[CCColorLayer layerWithColor: ccc4(0x00, 0x00, 0x00, 0xaa)];
	if(lastPlayedFile){
		CCLOG(@"Stopping sfx 3");
		[[SimpleAudioEngine sharedEngine] stopEffect:lastPlayedFile];
	}
	CCLayerColor *backdrop=[CCLayerColor layerWithColor: ccc4(0x00, 0x00, 0x00, 0xFF)];
	[self addChild:backdrop z:7 tag:85];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[CCMenuItemFont setFontSize:48];
	}else{
		[CCMenuItemFont setFontSize:30];
	}
	
	CCMenuItem *restartLevelMenuItem=[CCMenuItemFont itemFromString:@"Restart Level" target:self selector:@selector(restartLevel)];
	CCMenuItem *selectLevelMenuItem=[CCMenuItemFont itemFromString:@"Select Level" target:self selector:@selector(showSelectLevel)];
	//CCMenuItem *restartAllLevelsMenuItem=[CCMenuItemFont itemFromString:@"Restart All Levels" target:self selector:@selector(restartAllLevels)];
	CCMenuItem *mainMenuButton=[CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(showMainMenu) ];
	CCMenuItem *returnToGameMI=[CCMenuItemFont itemFromString:@"Return To Game" target:self selector:@selector(hideGameMenu)];
	CCMenu *inGameMenu=[CCMenu menuWithItems:restartLevelMenuItem,selectLevelMenuItem,mainMenuButton,returnToGameMI,nil];
	inGameMenu.position=ccp(windowSize.width/2, windowSize.height-(.1*windowSize.height));
	[inGameMenu setColor:ccYELLOW];
	[inGameMenu alignItemsVertically];
	
	CCLOG(@"window height: %f", windowSize.height);
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 3.2 or later.
		inGameMenu.position=ccp(windowSize.width/2,(windowSize.height/2)+150);
		
	}
	else
	{
		inGameMenu.position=ccp(windowSize.width/2,(windowSize.height/2)+25);
	}
	[self addChild:inGameMenu z:8 tag:87];
}

-(void)hideGameMenu{
	[self removeChild:[self getChildByTag:87] cleanup:YES];
	[self removeChild:[self getChildByTag:85] cleanup:YES];
	
}

-(void) showSelectLevel{
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[LevelSelectMenu scene]]];	
	
}

-(void)showNoMoreLevels{
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[self stopAllActions];
	CCLOG(@"Loading nomorelevels scene");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[NoMoreLevelsScene scene]]];	
}



- (void)onExit
{
	
	CCLOG(@"Exiting");
	
	[self unschedule:@selector(BlinkSelector:)];
	[self unschedule:@selector(FrogFlyEatSelector:)];
	[self stopAllActions];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:nil selector:nil];

	[super onExit];
}




#pragma mark dealloc
// on "dealloc" you need to release all your retained objects
/*
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	CCLOG(@"Dallocing");
	[self unschedule:@selector(BlinkSelector:)];
	[self unschedule:@selector(FrogFlyEatSelector:)];
//	[backgroundAction release], backgroundAction=nil;
		[self stopAllActions];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}
 */

@end
