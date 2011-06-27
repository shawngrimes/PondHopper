//
//  Character.m
//  PondHopper
//
//  Created by shawn on 9/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

@implementation Character

@synthesize size, selected;
@synthesize characterAction=_characterAction;

+(id) characterWithType:(characterType) character{
		switch (character) {
			case kDragonFlyCharacter:
				if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				{
					//self =[super spriteWithFile:@"DragonFly-iPad.png"];
					self =[ super  spriteWithSpriteFrameName:@"DragonFly0.png"];
				}else{
					self =[ super  spriteWithSpriteFrameName:@"DragonFly0.png"];
				}
				self.size=kDragonFlyCharacter;
				self.selected=NO;
				
				break;
			case kFrogCharacter:
				if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				{
					//self =[ super  spriteWithFile:@"frog-ipad.png"];
					self =[ super  spriteWithSpriteFrameName:@"FatFrog0.png"];
				}else{
					//self =[ super  spriteWithFile:@"frog.png"];
					self =[ super  spriteWithSpriteFrameName:@"FatFrog0.png"];
				}
				self.size=kFrogCharacter;
				self.selected=NO;
				/*
				NSMutableArray *fatFrogAnimFrames=[NSMutableArray array];
				[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrogBlink1.png"]];
				[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrogBlink2.png"]];
				[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrogBlink1.png"]];
				//[fatFrogAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"FatFrog0.png"]];
				
				CCAnimation *fatFrogAnim=[CCAnimation animationWithName:@"fatFrogBlink" delay:0.2f frames:fatFrogAnimFrames];
				self.characterAction=[CCAnimate actionWithAnimation:fatFrogAnim restoreOriginalFrame:YES];
				[self schedule:@selector(animateCharacter:) interval:4.0];
				 */
				break;
			case kTreeFrogCharacter:
				if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				{
					//self =[ super  spriteWithFile:@"treeFrog-ipad.png"];
					self =[ super  spriteWithSpriteFrameName:@"TreeFrog0.png"];
				}else{
					self =[ super  spriteWithSpriteFrameName:@"TreeFrog0.png"];
				}
				self.size=kTreeFrogCharacter;
				self.selected=NO;
				break;	
			default:
				self=nil;
				break;
		}
	
	return self;
}
/*
-(void) animateCharacter: (ccTime) dt
{
	if(!self.selected){
		[self runAction:self.characterAction];
	}
}
*/

+(void) setSize:(int) value{
	self.size=value;
}

+(void) setSelected:(BOOL) value{
	self.selected=value;
}
/*
+(void) setCharacterAction:(CCAction *) actionToSet{
	self.characterAction=actionToSet;
	
}
 */

-(void) movePiece:(CGPoint) newLocation{
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	newLocation.y=windowSize.height-newLocation.y;
	self.position=newLocation;
	
}

-(CGRect) rect{
	CGPoint center=self.position;
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	//CCLOG(@"Window height: %f, Center Point: %f, RectHeight/2: %F",center.y,windowSize.height,self.textureRect.size.height/2);
	return CGRectMake(center.x-self.textureRect.size.width/2, windowSize.height-(center.y + self.textureRect.size.height/2), self.textureRect.size.width, self.textureRect.size.height);
	
	
}

@end
