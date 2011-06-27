//
//  Character.h
//  PondHopper
//
//  Created by shawn on 9/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum characterTypes {kDragonFlyCharacter=3, kFrogCharacter=2, kTreeFrogCharacter=1};
typedef	enum characterTypes characterType;

@interface Character : CCSprite {
	int size;
	BOOL selected;
	CCAction *_characterAction;
	
}

@property (nonatomic) int size;
@property (nonatomic) BOOL selected;
@property (nonatomic, retain) CCAction *characterAction;

+(id) characterWithType:(characterType) character;
 
+(void) setSize:(int) value;
+(void) setSelected:(BOOL) value;
//+(void) setCharacterAction:(CCAction *) actionToSet;

-(CGRect) rect;
-(void) movePiece:(CGPoint) newLocation;
//-(void) animateCharacter: (ccTime) dt;


@end
