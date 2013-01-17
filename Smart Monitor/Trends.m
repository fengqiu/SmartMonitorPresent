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

@synthesize GraphView;

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
    [self configureAxes];
    self.GraphView.allowPinchScaling = YES;
    [self configurePlots];
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
    [Graph.plotAreaFrame setPaddingLeft:20.0f];
    [Graph.plotAreaFrame setPaddingRight:15.0f];
    [Graph.plotAreaFrame setPaddingTop:15.0f];
    [Graph.plotAreaFrame setPaddingBottom:20.0f];
    
    
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
    CPTAxisSet *axisSet = Graph.axisSet;
    
    CPTXYAxis* eX = [axisSet.axes objectAtIndex:0];
    eX.title = @"DATE";
    eX.titleOffset = 5.0f;
}




//delegate
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 10;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if (fieldEnum == CPTScatterPlotFieldX)
    {
        return [NSNumber numberWithInteger:index];
    }
    else
        return [NSNumber numberWithInteger:index];
}



@end
