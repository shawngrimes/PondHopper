//
//  LillyPad.h
//  PondHopper
//
//  Created by shawn on 9/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Character.h"


@interface LillyPad : CCSprite {
	Character *characterOnPad;
	BOOL isGoal;
}

@property (nonatomic, retain) Character *characterOnPad;
@property (nonatomic) BOOL isGoal;

-(BOOL) addCharacterToPad:(Character *) characterToAdd;
-(CGRect) rect;
-(CGPoint) correctedPosition;
-(void)removeCharacter;

@end
