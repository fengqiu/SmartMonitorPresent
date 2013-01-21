//
//  Trends.m
//  Smart Monitor
//
//  Created by Adam dong on 16/01/13.
//  Copyright (c) 2013 Service-Indeed. All rights reserved.
//

#import "Trends.h"

@interface Trends ()

@end

@implementation Trends

@synthesize GraphView,Dates;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    Dates = [[NSMutableArray alloc] init];
    NSDate *today = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    for (int i=0; i<10; i++)
    {
        [Dates addObject:today];
    }
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

-(void)initPlot {
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    self.GraphView.allowPinchScaling = YES;
    
}


-(void)configureGraph {
    //instantialise graph view
    CPTGraph *Graph = [[CPTXYGraph alloc] initWithFrame:self.GraphView.bounds];
    self.GraphView.hostedGraph = Graph;
    //applying plain black theme
    [Graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    Graph.title = @"SMARTLINKS 曲线";
    //setting Text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    //setting title to white
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    //setting graph attributes
    Graph.titleTextStyle = titleStyle;
    Graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    Graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    //padding area
    [Graph.plotAreaFrame setPaddingLeft:30.0f];
    [Graph.plotAreaFrame setPaddingRight:15.0f];
    [Graph.plotAreaFrame setPaddingTop:15.0f];
    [Graph.plotAreaFrame setPaddingBottom:70.0f];
        
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
    
    //scalling the plotspace
    [plotspace scaleToFitPlots:[NSArray arrayWithObjects:SmartLinkTrend, nil]];
    
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
    //configuring X Axis
    [self configureXAxis:xAxis];
    //configuring Y Axis
    [self configureYAxes:yAxis];
}

//method to configure X Axis
-(void) configureXAxis : (CPTXYAxis *) xAxis
{
    //a line style
    CPTMutableTextStyle *labelStyle = [CPTMutableTextStyle textStyle];
    labelStyle.color = [CPTColor blackColor];
    labelStyle.fontName = @"Helvetica-Bold";
    labelStyle.fontSize = 10.0f;
    
    CPTXYPlotSpace *Host = (CPTXYPlotSpace *) GraphView.hostedGraph.defaultPlotSpace;
    
    //x axis label stuff
    CPTAxisTitle *xTitle = [[CPTAxisTitle alloc] initWithText:@"日期" textStyle:xAxis.labelTextStyle];
    xAxis.axisTitle = xTitle;
    
    xAxis.titleOffset = 50.0f;
    
    xAxis.majorTickLength = 5.0f;
    xAxis.minorTickLength = 0.0f;
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //fake data and locations
    NSMutableSet *xLabels = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    NSMutableSet *Locations = [[NSMutableSet alloc] initWithCapacity:Dates.count];

    //length of axis
    CGFloat length;
    length = CPTDecimalCGFloatValue(Host.xRange.length);
    length = length/Dates.count;
    
    //initialising a formatter
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    [Formatter setDateFormat:@"yy-MM-dd"];
    int i=0;
    for (NSDate *date in Dates)
    {
        NSString *strDate = [[NSString alloc] initWithString:[Formatter stringFromDate:date]];
        
        //making the label for x axis
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:strDate textStyle:labelStyle];
        label.rotation = 1.57f;
        NSNumber *locationOfTick = [NSNumber numberWithFloat:(length + length *i)];
        label.offset = 1.0f;
        
        label.tickLocation = [locationOfTick decimalValue];
        [xLabels addObject:label];
        [Locations addObject:locationOfTick];
        i++;
    }
    xAxis.axisLabels = xLabels;
    xAxis.majorTickLocations = Locations;

}

//method to configure Y Axis
-(void) configureYAxes : (CPTXYAxis *) yAxis
{
    CPTXYPlotSpace *Host =(CPTXYPlotSpace *) GraphView.hostedGraph.defaultPlotSpace;
    
    
    //Axes Settings
    //setting axis title
    CPTAxisTitle *yAxisTitle = [[CPTAxisTitle alloc] initWithText:@"数量" textStyle: yAxis.labelTextStyle];
    yAxisTitle.rotation = 1.57f;
    yAxis.axisTitle = yAxisTitle;
    yAxis.titleOffset = 10.0f;
    
    
    //axis tick things
    yAxis.majorTickLength = 5.0f;
    yAxis.minorTickLength = 0.0f;
    yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    

    //create fake data
    NSMutableSet *FakeData = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    NSMutableSet *Locations = [[NSMutableSet alloc] initWithCapacity:Dates.count];
    
    //location of major tick
    CGFloat length;
    length = CPTDecimalCGFloatValue(Host.yRange.length);
    length = length/Dates.count;
    
    for (int i=0; i<Dates.count; i++) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", i] textStyle:yAxis.labelTextStyle];
        
        
        NSNumber *locationOfTick = [NSNumber numberWithFloat:(length + length *i)];
        
        label.offset = 4.0f;
        
        label.tickLocation = [locationOfTick decimalValue];
        [FakeData addObject:label];
        [Locations addObject:locationOfTick];
        
    }
    yAxis.axisLabels = FakeData;
    yAxis.majorTickLocations = Locations;
    
}


//delegate
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return Dates.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if (fieldEnum == CPTScatterPlotFieldY)
    {
        if (index %2) {
        return [NSNumber numberWithInteger:index*index];
        }
        else
        {
            return [NSNumber numberWithInteger:index];
        }
    }
    else
        return [NSNumber numberWithInteger:index];
}



@end
