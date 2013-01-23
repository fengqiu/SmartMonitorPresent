//
//  Trends.m
//  Smart Monitor
//
//  Created by Adam dong on 16/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import "Trends.h"
#import "CoordinatePoint.h"

@interface Trends ()
{
    bool EndorStart;
}

-(void)configureGraph;

-(void)configurePlots;

-(void)configureAxes;

-(void) xAxisSettings: (CPTXYAxis *) xAxis YAxisSettings: (CPTXYAxis *) yAxis;

-(void) configureXAxis : (CPTXYAxis *) xAxis;

-(void) configureYAxes : (CPTXYAxis *) yAxis;

-(void) InitialPlotData;


@end

@implementation Trends

@synthesize GraphView,Dates;
@synthesize Picker;
@synthesize From,to;
@synthesize PassedInfo;


//**************Graph
-(void)initPlot {
    
    [self configureGraph];
    [self configurePlots];
    //makes sure there is more than 1 point in dates so that we can plot a graph
    if (Dates.count > 1)
        [self configureAxes];
    //self.GraphView.allowPinchScaling = YES;
    
}

-(void)configureGraph
{
    //instantialise graph view
    CPTGraph *Graph = [[CPTXYGraph alloc] initWithFrame:self.GraphView.bounds];
    self.GraphView.hostedGraph = Graph;
    //applying plain black theme
    [Graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    //padding area
    [Graph.plotAreaFrame setPaddingLeft:25.0f];
    [Graph.plotAreaFrame setPaddingRight:20.0f];
    [Graph.plotAreaFrame setPaddingTop:20.0f];
    [Graph.plotAreaFrame setPaddingBottom:50.0f];
    
}

-(void)configurePlots
{
    
    //Setting graph as the graph on the host
    CPTGraph *graph = self.GraphView.hostedGraph;
    //setting the plotspace
    CPTXYPlotSpace * plotspace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    
    //Scatter Plot trend
    CPTScatterPlot *SmartLinkTrend = [[CPTScatterPlot alloc] init];
    
    SmartLinkTrend.dataSource = self;
    SmartLinkTrend.identifier = @"Trends";
    
    //set trend color to blue
    CPTColor *trendColor = [CPTColor blueColor];
    //adding to the plot
    [graph addPlot:SmartLinkTrend toPlotSpace:plotspace];
    
    //scalling the plotspace, Also calls delegate functions
    if (Dates.count<=1)
    {
        //checks for error
        UIAlertView *Error = [[UIAlertView alloc] initWithTitle:nil message:@"不够信息" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Error show];
    }
    else
    {
        [plotspace scaleToFitPlots:[NSArray arrayWithObjects:SmartLinkTrend, nil]];
    }
    //line style and setting characteristics for it
    CPTMutableLineStyle *smartlinkLines = [SmartLinkTrend.dataLineStyle mutableCopy];
    smartlinkLines.lineWidth = 2.5;
    smartlinkLines.lineColor = trendColor;
    SmartLinkTrend.dataLineStyle = smartlinkLines;
    
    
}

-(void)configureAxes
{
    
    CPTGraph *Graph = self.GraphView.hostedGraph;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) Graph.axisSet;
    //X and Y axis Set
    CPTXYAxis *xAxis = axisSet.xAxis;
    CPTXYAxis *yAxis = axisSet.yAxis;
    
    //settings for both axis
    [self xAxisSettings:xAxis YAxisSettings:yAxis];
    //configuring X Axis
    [self configureXAxis:xAxis];
    //configuring Y Axis
    [self configureYAxes:yAxis];
}


//method to configure X Axis
-(void) configureXAxis : (CPTXYAxis *) xAxis
{
    //getting minimum value from the quantity in dates
    NSMutableArray *QTY = [[NSMutableArray alloc] initWithCapacity:Dates.count];
    for (CoordinatePoint *date in Dates) {
        NSNumber *quantity = date._quantity;
        [QTY addObject:quantity];
    }
    NSNumber* min = [QTY valueForKeyPath:@"@min.self"];
    xAxis.orthogonalCoordinateDecimal = CPTDecimalFromInt([min intValue]);
    
    
    
    //label style
    CPTMutableTextStyle *labelStyle = [CPTMutableTextStyle textStyle];
    labelStyle.color = [CPTColor blackColor];
    labelStyle.fontName = @"Helvetica-Bold";
    labelStyle.fontSize = 10.0f;
    
    
    
    //using the default plot space
    CPTXYPlotSpace *Host = (CPTXYPlotSpace *) GraphView.hostedGraph.defaultPlotSpace;
    
    
    
    
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //fake data and locations
    NSMutableSet *xLabels = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    NSMutableSet *Locations = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    
    //length of axis
    CGFloat length;
    length = CPTDecimalCGFloatValue(Host.xRange.length);
    //where every tick should be
    NSInteger  division= Dates.count-1;
    length = length/division;
    
    //creating labels
    int i=0;
    for (NSDate *date in Dates)
    {
        CoordinatePoint *Point = [Dates objectAtIndex:i];
        
        NSString *strDate =[[NSString alloc] initWithString:Point._systemDate];
        
        //making the label for x axis
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:strDate textStyle:labelStyle];
        label.rotation = 1.57f;
        NSNumber *locationOfTick = [NSNumber numberWithFloat:length *i];
        label.offset = 1.0f;
        
        label.tickLocation = [locationOfTick decimalValue];
        [xLabels addObject:label];
        [Locations addObject:locationOfTick];
        i++;
    }
    
    //putting labels on graph
    xAxis.axisLabels = xLabels;
    xAxis.majorTickLocations = Locations;
    
}


-(void) xAxisSettings: (CPTXYAxis *) xAxis YAxisSettings: (CPTXYAxis *) yAxis
{
    //Axes Settings
    //setting axis title
    CPTAxisTitle *yAxisTitle = [[CPTAxisTitle alloc] initWithText:@"数量" textStyle: yAxis.labelTextStyle];
    yAxisTitle.rotation = 1.57f;
    yAxis.axisTitle = yAxisTitle;
    yAxis.titleOffset = 7.0f;
    
    
    //axis tick things
    yAxis.majorTickLength = 5.0f;
    yAxis.minorTickLength = 0.0f;
    
    //x axis label stuff
    CPTAxisTitle *xTitle = [[CPTAxisTitle alloc] initWithText:@"日期" textStyle:xAxis.labelTextStyle];
    xAxis.axisTitle = xTitle;
    
    xAxis.titleOffset = -15.0f;
    
    xAxis.majorTickLength = 5.0f;
    xAxis.minorTickLength = 0.0f;
}

//method to configure Y Axis
-(void) configureYAxes : (CPTXYAxis *) yAxis
{
    
    yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    
    //creating data label arrays
    NSMutableSet *Data = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    NSMutableSet *Locations = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    
    
    //location of major tick
    for (int i=0; i<Dates.count; i++)
    {
        CoordinatePoint *point = [Dates objectAtIndex:i];
        NSNumber *locationOfTick = point._quantity;
        
        
        //display the value at Quantity
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i",[locationOfTick intValue]] textStyle:yAxis.labelTextStyle];
        
        //label properties
        label.offset = 0.0f;
        label.tickLocation = [locationOfTick decimalValue];
        
        //putting objects into array
        [Data addObject:label];
        [Locations addObject:locationOfTick];
        
    }
    yAxis.axisLabels = Data;
    yAxis.majorTickLocations = Locations;
    
}










































- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

-(void) InitialPlotData
{
   NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    [Formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *NewestDate = [Formatter dateFromString:[PassedInfo systemDate]];
    NSDate *SevenDaysPrior = [[NSDate alloc] initWithTimeInterval:-604800 sinceDate:NewestDate];
    self.startDate.text = [Formatter stringFromDate:SevenDaysPrior];
    self.EndDate.text = [Formatter stringFromDate:NewestDate];
    
    
    GetCoordinatePoint *CoodinatePoint = [[GetCoordinatePoint alloc] initWithPropertiesTo:self.EndDate.text from:self.startDate.text];
    [CoodinatePoint GetCoordinatePoints:[PassedInfo systemID] DataType:[PassedInfo systemParameter]];
    
    
    Dates = CoodinatePoint.CoordinatePoints;
}

-(void) initEverything
{
    
    [self.navigationItem setTitle:PassedInfo.systemParameter];
    Dates = [[NSMutableArray alloc] init];
    From = [[NSDate alloc] init];
    to = [[NSDate alloc] init];
    [self InitialPlotData];
}




- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    Picker.hidden = YES;
    //setting max date for Date picker
    self.DatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    //adding tap gesture to dismiss datepicker
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HidePicker)];
    //connect "tap" and "ViewController"
    [self.view addGestureRecognizer:tap];
    [self initEverything];
    //hides the date picker
    
  
    [self initPlot];

}








- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}











//delegate
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return Dates.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if (fieldEnum == CPTScatterPlotFieldY)
    {
        CoordinatePoint *point =[Dates objectAtIndex:index];
        NSNumber *quantity = point._quantity;
        return quantity;
    }
    else
    {
        return [NSNumber numberWithInteger:index];
    }
}










//******User Interface

- (IBAction)DateEntry:(id)sender
{
    //set text color to black
//    [self.EndDate setTextColor:[UIColor blackColor]];
//    [self.startDate setTextColor:[UIColor blackColor]];
    [self HidePicker];
    
    
    if (Picker.hidden)
    {
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        // Set the type and if appropriate direction of the transition,
        [animation setType:kCATransitionMoveIn];
        [animation setSubtype:kCATransitionFromTop];
        // Set the duration and timing function of the transtion -- duration is passed in as a parameter, use ease in/ease out as the timing function
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [[Picker layer] addAnimation:animation forKey:@"transitionViewAnimation"];
        
        Picker.hidden = FALSE;
        
        [[Picker layer] removeAnimationForKey:@"transitionViewAnimation"];
        animation = nil;
    }
    
    if ([sender tag]==1)
    {
        EndorStart = true;
        [Picker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        [self.EndDate setTextColor:[UIColor grayColor]];
        
    }
    else if ([sender tag] == 2)
    {
        EndorStart = false;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *endDate = [formatter dateFromString:self.EndDate.text];
        [Picker setMaximumDate:[NSDate dateWithTimeInterval:-172800 sinceDate:endDate]];
        [self.startDate setTextColor:[UIColor grayColor]];
        
        
    }
    
}




- (IBAction)plot:(id)sender
{
    [self HidePicker];
    
    //download from webservice
    GetCoordinatePoint *CoodinatePoint = [[GetCoordinatePoint alloc] initWithPropertiesTo:self.EndDate.text from:self.startDate.text];
    [CoodinatePoint GetCoordinatePoints:[PassedInfo systemID] DataType:[PassedInfo systemParameter]];
    Dates = CoodinatePoint.CoordinatePoints;
    
    if (Dates.count<=1)
    {
        UIAlertView *Error = [[UIAlertView alloc] initWithTitle:nil message:@"不够信息" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Error show];
    }
    else
    {
        CPTGraph *graph = self.GraphView.hostedGraph;
        [graph reloadData];
    
    
        //scalling plot
        CPTScatterPlot *Scatter =(CPTScatterPlot*)[graph plotAtIndex:0];
        [graph.defaultPlotSpace scaleToFitPlots:[NSArray arrayWithObjects:Scatter, nil]];
    
    
    
        //configuring both axis labels and such
        CPTXYAxisSet *AxisSet = (CPTXYAxisSet *) graph.axisSet;
        CPTXYAxis *xAxis = AxisSet.xAxis;
        CPTXYAxis *yAxis = AxisSet.yAxis;
        [self configureXAxis:xAxis];
        [self configureYAxes:yAxis];
    }
}

- (IBAction)PickerValueChanged:(id)sender
{
    NSDate *EnteredDateFromPicker = [sender date];
    NSDateFormatter *google = [[NSDateFormatter alloc] init];
    
    
    [google setDateFormat:@"yyyy-MM-dd"];
    
    //Entered date retreived
    
    if (EndorStart) {
        //assign date to nsdate
        to=EnteredDateFromPicker;
        self.EndDate.text = [google stringFromDate:EnteredDateFromPicker];
    }
    else
    {
        //assign date to nsdate
        From=EnteredDateFromPicker;
        self.startDate.text = [google stringFromDate:EnteredDateFromPicker];
    }
    
    EnteredDateFromPicker = nil;
    
    
}


-(void) HidePicker
{
    if (!Picker.hidden)
    {
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        // Set the type and if appropriate direction of the transition,
        [animation setType:kCATransitionMoveIn];
        [animation setSubtype:kCATransitionFromBottom];
        // Set the duration and timing function of the transtion -- duration is passed in as a parameter, use ease in/ease out as the timing function
        [animation setDuration:0.5];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [[Picker layer] addAnimation:animation forKey:@"transitionViewAnimation"];
        
        Picker.hidden = true;
        
        [[Picker layer] removeAnimationForKey:@"transitionViewAnimation"];
        animation = nil;
        
    }
    
    //change text color to black
    [self.EndDate setTextColor:[UIColor blackColor]];
    [self.startDate setTextColor:[UIColor blackColor]];
}


@end
