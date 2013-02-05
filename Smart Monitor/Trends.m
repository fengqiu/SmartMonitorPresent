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
    //decides where it "end date" is selected
    bool WhetherEnd;
    
    int minimum;
    int maximum;
}
//configures the graph (title, linestyle ...), used in initplot
-(void)configureGraph;
//retreives data from webservice and scales
-(void)configurePlots;
//configures axes, in initplot
-(void)configureAxes;
//settings of both axis
-(void) xAxisSettings: (CPTXYAxis *) xAxis YAxisSettings: (CPTXYAxis *) yAxis;
//scaling and setting of x and y axis
-(void) configureXAxis : (CPTXYAxis *) xAxis;
-(void) configureYAxes : (CPTXYAxis *) yAxis;
//initial data for the plot, obtains data from webservice
-(void) InitialPlotData;

@end

@implementation Trends

@synthesize GraphView,Dates;
@synthesize Picker;
@synthesize From,to;
@synthesize PassedInfo;
@synthesize btnSearch=_btnSearch;

//**************Graph
-(void)initPlot {
    
    [self configureGraph];
    [self configurePlots];
    //makes sure there is more than 1 point in dates so that we can plot a graph
    [self configureAxes];

        
    //self.GraphView.allowPinchScaling = YES;
    
}

-(void)configureGraph
{
    //instantialise graph view
    CPTGraph *Graph = [[CPTXYGraph alloc] initWithFrame:self.GraphView.bounds];
    self.GraphView.hostedGraph = Graph;
    //applying plain black theme
    //padding area
    [Graph.plotAreaFrame setPaddingLeft:35.0f];
    [Graph.plotAreaFrame setPaddingRight:10.0f];
    [Graph.plotAreaFrame setPaddingTop:5.0f];
    [Graph.plotAreaFrame setPaddingBottom:55.0f];
    
}

-(void)configurePlots
{
    
    //Setting graph as the graph on the host
    CPTGraph *graph = self.GraphView.hostedGraph;
    //setting the plotspace
    CPTXYPlotSpace * plotspace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    
    
    //Scatter Plot trend
    CPTScatterPlot *SmartLinkTrend = [[CPTScatterPlot alloc] init];
    
    // Add the plot symbol.
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.size = CGSizeMake(8.0, 8.0);
    SmartLinkTrend.plotSymbol = plotSymbol;
    
    //setting plot properties
    SmartLinkTrend.dataSource = self;
    SmartLinkTrend.identifier = @"Trends";
    
    //set trend color to blue
    CPTColor *trendColor = [CPTColor whiteColor];
    //adding to the plot
    [graph addPlot:SmartLinkTrend toPlotSpace:plotspace];
    
    //scalling the plotspace, Also calls delegate functions
    if (Dates.count<=1)
    {
        //checks for error
        UIAlertView *Error = [[UIAlertView alloc] initWithTitle:nil message:@"数据不足" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [Error show];
    }
    else
    {
        //disable activity
        //scale plot
        [plotspace scaleToFitPlots:[NSArray arrayWithObjects:SmartLinkTrend, nil]];
    }
    //line style and setting characteristics for it
    CPTMutableLineStyle *smartlinkLines = [SmartLinkTrend.dataLineStyle mutableCopy];
    smartlinkLines.lineWidth = 1;
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
    
    if (Dates.count > 1)
    {
        //configuring X Axis
        [self configureXAxis:xAxis];
        //configuring Y Axis
        [self configureYAxes:yAxis];
    }


}

-(void) xAxisSettings: (CPTXYAxis *) xAxis YAxisSettings: (CPTXYAxis *) yAxis
{
    xAxis.axisLineStyle = nil;
    yAxis.axisLineStyle = nil;
    if (Dates.count > 1)
    {
        //getting minimum value from the quantity in dates
        NSMutableArray *QTY = [[NSMutableArray alloc] initWithCapacity:Dates.count];
        for (CoordinatePoint *date in Dates) {
            NSNumber *quantity = date._quantity;
            [QTY addObject:quantity];
        }
        
        //min and max values
        NSNumber* min = [QTY valueForKeyPath:@"@min.self"];
        NSNumber* Max = [QTY valueForKeyPath:@"@max.self"];
        minimum = [min intValue];
        maximum = [Max intValue];
        //calculate which point to move x Axis to
        float intemediate = maximum - minimum;
        float MoveXtoPoint = [min floatValue] - (maximum-minimum)/10;
        if (intemediate<=10)
        {
            MoveXtoPoint = [min floatValue] - 2;
        }
        //length of Yaxis
        int Ylength = [Max intValue] - [min intValue]+2*([min intValue]-MoveXtoPoint);
        //length of Xaxis
        float a = Dates.count;
        a=a/10;
        CGFloat Xlength = Dates.count;
        //shift axis up
        xAxis.orthogonalCoordinateDecimal = CPTDecimalFromInt(MoveXtoPoint);
        
        //setting pointer to plotspace
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) GraphView.hostedGraph.defaultPlotSpace;
        //scalling Yrange
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(MoveXtoPoint) length:CPTDecimalFromInt(Ylength)];
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-a) length:CPTDecimalFromFloat(Xlength+a)];
    }
    
    //axis tick things
    yAxis.majorTickLength = 0.0f;
    yAxis.minorTickLength = 0.0f;
    xAxis.majorTickLength = 0.0f;
    xAxis.minorTickLength = 0.0f;
}

//method to configure X Axis
-(void) configureXAxis : (CPTXYAxis *) xAxis
{

    //label style
    CPTMutableTextStyle *labelStyle = [CPTMutableTextStyle textStyle];
    labelStyle.color = [CPTColor whiteColor];
    labelStyle.fontName = @"Noteworthy-Bold";
    labelStyle.fontSize = 10.0f;
    
    xAxis.title = @"日期";
    xAxis.titleTextStyle = labelStyle;
    
    
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
    
    //creating labels
    int i=0;
    
 
    
    for (CoordinatePoint *Point in Dates)
    {
    
        NSDateFormatter *Formatter = [[NSDateFormatter alloc]init];
        [Formatter setDateFormat:@"dd"];
        
        NSString *strDate =[[NSString alloc] initWithString:[Formatter stringFromDate:Point.SystemDate]];
        
        //making the label for x axis
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:strDate textStyle:labelStyle];
        //setting label properties
        
        NSNumber *locationOfTick = [NSNumber numberWithFloat:i];
        label.offset = 5.0f;
        //location where each label is places
        label.tickLocation = [locationOfTick decimalValue];
        [xLabels addObject:label];
        [Locations addObject:locationOfTick];
        i++;
        
    }
    
    //putting labels on graph
    xAxis.axisLabels = xLabels;
    xAxis.majorTickLocations = Locations;
}



//method to configure Y Axis
-(void) configureYAxes : (CPTXYAxis *) yAxis
{
    //labelstyle
    CPTMutableTextStyle *labelStyle = [CPTMutableTextStyle textStyle];
    labelStyle.color = [CPTColor whiteColor];
    labelStyle.fontName = @"Helvetica-Bold";
    labelStyle.fontSize = 10.0f;
    
    yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //creating data label arrays
    NSMutableSet *Data = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    NSMutableSet *Locations = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    //creating grid lines
    CPTMutableLineStyle *GridLineStyle = [[CPTMutableLineStyle alloc] init];
    GridLineStyle.lineColor = [CPTColor blueColor];
    GridLineStyle.lineWidth = 0.5f;
    yAxis.majorGridLineStyle = GridLineStyle;
    float addition = 1;
    int maxMinusMin = maximum-minimum;
    
    if ((maximum-minimum) >= 20) {
        float intermediate = maxMinusMin/10.0f;
        addition = intermediate * 2.5f;
    }
    //location of major tick
    for (int i=0; i<(maximum-minimum+1); i++)
    {
        //CoordinatePoint *point = [Dates objectAtIndex:i];
        int scalefactor = (i*addition);
        NSNumber *locationOfTick = [[NSNumber alloc] initWithInt:(minimum+scalefactor)];
        
        //display the value at Quantity
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i",[locationOfTick intValue]] textStyle:labelStyle];
        
        
        //label properties
        
        label.offset = 4.0f;
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
//*************Initiate/ Init
-(void) InitialPlotData
{
    //date formatter to convert date from string
   NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    [Formatter setDateFormat:@"yyyy-MM-dd"];
    //obtain nsdate from info passed from previous screen
    NSDate *NewestDate = [Formatter dateFromString:[PassedInfo systemDate]];
    //rewind 7 days
    NSDate *SevenDaysPrior = [[NSDate alloc] initWithTimeInterval:-604800 sinceDate:NewestDate];
    
    //NewestDate = [NewestDate dateByAddingTimeInterval:86400];
    //set end and start dates
    self.startDate.text = [Formatter stringFromDate:SevenDaysPrior];
    self.EndDate.text = [Formatter stringFromDate:NewestDate];
    //obtain data from webservice by initializing an object of "GetCoordinatePoint"
    GetCoordinatePoint *CoodinatePoint = [[GetCoordinatePoint alloc] initWithPropertiesTo:self.EndDate.text from:self.startDate.text];
    //start activity indicator
    [self.activity startAnimating];
    [CoodinatePoint GetCoordinatePoints:[PassedInfo systemID] DataType:[PassedInfo systemParameter]];
    //setting the dates variable
    //CoordinatePoint *fake = [[CoordinatePoint alloc] initWithQuantity:@"280" systemDate:@"2013-02-05"];
    Dates = CoodinatePoint.CoordinatePoints;
    //[Dates addObject:fake];
    
    //sorting coordinate point with respect to ns date object
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"SystemDate"
                                                                     ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [Dates sortedArrayUsingDescriptors:sortDescriptors];
    Dates =(NSMutableArray*) sortedEventArray;
    
    //stop activity
    [self.activity stopAnimating];
}

-(void) initEverything
{
    //button Text Font and Style
    self.btnSearch.titleLabel.font=[UIFont fontWithName:@"宋体" size:6.0];
    self.btnSearch.titleLabel.font=[self.btnSearch.titleLabel.font fontWithSize:17.0];
    
    //setting background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"DarkBlue.jpg"]];
    self.view.backgroundColor = background;
    
    // 设置 navigationBar内容  style
    int height = self.navigationController.navigationBar.frame.size.height;
    int width = self.navigationController.navigationBar.frame.size.width;
    //setting navlabel to height of navigation bar item
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    //setting properties of navLabel
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    navLabel.text=self.PassedInfo.ParameterID;
    [navLabel setFont:[UIFont fontWithName:@"宋体" size:35.0]];
    navLabel.font=[navLabel.font fontWithSize:20];
    navLabel.backgroundColor=[UIColor clearColor];
    navLabel.textAlignment= NSTextAlignmentCenter;
    //setting the title as navlabel
    self.navigationItem.titleView = navLabel;
    
    //initialising importan properties
    Dates = [[NSMutableArray alloc] init];
    From = [[NSDate alloc] init];
    to = [[NSDate alloc] init];
    //call initialplotdata method so that we have the newest data plotted
    [self InitialPlotData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    //setting max date for Date picker
    self.Picker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0];
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

//**********delegates
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return Dates.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{

    
    //if y axis
    if (fieldEnum == CPTScatterPlotFieldY)
    {
        
        //set point as Quantity given by webservice
        CoordinatePoint *point =[Dates objectAtIndex:index];
        NSNumber *quantity = point._quantity;
        return quantity;
    }
    //if x axis
    else
    {
        //set as index
        return [NSNumber numberWithInteger:index];
    }
}

//******User Interface
- (IBAction)DateEntry:(id)sender
{
    //call hide picker method when a date entry button is clicked
    [self HidePicker];
    //if picker is hidden
    if (Picker.hidden)
    {
        //perform animation
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        // Set the type and if appropriate direction of the transition,
        [animation setType:kCATransitionMoveIn];
        [animation setSubtype:kCATransitionFromTop];
        // Set the duration and timing function of the transtion -- duration is passed in as a parameter, use ease in/ease out as the timing function
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [[Picker layer] addAnimation:animation forKey:@"transitionViewAnimation"];
        //set picker to visible
        Picker.hidden = FALSE;
        
        [[Picker layer] removeAnimationForKey:@"transitionViewAnimation"];
        animation = nil;
    }
    //if end date was pushed
    if ([sender tag]==1)
    {
        //set whetherend to true
        WhetherEnd = true;
        //set the maximum date of picker
        [Picker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        [self.EndDate setTextColor:[UIColor grayColor]];
    }
    else if ([sender tag] == 2)
    {
        //set whether end to false, used in PickerValueChanged method
        WhetherEnd = false;
        //set maximum date to 7 days prior
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *endDate = [formatter dateFromString:self.EndDate.text];
        [Picker setMaximumDate:[NSDate dateWithTimeInterval:-172800 sinceDate:endDate]];
        //visual stimulus
        [self.startDate setTextColor:[UIColor grayColor]];
    }
}
//search button is pushed
- (IBAction)plot:(id)sender
{
    //hide picker
    [self HidePicker];
    //start activity indicator
    [self.activity startAnimating];
    //download from webservice by initialising "GetCoordinatePoint" Object
    GetCoordinatePoint *CoodinatePoint = [[GetCoordinatePoint alloc] initWithPropertiesTo:self.EndDate.text from:self.startDate.text];
    [CoodinatePoint GetCoordinatePoints:[PassedInfo systemID] DataType:[PassedInfo systemParameter]];
    Dates = CoodinatePoint.CoordinatePoints;
    //if there is less than 1 piece of data report an error
    [self.activity stopAnimating];
    
    if (Dates.count<=1)
    {
        UIAlertView *Error = [[UIAlertView alloc] initWithTitle:nil message:@"数据不足" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [Error show];
    }
    //else reload the data of the graph and plot it
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
        [self xAxisSettings:xAxis YAxisSettings:yAxis];
        //stops annimation
        [self.activity stopAnimating];
    }
}
//once picker value has been changed
- (IBAction)PickerValueChanged:(id)sender
{
    //convert to a date
    NSDate *EnteredDateFromPicker = [sender date];
    NSDateFormatter *google = [[NSDateFormatter alloc] init];
    [google setDateFormat:@"yyyy-MM-dd"];
    //store date in labels
    //Entered date retreived
    if (WhetherEnd) {
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

//hides the DatePicker
-(void) HidePicker
{
    //if the picker is not hidden
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
        //perform animation and hide picker
        Picker.hidden = true;
        [[Picker layer] removeAnimationForKey:@"transitionViewAnimation"];
        animation = nil;
        
    }
    
    //change text color to black
    [self.EndDate setTextColor:[UIColor whiteColor]];
    [self.startDate setTextColor:[UIColor whiteColor]];
}

@end
