//
//  LoginDetails.m
//  Smart Monitor
//
//  Created by Adam dong on 11/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import "LoginDetails.h"
#import "MasterViewController.h"

@interface LoginDetails ()

@end

@implementation LoginDetails
@synthesize txtUsername,txtPwd;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    //runs the method to resign all responders
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    //connect "tap" and "ViewController"
    [self.view addGestureRecognizer:tap];

    
    
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.txtUsername setBackground:textFieldImage];
    [self.txtPwd setBackground:textFieldImage];
    [self.btnLogin setBackgroundImage:textFieldImage forState:UIControlStateNormal];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    //removes keyboard
    [textField resignFirstResponder];
    
}


-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    //clears textfield when editing begins
    textField.placeholder=@"";
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)resignKeyboard
{
     //resigns both keyboards
    [txtUsername resignFirstResponder];
    [txtPwd resignFirstResponder];
   
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
    [super didReceiveMemoryWarning];

}

- (IBAction)Login:(id)sender {
        [self performSegueWithIdentifier:@"goToMaster" sender:sender];
    
}
- (IBAction)LoginAction:(id)sender {
    
    
}
@end
