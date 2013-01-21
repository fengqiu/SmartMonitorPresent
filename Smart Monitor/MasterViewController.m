//
//  MasterViewController.m
//  Smart Monitor
//
//  Created by Adam dong on 11/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import "MasterViewController.h"
#import "SystemDetails.h"
#import "GetSystem.h"
#import "System.h"

@interface MasterViewController ()

// 属性为  系统集合  GetSystem类
@property NSMutableArray *systemArray;
@property GetSystem *getAllSystem;

@end

@implementation MasterViewController

//@synthesize 属性;
@synthesize systemArray=_systemArray;
@synthesize username=_username;
@synthesize getAllSystem=_getAllSystem;

-(void) SetAllSystemInformation
{
    //GetSystem *GetSystemInformation = [[GetSystem alloc] init];
    //initialises a instance of getsystem
    
    //put it all into a class and then into our array.
    
    
    //run a function in GetSystem to get information
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.navigationController.navigationItem.hidesBackButton=YES;
    // self.navigationItem.accessibilityElementsHidden=YES;
    
    // 显示导航栏  返回按钮
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=YES;
    
    // 初始化 GetSystem类
    if (!self.getAllSystem) {
        self.getAllSystem=[[GetSystem alloc] init];
    }
    
    // 调用getAllSystem 的获取array的方法
    self.systemArray=[self.getAllSystem  getSystemArray:self.username];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.systemArray.count;
}

//editting styles
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_CustomerID removeObjectAtIndex:indexPath.row];
//    [tableView reloadData];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.systemArray.count>0) {
        System *systemobj = [self.systemArray objectAtIndex:indexPath.row];
        cell.textLabel.text = systemobj.systemDesc;
    }
    return cell;
}

//used for editting this table view
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable
//        return YES;
//}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //传变量给ShowDetail见面
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            System *systemobj= [self.systemArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] setSystemID:systemobj.systemID];
    }
}

@end
