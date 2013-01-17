//
//  LoginDetails.h
//  Smart Monitor
//
//  Created by Adam dong on 11/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//
#import "MasterViewController.h"
#import <UIKit/UIKit.h>

@interface LoginDetails : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;




-(void) resignKeyboard;

@end
