//
//  individualLevelSelect.m
//  PondHopper
//
//  Created by shawn on 10/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "individualLevelSelect.h"
#import "TBXML.h"

//static const ccColor3B ccGreen={57, 181, 74};
static const ccColor3B ccGold={252, 238, 33};

@implementation individualLevelSelect

@synthesize levelGroup;

id liquidAction;
id backgroundAction;
CCSprite *background;

CGSize windowSize;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	individualLevelSelect *layer = [individualLevelSelect node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(id) trainingScene{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	individualLevelSelect *layer = [individualLevelSelect node];
	
	[layer loadLevels:0];
	layer.levelGroup=0;
	
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(id) level1{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	individualLevelSelect *layer = [individualLevelSelect node];
	
	[layer loadLevels:1];
		layer.levelGroup=1;
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
+(id) level2{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	individualLevelSelect *layer = [individualLevelSelect node];
	
	[layer loadLevels:2];
	layer.levelGroup=2;
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
+(id) level3{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	individualLevelSelect *layer = [individualLevelSelect node];
	
	[layer loadLevels:3];
	layer.levelGroup=3;
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(id) level4{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	individualLevelSelect *layer = [individualLevelSelect node];
	
	[layer loadLevels:4];
	layer.levelGroup=4;
	
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
		
		//CCColorLayer *backgroundColor=[CCColorLayer layerWithColor:ccc4(0, 210, 255, 255)];
		//[self addChild:backgroundColor z:0];

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
		//id liquid=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
		//[background runAction:[CCRepeatForever actionWithAction:liquid]];
		
		
		
	}
	return self;
}

-(void) loadLevels:(int) levelToLoad{
	
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	NSMutableArray *menuItemArray=[NSMutableArray arrayWithCapacity:1];
	
	NSString *levelPath=[[NSBundle mainBundle] resourcePath];
	TBXML *xmlData=[[TBXML alloc] initWithXMLFile:[levelPath stringByAppendingFormat:@"/PondHopperLevels-%i.xml", levelToLoad]];
	if (xmlData.rootXMLElement){
		TBXMLElement *xmlLevelElement=[TBXML childElementNamed:@"level" parentElement:xmlData.rootXMLElement];
		int ElementLevelCount;
		ElementLevelCount=1;
		while(xmlLevelElement){
			//[self traverseElement:xmlLevelElement];
			//CCLOG(@"Looking for %i, found %@", levelNumber, [TBXML valueOfAttributeNamed:@"levelNumber" forElement:xmlLevelElement]);
			NSString *xmlLevelNumber=[TBXML valueOfAttributeNamed:@"levelNumber" forElement:xmlLevelElement];
			if ([xmlLevelNumber isEqualToString:@"x"]) {
				xmlLevelNumber=[[NSNumber numberWithInt:ElementLevelCount] stringValue];
			}
			CCLOG(@"Creating level icon for %@", xmlLevelNumber);
			
//			levelIconSprite *levelIcon=[levelIconSprite createLevelIconForLevel];
			
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			{
				[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sheet-hd.plist"];
				//			[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lillyPads-ipad.plist"];
			}else{
				//			[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"characters-iphone.plist"];
				[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sheet.plist"];
				
				//CCSpriteBatchNode *batchNode=[CCSpriteBatchNode batchNodeWithFile:@"characters-iphone.png"];
			}
			
			CCSprite *levelIcon=[CCSprite spriteWithSpriteFrameName:@"LilyPad-level.png"];
			
			//[levelIcon setLevelLabel:[xmlLevelNumber integerValue]];
			//CCLOG(@"Set Level label for %i", [xmlLevelNumber integerValue]);
			//if ([prefs integerForKey:xmlLevelNumber]) {
			//	[levelIcon setComplete:YES];
			//	CCLOG(@"Marking level complete");
			//}
			
			CCMenuItemSprite *newMenuItemSprite=[CCMenuItemSprite itemFromNormalSprite:levelIcon selectedSprite:nil target:self selector:@selector(loadLevel:)];
			CCLOG(@"Created menuItem");
			CCLabelTTF *levelLabel;
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			{
				levelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", xmlLevelNumber] fontName:@"CHUBBY" fontSize:48];
			}else{
				levelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", xmlLevelNumber] fontName:@"CHUBBY" fontSize:24];
			}
			
			[newMenuItemSprite addChild:levelLabel z:2 tag:33];
			int levelScore=[prefs integerForKey:[NSString stringWithFormat:@"%i-%@",levelToLoad,xmlLevelNumber]];
			if (levelScore>0) {
				CCLOG(@"Sore for %i is %i",[xmlLevelNumber integerValue],levelScore);
				[levelLabel setColor:ccWHITE];
				if(levelScore==1000){
					[levelLabel setColor:ccGold];
				}
				/*
				CCSprite *completeIcon;
				if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				{
					completeIcon=[CCSprite spriteWithFile:@"levelCompleteOverlay-ipad.png"]; 
				}else{
					completeIcon=[CCSprite spriteWithFile:@"levelCompleteOverlay.png"];
				}
				[newMenuItemSprite addChild:completeIcon z:3 tag:34];
				completeIcon.position=levelIcon.position;
				CCLOG(@"Marking level complete");
				 */
			}else{
				[levelLabel setColor:ccBLACK];
			}

				
			
			CCLOG(@"Added menuitem label");
			levelLabel.position=ccp(levelIcon.textureRect.size.width/2, levelIcon.textureRect.size.height/2);
			//[newMenu addChild:newMenuItemSprite z:1 tag:[xmlLevelNumber integerValue]];
//			[newMenu addChild:newMenuItemSprite z:1 tag:1];	
			[menuItemArray addObject:newMenuItemSprite];
			CCLOG(@"Getting next sibling");
			xmlLevelElement=xmlLevelElement->nextSibling;
			ElementLevelCount++;
		}
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[CCMenuItemFont setFontSize:60];
		}else{
			[CCMenuItemFont setFontSize:30];
		}
		
		CCMenuItem *mainMenuButton=[CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(showMainMenu)];
		CCMenu *newMenu=[CCMenu menuWithItems:mainMenuButton,nil];
		//newMenu.color=ccYELLOW;
		newMenu.position=ccp(windowSize.width/2,windowSize.height/7);
		[self addChild:newMenu z:1 tag:0];
		//[newMenu alignItemsInRows:[NSNumber numberWithInt:[ElementLevelCount integerValue] % 5],nil];
		
		MenuGrid* menuGrid;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			menuGrid=[MenuGrid menuWithArray:menuItemArray fillStyle:kMenuGridFillColumnsFirst itemLimit:5 padding:CGPointMake(120.0f, 120.0f)];
			menuGrid.anchorPoint = CGPointZero;
//			menuGrid.position = CGPointMake(150, windowSize.height-120);
			menuGrid.position = CGPointMake(135, windowSize.height-windowSize.height/4);
			
		}else{
			menuGrid=[MenuGrid menuWithArray:menuItemArray fillStyle:kMenuGridFillColumnsFirst itemLimit:5 padding:CGPointMake(55.5f, 55.5f)];
			menuGrid.anchorPoint = CGPointZero;
			menuGrid.position = CGPointMake(45, windowSize.height-windowSize.height/4);
			
		}
		[self addChild:menuGrid z:1 tag:0];
		
		
		//Set Background
		CCLOG(@"Loading background for: %i", levelToLoad);
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			
			switch (levelToLoad) {
				case 0:
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"KoiPond-ipad.png"];
					//liquidAction=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
					//backgroundAction=[background runAction:[CCRepeatForever actionWithAction:liquidAction]];
					break;
				case 1:
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"TurtlePond-ipad.png"];
					break;
				case 2:
					//[background stopAction:backgroundAction];
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"BeaverPond-ipad.png"];
					
					//				background =[CCSprite spriteWithFile:@"DuckPond-ipad.png"];
					break;
				case 3:
					//[background stopAction:backgroundAction];
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
					break;
			}
		}else {
			switch (levelToLoad) {
				case 0:
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"KoiPond.png"];
					//liquidAction=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
					//backgroundAction=[background runAction:[CCRepeatForever actionWithAction:liquidAction]];
					break;
				case 1:
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"TurtlePond.png"];
					break;
				case 2:
					//[background stopAction:backgroundAction];
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"BeaverPond.png"];
					//				background =[CCSprite spriteWithFile:@"DuckPond.png"];
					break;
				case 3:
					//[background stopAction:backgroundAction];
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"SnakePond.png"];
					//				background =[CCSprite spriteWithFile:@"StonePond.png"];
					break;
				case 4:
					//[background stopAction:backgroundAction];
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"CattailPond.png"];
					//				background =[CCSprite spriteWithFile:@"StonePond.png"];
					break;
				default:
					background.texture=[[CCTextureCache sharedTextureCache] addImage:@"KoiPond.png"];
					//liquidAction=[CCLiquid actionWithWaves:2 amplitude:5 grid:ccg(15,10) duration:5];
					//backgroundAction=[background runAction:[CCRepeatForever actionWithAction:liquidAction]];
					break;
					
			}	
		}
		
		
		/*
		if(levelToLoad<1){
			[newMenu alignItemsHorizontally];
		}else{
			[newMenu alignItemsInRows:[NSNumber numberWithInt:5],nil];
		}
		[self addChild:newMenu z:1 tag:99];
		*/
	}
}

-(void)loadLevel:(id) sender{

	CCLOG(@"Loading levelGroup: %i Level: %i", self.levelGroup, [sender tag]+1);
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameController sceneLevelGroup:self.levelGroup levelNumber:[sender tag]+1]]];
	
}

-(void)showMainMenu{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuController scene]]];	
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}


@end
