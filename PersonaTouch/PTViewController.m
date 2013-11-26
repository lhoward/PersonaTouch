//
//  PTViewController.m
//  PersonaTouch
//
//  Created by Luke Howard on 25/11/2013.
//  Copyright (c) 2013 PADL Software Pty Ltd. All rights reserved.
//

#import "PTViewController.h"
#import "PTAppDelegate.h"

@interface PTViewController ()

@end

@implementation PTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    // based on http://blog.austinlouden.com/post/47644627216/your-first-ios-app-100-programmatically
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 300.0f, 30.0f)];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.text = @"http://www.padl.com";
    
    [self.view addSubview:self.textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button.frame = CGRectMake(110.0f, 200.0f, 100.0f, 30.0f);
    
    [button addTarget:self
               action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"Get assertion!" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 150.0f, 500.0f, 50.0f)];
    self.label.text = @"";
    [self.view addSubview:self.label];
}

- (void)buttonPressed
{
    PTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSError *error;
    NSString *assertion;
    
    assertion = [delegate personaGetAssertion:self.textField.text withError:&error];
    if (error) {
        self.label.text = [error userInfo][(__bridge NSString *)kCFErrorDescriptionKey];
    } else {
        [delegate personaVerifyAssertion:assertion withAudience:self.textField.text andHandler:^(NSDictionary *attrs, NSError *e) {
            NSLog(@"dict %@", attrs);
            [self.label performSelectorOnMainThread:@selector(setText:) withObject:attrs[@"sub"] waitUntilDone:FALSE];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
