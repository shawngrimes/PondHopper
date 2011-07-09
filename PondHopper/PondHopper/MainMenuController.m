//
//  MainMenuController.m
//  PondHopper
//
//  Created by shawn on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuController.h"
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

CGSize windowSize;

UIViewController *viewController;

//static const ccColor3B ccGreen={57, 181, 74};
static const ccColor3B ccBlack={0, 0, 0};
@implementation MainMenuController

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuController *layer = [MainMenuController node];
	
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
		NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
        int playMusic=[((NSNumber*)[prefs valueForKey:@"MUSIC"]) integerValue];
        
        if((![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) && !(playMusic)){
            [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"banjoTune.caf"];
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"banjoTune.caf" loop:NO];
        }

        if([self isGameCenterAvailable]){
			[self authenticateLocalPlayer];
		}
        
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
			background =[CCSprite spriteWithFile:@"menu-ipad.png"];
		}
		else
		{
			CCLOG(@"Loading iPhone background");
			background =[CCSprite spriteWithFile:@"menu.png"];
		}
		background.position=ccp(windowSize.width/2,windowSize.height/2);
		[self addChild:background z:0];
		
		//id liquid=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
		//[background runAction:[CCRepeatForever actionWithAction:liquid]];
		
		
		
		[CCMenuItemFont setFontName:@"CHUBBY"];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[CCMenuItemFont setFontSize:48];
		}else{
			[CCMenuItemFont setFontSize:24];
		}
		
        //CCBitmapFontAtlas *label = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Hello World" fntFile:@"bitmapFontTest.fnt"];
		//CCLabelBMFont *startLabel=[CCLabelBMFont labelWithString:@"START" fntFile:@"CHUBBY.fnt"];
		//[self addChild:startLabel];
		//CCMenuItem *startMenuItem=[CCMenuItemLabel itemWithLabel:startLabel target:self selector:@selector(startGame)];
		
		CCMenuItem *startMenuItem=[CCMenuItemFont itemFromString:@"START" target:self selector:@selector(startGame)];
		CCMenuItem *levelsMenuItem=[CCMenuItemFont itemFromString:@"LEVELS" target:self selector:@selector(showLevels)];
		CCMenuItem *instructionsMenuItem=[CCMenuItemFont itemFromString:@"INSTRUCTIONS" target:self selector:@selector(showInstructions)];
		CCMenuItem *scoresMenu=[CCMenuItemFont itemFromString:@"SCORES" target:self selector:@selector(showScores)];
		CCMenuItem *settingsMenu=[CCMenuItemFont itemFromString:@"SETTINGS" target:self selector:@selector(showSettings)];
		//CCMenuItem *creditsMenuItem=[CCMenuItemFont itemFromString:@"Credits" target:self selector:@selector(showCredits)];
		CCMenu *inGameMenu;
		
		if([self isGameCenterAvailable]){
			inGameMenu = [CCMenu menuWithItems:startMenuItem,instructionsMenuItem,levelsMenuItem,scoresMenu,settingsMenu,nil];
			//inGameMenu = [CCMenu menuWithItems:startMenuItem,instructionsMenuItem,scoresMenu,nil];
		}else{
			inGameMenu = [CCMenu menuWithItems:startMenuItem,instructionsMenuItem,levelsMenuItem,settingsMenu,nil];
			//inGameMenu = [CCMenu menuWithItems:startMenuItem,instructionsMenuItem,nil];
		}
		inGameMenu.position=ccp(windowSize.width/2, windowSize.height/2);
		[inGameMenu setColor:ccYELLOW];
		[inGameMenu alignItemsVertically];
		[self addChild:inGameMenu z:1];
		
	}
	
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	CCLabelTTF *versionLabel;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		versionLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"v%@", version] fontName:@"CHUBBY" fontSize:44];
	}else{
		versionLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"v%@", version] fontName:@"CHUBBY" fontSize:22];
	}
	versionLabel.position=ccp(windowSize.width/2, windowSize.height/3.5);
	[self addChild:versionLabel z:1];
	
	
	
		return self;
}

-(void) startGame{
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	int currentGroup=[prefs integerForKey:@"currentGroup"];
	int currentLevel=[prefs integerForKey:@"currentLevel"];
	
	if(currentGroup==0){
		currentGroup=0;
	}
	if(currentLevel==0){
		currentLevel=1;
	}
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameController sceneLevelGroup:currentGroup levelNumber:currentLevel]]];
	
}

-(void)showSettings{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[SettingsMenuController scene]]];	
}

-(void) showLevels{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[LevelSelectMenu scene]]];	
}

-(void) showInstructions{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[InstructionsController scene]]];
	
}

-(void) showCredits{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[CreditsController scene]]];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}


#import <GameKit/GameKit.h>
#pragma mark GameCenter
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

- (void) authenticateLocalPlayer
{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil)
		{
			CCLOG(@"Successful authentication on GameCenter");
			//[self ActivatePendingGameCheck];
			// Insert code here to handle a successful authentication.
		}
		else
		{
			CCLOG(@"Failed: authentication on GameCenter");
			CCLOG(@"Error: %@", [error localizedDescription]);
			// Your application can process the error parameter to report the error to the player.
		}
	}];
}

-(void) showScores{
	[self leaderboardShow];
}

-(void) leaderboardShow{
		if ([GKLocalPlayer localPlayer].authenticated){
		[self showLeaderboard];
	}
}

- (void) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
    if (leaderboardController != nil)
    {
		if(viewController==nil){
			viewController=[[UIViewController alloc] init];
		}
		[[[CCDirector sharedDirector] openGLView] addSubview:viewController.view];

        leaderboardController.leaderboardDelegate = self;
//		[[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
		[viewController presentModalViewController:leaderboardController animated: YES];
		
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissModalViewControllerAnimated:YES];
    viewController.leaderboardDelegate=nil;
	[viewController.view removeFromSuperview];
}




@end
