//
//  LillyPad.m
//  PondHopper
//
//  Created by shawn on 9/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LillyPad.h"


@implementation LillyPad

@synthesize characterOnPad, isGoal;

-(BOOL) addCharacterToPad:(Character *) characterToAdd{
	if (self.characterOnPad==nil){
		self.characterOnPad=characterToAdd;
		self.characterOnPad.position=self.position;
		return YES;
	}else{
		return NO;
	}
	
}
-(void)removeCharacter{
	self.characterOnPad=nil;
	
}

-(CGRect) rect{
	CGPoint center=self.position;
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	
	//	CCLOG(@"boardSquare(rect):%f,%f: %f x %f",self.textureRect.origin.x,self.textureRect.origin.y,self.textureRect.size.width, self.textureRect.size.height);
	//	CCLOG(@"boardSquare(rect):%f,%f: %f x %f",center.x-self.textureRect.size.width/2,windowSize.height-(center.y + self.textureRect.size.height/2),self.textureRect.size.width, self.textureRect.size.height);
	CGRect bounds=CGRectMake(center.x-self.textureRect.size.width/2, windowSize.height-(center.y + self.textureRect.size.height/2), self.textureRect.size.width, self.textureRect.size.height);
	//CCLOG(@"boardSquare(rect):%f,%f (%f x %f)", bounds.origin.x,bounds.origin.y,bounds.size.width, bounds.size.height);
	//	return CGRectMake(center.x-self.textureRect.size.width/2, windowSize.height-(center.y + self.textureRect.size.height/2), self.textureRect.size.width, self.textureRect.size.height);
	return bounds;
	//return self.textureRect;
}

-(CGPoint) correctedPosition{
	//CGPoint center=self.position;
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	//CCLOG(@"Window height: %f, Center Point: %f, RectHeight/2: %F",center.y,windowSize.height,self.textureRect.size.height/2);
	return CGPointMake(self.position.x, windowSize.height-self.position.y);
	
}


@end
