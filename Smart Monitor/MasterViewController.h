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

@property (nonatomic, strong) NSString *username;
//stores the login details of the user which logged in

-(void) SetAllSystemInformation;
//downloads all the information needed from the webservice and inserts it into the allSystems NSmutable array



@end
