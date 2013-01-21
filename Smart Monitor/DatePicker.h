//
//  DatePicker.h
//  Smart Monitor
//
//  Created by Adam dong on 18/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *TableView;


@property (strong, nonatomic) IBOutlet UIDatePicker *DatePicker;



-(void) SettingDate;
- (void) AdjustTableViewSize;
@end
