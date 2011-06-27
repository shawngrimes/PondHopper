//
//  PondHopperAppDelegate.m
//  PondHopper
//
//  Created by shawn on 9/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "cocos2d.h"

#import "PondHopperAppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "MainMenuController.h"
#import "Appirater.h"
//#import "TapjoyConnect.h"

@implementation PondHopperAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	
	//For 3d Effects
//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
//	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];

	//[prefs setInteger:0 forKey:@"currentLevel"];
	[prefs synchronize];
	
	// Init the window
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// To enable Hi-Red mode (iPhone4)
	if([UIScreen instancesRespondToSelector:@selector(scale)]) {
		
		if([[UIScreen mainScreen] scale]==1.0)
		{
			//sd device
		}
		if([[UIScreen mainScreen] scale]==2.0)
		{
			if([[[UIDevice currentDevice] model] compare:@"iPad"]==NSOrderedSame)
			{	
				//iPad ! no retina
			}
			else {
				CCLOG(@"Turning on scaling");
				[director setContentScaleFactor:2];
			}
		}
		

	}
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
//#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
//#else
//	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
//#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	//TapJoy
//	[TapjoyConnect requestTapjoyConnectWithAppId:@"566d1b7e-22d7-414b-9b9a-dca4f37742f8"];	
	
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenuController scene]];		
	
	//Uncomment before release:
	//
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
	CCLOG(@"Loading appirater");
	[Appirater appLaunched];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
	//CCLOG(@"Loading appirater");
	//[Appirater appLaunched];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
