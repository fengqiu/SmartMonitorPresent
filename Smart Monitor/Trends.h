//
//  Trends.h
//  Smart Monitor
//
//  Created by Adam dong on 16/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface Trends : UIViewController<CPTScatterPlotDelegate,CPTPlotDataSource>
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *GraphView;
@property (strong,nonatomic) NSMutableArray *Dates;
@property (strong, nonatomic) IBOutlet UIDatePicker *Picker;
@property (strong, nonatomic) IBOutlet UILabel *EndDate;
@property (strong, nonatomic) IBOutlet UILabel *startDate;


-(void) initPlot;

-(void)configureGraph;

-(void)configurePlots;

-(void)configureAxes;

-(void) configureXAxis : (CPTXYAxis *) xAxis;

-(void) configureYAxes : (CPTXYAxis *) yAxis;

- (IBAction)DateEntry:(id)sender;

- (IBAction)PickerValueChanged:(id)sender;

- (IBAction)plot:(id)sender;

@end
