//
//  Trends.h
//  Smart Monitor
//
//  Created by Adam dong on 16/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "GetCoordinatePoint.h"
#import "CoordinatePoint.h"
#import "SystemParameter.h"


@interface Trends : UIViewController<CPTScatterPlotDelegate,CPTPlotDataSource>
@property (strong,nonatomic) IBOutlet CPTGraphHostingView *GraphView;
@property (strong,nonatomic) NSMutableArray *Dates;
@property (strong,nonatomic) IBOutlet UIDatePicker *Picker;
@property (strong,nonatomic) IBOutlet UILabel *EndDate;
@property (strong,nonatomic) IBOutlet UILabel *startDate;
@property (strong,nonatomic) NSDate *From;
@property (strong,nonatomic) NSDate *to;
@property (strong,nonatomic) SystemParameter *PassedInfo;
@property (strong, nonatomic) IBOutlet UIDatePicker *DatePicker;

-(void) initPlot;

- (IBAction)DateEntry:(id)sender;

- (IBAction)PickerValueChanged:(id)sender;

- (IBAction)plot:(id)sender;

@end
