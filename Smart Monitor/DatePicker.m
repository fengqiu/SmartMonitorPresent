//
//  DatePicker.m
//  Smart Monitor
//
//  Created by Adam dong on 18/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import "DatePicker.h"

@interface DatePicker ()
{

}

@end

@implementation DatePicker


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
    //hide navigation bar
    self.navigationController.navigationBarHidden=YES;
    
    //set data source
    //self.TableView.dataSource = self;
    //self.TableView.delegate = self;
    
    [self AdjustTableViewSize];
    [self SettingDate];
    
    //events
    [self.DatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
	// Do any additional setup after loading the view.
}

-(void) dateChanged:(id) sender
{
    
}

-(void) SettingDate
{
    //setting today's date
    NSDate *DateToday = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    self.DatePicker.minimumDate = DateToday;
}

//size of tableview adjustment
- (void) AdjustTableViewSize
{
    //Create a CGRECT
    CGRect bounds;
    
    //set the correct properties
    CGFloat Height = self.view.bounds.size.height - self.DatePicker.bounds.size.height;
    CGFloat Width = self.view.bounds.size.width;
    bounds.size.width = Width;
    bounds.size.height = Height;
    
    //assign as tableview bounds
    //self.TableView.bounds = bounds;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        UITableViewCell *SecondCell = [tableView dequeueReusableCellWithIdentifier:@"Save" forIndexPath:indexPath];
        return SecondCell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Date" forIndexPath:indexPath];

        return cell;
    }
}
//2 sections in the table view
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//in the first section only 1 row
//second section 2 rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
