//
//  PTAppDelegate.m
//  PersonaTouch
//
//  Created by Luke Howard on 25/11/2013.
//  Copyright (c) 2013 PADL Software Pty Ltd. All rights reserved.
//

#import "PTAppDelegate.h"
#import "PTViewController.h"

#import <CFBrowserID.h>

@implementation PTAppDelegate
{
    id _context;
    NSData *_channelBindings;
}

- init
{
    CFErrorRef err;
    
    self = [super init];

    if (self != nil) {
        _context = CFBridgingRelease(BIDContextCreate(NULL, BID_CONTEXT_USER_AGENT | BID_CONTEXT_RP, &err));
        CFBridgingRelease(err);
        
        _channelBindings = [NSData dataWithBytes:"PersonaTouch" length:sizeof("PersonaTouch") - 1];
    }

    return self;
}

- (NSString *)personaGetAssertion:(NSString *)audience
                        withError:(NSError * __autoreleasing *)error
{
    CFStringRef assertion;
    CFErrorRef cfErr;
    uint32_t flags;
    
    BIDSetContextParam((__bridge BIDContext)_context, BID_PARAM_PARENT_WINDOW, (__bridge void *)self.window);
    
    assertion = BIDAssertionCreateUI((__bridge BIDContext)_context, (__bridge CFStringRef)audience,
                                     (__bridge CFDataRef)_channelBindings, NULL, 0, NULL, &flags, &cfErr);
    
    if (cfErr)
        *error = CFBridgingRelease(cfErr);
    
    return CFBridgingRelease(assertion);
}

- (void)personaVerifyAssertion:(NSString *)assertion
                  withAudience:(NSString *)audience
                    andHandler:(void (^)(NSDictionary *dict, NSError *err))handler
{
    dispatch_queue_t q = dispatch_queue_create("com.padl.BrowserID.example", NULL);
    
    BIDVerifyAssertionWithHandler((__bridge BIDContext)_context,
                                  (__bridge CFStringRef)assertion,
                                  (__bridge CFStringRef)audience,
                                  (__bridge CFDataRef)_channelBindings, // channel bindings
                                  CFAbsoluteTimeGetCurrent(),
                                  0, // flags
                                  q,
                                  ^(BIDIdentity identity, uint32_t flags, CFErrorRef error) {
                                      NSDictionary *attrs = nil;
                                      NSError *err = nil;
                                      
                                      if (identity)
                                          attrs = CFBridgingRelease(BIDIdentityCopyAttributeDictionary(identity));
                                      if (error)
                                          err = (__bridge NSError *)error;
                                      
                                      handler(attrs, err);
                                  });
    

    return;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    PTViewController *viewController = [[PTViewController alloc] init];

    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
