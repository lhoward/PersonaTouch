//
//  PTViewController.h
//  PersonaTouch
//
//  Created by Luke Howard on 25/11/2013.
//  Copyright (c) 2013 PADL Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UILabel *label;

@end
