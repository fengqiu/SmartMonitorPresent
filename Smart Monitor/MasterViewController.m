//
//  MasterViewController.m
//  Smart Monitor
//
//  Created by Adam dong on 11/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "GetSystem.h"

@interface MasterViewController ()
   @property NSMutableArray *CustomerID;
    //sores the ID of all systems

// 用户名
//@property (nonatomic,strong)

@end

@implementation MasterViewController
@synthesize UserDetails;
@synthesize CustomerID=_CustomerID;

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
    //initialise (初始化） everything
    _CustomerID = [[NSMutableArray alloc] init];
    [_CustomerID addObject:@"HR"];
    //从调tableview
    [self.tableView reloadData];
    {
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    }
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
    return self.CustomerID.count;
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
    
    NSString *customerIDtxt = [self.CustomerID objectAtIndex:indexPath.row];
    //NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = customerIDtxt;
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
            NSString *CustomerIDstr= [self.CustomerID objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:CustomerIDstr];
    }
}

@end
