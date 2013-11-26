//
//  PTAppDelegate.h
//  PersonaTouch
//
//  Created by Luke Howard on 25/11/2013.
//  Copyright (c) 2013 PADL Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSString *)personaGetAssertion:(NSString *)audience
                        withError:(NSError * __autoreleasing *)error;

- (void)personaVerifyAssertion:(NSString *)assertion
                  withAudience:(NSString *)audience
                    andHandler:(void (^)(NSDictionary *dict, NSError *err))handler;

@end
