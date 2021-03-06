//
//  SystemDetails.m
//  Smart Monitor
//
//  Created by Adam dong on 16/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import "SystemDetails.h"
#import "SystemParameter.h"
#import "GetSystemParameter.h"
#import "Trends.h"

@interface SystemDetails ()

// 属性为  系统参数集合  GetSystemParameter类
@property NSMutableArray *systemParameterArray;
@property GetSystemParameter *getAllSystemParameter;

@end

@implementation SystemDetails

@synthesize SystemID=_SystemID;
@synthesize systemParameterArray=_systemParameterArray;
@synthesize getAllSystemParameter=_getAllSystemParameter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置 navigationBar内容  style
    int height = self.navigationController.navigationBar.frame.size.height;
    int width = self.navigationController.navigationBar.frame.size.width;
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];    
    [navLabel setFont:[UIFont fontWithName:@"宋体" size:35.0]];
    navLabel.text=@"系统详细信息";
    navLabel.font=[navLabel.font fontWithSize:22];
    navLabel.backgroundColor=[UIColor clearColor];
    navLabel.textAlignment= NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    
    // 设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"返回"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    // 初始化 GetSystemParameter类
    if (!self.getAllSystemParameter) {
        self.getAllSystemParameter=[[GetSystemParameter alloc] init];
    }
    
    // 调用getAllSystem 的获取array的方法
    self.systemParameterArray=[self.getAllSystemParameter getSystemParameterArray:self.SystemID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.systemParameterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    if (self.systemParameterArray.count>0) {
        SystemParameter *systemParameterObj = [self.systemParameterArray objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName:@"宋体" size:17.0]];
        cell.textLabel.text = systemParameterObj.ParameterID;
        //NSLog(@"currentstringxxx: %@",systemParameterObj.systemDate);
        cell.detailTextLabel.text=systemParameterObj.quantity;
        systemParameterObj=nil;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //传变量给ShowDetail见面
    if ([[segue identifier] isEqualToString:@"ShowTrend"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SystemParameter *ParameterInfo= [self.systemParameterArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] setPassedInfo:ParameterInfo];
        indexPath=nil;
    }
}

@end
