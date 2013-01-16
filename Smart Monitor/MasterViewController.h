//
//  MasterViewController.h
//  Smart Monitor
//
//  Created by Adam dong on 11/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "System.h"

@interface MasterViewController : UITableViewController

// 储存用户名
@property (nonatomic, strong) NSString *username;

-(void) SetAllSystemInformation;
//downloads all the information needed from the webservice and inserts it into the allSystems NSmutable array



@end
