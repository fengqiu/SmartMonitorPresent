//
//  LoginDetails.m
//  Smart Monitor
//
//  Created by Adam dong on 11/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import "LoginDetails.h"
#import "MasterViewController.h"
#import "User.h"

@interface LoginDetails ()

@property (nonatomic,strong) NSMutableArray *userArray;

@end

@implementation LoginDetails
@synthesize txtUsername,txtPwd;
@synthesize userArray=_userArray;

-(NSMutableArray *)userArray
{
    if (_userArray==nil) {
        _userArray =[[NSMutableArray alloc] init];
    }
    return _userArray;
}

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 添加背景图片
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.txtUsername setBackground:textFieldImage];
    [self.txtPwd setBackground:textFieldImage];
    [self.btnLogin setBackgroundImage:textFieldImage forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];//runs the method to resign all responders

    // 向控制器的array中添加假用户
    User *loginUser=[[User alloc] initWithUsername:@"aaa" password:@"123"];
    [self.userArray addObject:loginUser];
    
    self.navigationController.navigationBarHidden=YES;
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    [self.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    //self.navigationBar
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"header_bg.png"] resizableImageWithCapInsets:
                                 UIEdgeInsetsMake(68, 68, 68, 68)];
    self.backgroundImageView.image = shareButtonImage;
    //self.backgroundImageView.center = self.center;

}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //removes keyboard
    if ([textField isEqual:txtPwd])
    {
        if (textField.text.length==0)
        {
            textField.placeholder = @"密码";
        }
    }
    else
    {
        if (textField.text.length==0)
        {
            textField.placeholder = @"用户名";
        }
    }   
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    textField.placeholder=@"";
    //clears textfield when editing begins
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)resignKeyboard
{
    [txtUsername resignFirstResponder];
    [txtPwd resignFirstResponder];
    //resigns both keyboards
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 登录方法
- (IBAction)Login:(id)sender {
    // 判断用户名或者密码是否为空
    if (self.txtUsername.text.length==0||self.txtPwd.text.length==0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:@"请键入用户名或密码" delegate:self cancelButtonTitle:@"好,我知道了" otherButtonTitles:nil];
		[alertView show];        
    }
    else
    {
        if (self.userArray.count==0) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不正确" message:@"请重新键入用户名或密码" delegate:self cancelButtonTitle:@"好,我知道了" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            User *tempuser=[self.userArray objectAtIndex:0];
            
            // 判断用户名和密码是否相同
            if ([self.txtUsername.text isEqualToString:tempuser.username]&&[self.txtPwd.text isEqualToString:tempuser.password]) {
                // 通过segue跳转页面
                [self performSegueWithIdentifier:@"goToMaster" sender:sender];
            }
            else
            {
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不正确" message:@"请重新键入用户名或密码" delegate:self cancelButtonTitle:@"好,我知道了" otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
}

//-(BOOL)shouldAutomaticallyForwardRotationMethods
//{
//    return NO;
//}
//
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIIinterfaceOrientation)interfaceOrientation
//{
//    return true;
//}

@end
