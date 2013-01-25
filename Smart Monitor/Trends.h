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
//iboutlet for the view which the graph is placed
@property (strong,nonatomic) IBOutlet CPTGraphHostingView *GraphView;
//Dates which contain Coordinate points objects
@property (strong,nonatomic) NSMutableArray *Dates;
//the date picker
@property (strong,nonatomic) IBOutlet UIDatePicker *Picker;
//end and start date labels in the user interface
@property (strong,nonatomic) IBOutlet UILabel *EndDate;
@property (strong,nonatomic) IBOutlet UILabel *startDate;
//end and start dates in the form of NSDATE
@property (strong,nonatomic) NSDate *From;
@property (strong,nonatomic) NSDate *to;
//SystemParameter object passed from previous interface
@property (strong,nonatomic) SystemParameter *PassedInfo;
//iboutlet for the search button
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
//initialise plot, contains all information for plot to plot at start up of the interface
- (void) initPlot;
//after a date entry button is pushed
- (IBAction)DateEntry:(id)sender;
//after the datepicker value has been changed
- (IBAction)PickerValueChanged:(id)sender;
//after the search button has been pushed
- (IBAction)plot:(id)sender;

@end
