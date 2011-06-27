//
//  SettingsMenuController.m
//  PondHopper
//
//  Created by shawn on 10/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsMenuController.h"
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"


//CCMenuItem *restartAllLevelsMenuItem=[CCMenuItemFont itemFromString:@"Restart All Levels" target:self selector:@selector(restartAllLevels)];
static const ccColor3B ccBlack={0, 0, 0};

@implementation SettingsMenuController

CCMenuItemToggle *SoundEfxToggleSwitch;
CCMenuItemToggle *MusicToggleSwitch;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingsMenuController *layer = [SettingsMenuController node];
	
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
		
		CCMenuItem *restartAllLevelsMenuItem=[CCMenuItemFont itemFromString:@"Restart All Levels" target:self selector:@selector(promptToClearLevelScores)];
		CCMenuItem *soundEfxOnMenuItem=[CCMenuItemFont itemFromString:@"Sound Effects: On" target:self selector:nil];
		CCMenuItem *soundEfxOffMenuItem=[CCMenuItemFont itemFromString:@"Sound Effects: Off" target:self selector:nil];
		SoundEfxToggleSwitch=[CCMenuItemToggle itemWithTarget:self selector:@selector(toggleSFX) items:soundEfxOnMenuItem,soundEfxOffMenuItem,nil];
		NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
		SoundEfxToggleSwitch.selectedIndex=[((NSNumber*)[prefs valueForKey:@"SFX"]) integerValue];
		
		CCMenuItem *musicOnMenuItem=[CCMenuItemFont itemFromString:@"Music: On" target:self selector:nil];
		CCMenuItem *musicOffMenuItem=[CCMenuItemFont itemFromString:@"Music: Off" target:self selector:nil];
		MusicToggleSwitch=[CCMenuItemToggle itemWithTarget:self selector:@selector(toggleMusic) items:musicOnMenuItem,musicOffMenuItem,nil];
		MusicToggleSwitch.selectedIndex=[((NSNumber*)[prefs valueForKey:@"MUSIC"]) integerValue];
		
		CCMenuItem *mainMenuButton=[CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(showMainMenu) ];
		CCMenu *settingsMenu;
		settingsMenu = [CCMenu menuWithItems:restartAllLevelsMenuItem,SoundEfxToggleSwitch,MusicToggleSwitch,mainMenuButton,nil];
		settingsMenu.position=ccp(windowSize.width/2, windowSize.height/2);
		[settingsMenu setColor:ccYELLOW];
		[settingsMenu alignItemsVertically];
		[self addChild:settingsMenu z:1];
	}
	return self;
}

-(void)restartAllLevels{
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	[prefs setInteger:1 forKey:@"currentLevel"];
	[prefs setInteger:0 forKey:@"currentGroup"];
	[prefs synchronize];
	
	[self clearAllLevelScores];
	
}

-(void)toggleSFX{
	CCLOG(@"Selected SFX Setting: %i",SoundEfxToggleSwitch.selectedIndex);
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	[prefs setInteger:SoundEfxToggleSwitch.selectedIndex forKey:@"SFX"];
	[prefs synchronize];
}

-(void)toggleMusic{
	CCLOG(@"Selected Music Setting: %i",MusicToggleSwitch.selectedIndex);
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	[prefs setInteger:MusicToggleSwitch.selectedIndex forKey:@"MUSIC"];
	if(MusicToggleSwitch.selectedIndex){
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}else if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]){
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"banjoTune.caf" loop:NO];
	
	}
	[prefs synchronize];
}

-(void)showMainMenu{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuController scene]]];	
}

-(void)promptToClearLevelScores{
	UIAlertView *confirmRestart=[[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you sure you want to restart all levels.  This will clear all of your scores for every level!" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes, reset.",nil] autorelease];
	[confirmRestart show];
	
	
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self restartAllLevels];
    }
}

-(void)clearAllLevelScores{
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	
	for (int levelNumber=0; levelNumber<5; levelNumber++) {
		int x=1;
		
		//	[NSString stringWithFormat:@"%i-%@",self.levelGroup,currentLevel]
		while (x<26) {
			CCLOG(@"Deleting score for level %i",x);
			[prefs setInteger:0 forKey:[NSString stringWithFormat:@"%i-%i",levelNumber,x]];
			
			x++;
		}
	}
	[prefs synchronize];
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}

-(void) dealloc{
	[super dealloc];
}

@end
