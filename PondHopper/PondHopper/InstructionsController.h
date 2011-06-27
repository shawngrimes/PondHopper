//
//  InstructionsController.h
//  PondHopper
//
//  Created by shawn on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameController.h"
#import "MainMenuController.h"

@interface InstructionsController : CCLayer {

}

+(id) scene;
-(id) init;

-(void) startGame;
-(void) showMainMenu;

@end
