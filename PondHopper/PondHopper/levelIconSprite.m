//
//  levelIconSprite.m
//  PondHopper
//
//  Created by shawn on 10/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "levelIconSprite.h"

static const ccColor3B ccGreen={57, 181, 74};
@implementation levelIconSprite

CCLabelTTF *levelLabel;

+(id) createLevelIconForLevel{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		self =[super spriteWithFile:@"LilyPad.png"];
	}else{
		self =[super spriteWithFile:@"LilyPad.png"];
	}
//	levelLabel=[CCLabelTTF labelWithString:@"X" fontName:@"KOMIKAX_" fontSize:48];
//	[self addChild:levelLabel z:2 tag:33];
	return self;

}
 -(void) setLevelLabel:(int) levelNumber{
	 
	 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	 {
		 levelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", levelNumber] fontName:@"KOMIKAX_" fontSize:48];
	 }else{
		 levelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", levelNumber] fontName:@"KOMIKAX_" fontSize:24];
	 }
	 [levelLabel setColor:ccGreen];
	 [self addChild:levelLabel z:2 tag:33];
	 levelLabel.position=ccp(self.textureRect.size.width/2, self.textureRect.size.height/2);
	 
 }


-(void) setComplete:(bool) isComplete{
	
	if(isComplete){
		CCSprite *completeIcon;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			completeIcon=[CCSprite spriteWithFile:@"levelCompleteOverlay-ipad.png"]; 
		}else{
			completeIcon=[CCSprite spriteWithFile:@"levelCompleteOverlay.png"];
		}
		completeIcon.position=self.position;
		[self addChild:completeIcon z:3 tag:34];
	}
	
}

@end
