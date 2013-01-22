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
#import "GetUser.h"

@interface LoginDetails ()

@property (nonatomic,strong) GetUser *getisUser;

@end

@implementation LoginDetails

@synthesize txtUsername=_txtUsername;
@synthesize txtPwd=_txtPwd;
@synthesize btnLogin=_btnLogin;
@synthesize navigationBar=_navigationBar;
@synthesize backgroundImageView=_backgroundImageView;
@synthesize getisUser=_getisUser;
@synthesize logoImage=_logoImage;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"53640.jpg"]];
    
    // 添加文本框  登陆按钮的背景图片
    //UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    //[self.txtUsername setBackground:textFieldImage];
    //[self.txtPwd setBackground:textFieldImage];
    //[self.btnLogin setBackgroundImage:textFieldImage forState:UIControlStateNormal];
    self.btnLogin.titleLabel.font=[UIFont fontWithName:@"宋体" size:6.0];
    self.btnLogin.titleLabel.font=[self.btnLogin.titleLabel.font fontWithSize:17.0];
    
    //runs the method to resign all responders
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    //connect "tap" and "ViewController"
    [self.view addGestureRecognizer:tap];

    // 隐藏导航栏
    self.navigationController.navigationBarHidden=YES;
    
    // 设置默认文字
    self.txtUsername.placeholder=@"用户名";
    self.txtUsername.font=[UIFont fontWithName:@"宋体" size:5.0];
    self.txtUsername.font=[self.txtUsername.font fontWithSize:15.0];
    self.txtPwd.placeholder=@"密码";
    self.txtPwd.font=[UIFont fontWithName:@"宋体" size:5.0];
    self.txtPwd.font=[self.txtPwd.font fontWithSize:15.0];
    
//    CALayer *imglayer = self.logoImage.layer;   //获取ImageView的层
//    imglayer.shouldRasterize = YES;
//    [imglayer set setMasksToBounds:YES];
//    [imglayer setCornerRadius:6.0];
//    
//    self.logoImage.layer.cornerRadius = 6;
//    imageView.layer.cornerRadius = 6;
  //  imageView.layer.masksToBounds = YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    //removes keyboard
    [textField resignFirstResponder];
    
    //removes keyboard
    if ([textField isEqual:self.txtPwd])
    {
        if (textField.text.length==0)
        {
            textField.placeholder = @"密码";
            textField.font=[UIFont fontWithName:@"宋体" size:3.0];
            textField.font=[textField.font fontWithSize:15.0];
        }
    }
    else
    {
        if (textField.text.length==0)
        {
            textField.placeholder = @"用户名";
            textField.font=[UIFont fontWithName:@"宋体" size:3.0];
            textField.font=[textField.font fontWithSize:15.0];
        }
    }   
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
    [self.txtUsername resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    //resigns both keyboards
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
    [super didReceiveMemoryWarning];

}

// 登录方法
- (IBAction)Login:(id)sender {
    // 判断用户名或者密码是否为空
    if (self.txtUsername.text.length==0||self.txtPwd.text.length==0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:@"请输入用户名或密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alertView show];
        alertView=nil;
    }
    else
    {        
        self.getisUser = [[GetUser alloc] init];
        BOOL flage=[self.getisUser checkUser:self.txtUsername.text password:self.txtPwd.text];
        if (flage) {
            // 释放内存
            self.getisUser=nil;
            
            // 通过segue跳转页面
            [self performSegueWithIdentifier:@"goToMaster" sender:sender];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不正确" message:@"请重新键入用户名或密码" delegate:self cancelButtonTitle:@"好,我知道了" otherButtonTitles:nil];
            [alertView show];
            alertView=nil;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToMaster"]) {
        [[segue destinationViewController] setUsername:self.txtUsername.text];
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
