//
//  GetCoordinatePoint.m
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "GetCoordinatePoint.h"

@implementation GetCoordinatePoint
@synthesize  CoordinatePoints,DateFrom,DateTo;


//initialise with the proporties and return self
-(id)initWithPropertiesTo:(NSString *)to from:(NSString *)From
{
    if (self=[super init])
    {
        CoordinatePoints = [[NSMutableArray alloc] init];
        DateFrom = From;
        DateTo = to;
    }
    return self;
}
//method to retrieve data from webservice
-(void) GetCoordinatePoints:(NSString*) SystemID DataType:(NSString *) type
{
    //inputting soap message
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=  \"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                            "<soap12:Body>\n"
                            "<GetDiagramData xmlns=\"http://tempuri.org/\">"
                            "<sys_id>%@</sys_id>"
                            "<type>%@</type>"
                            "<date_from>%@</date_from>"
                            "<date_to>%@</date_to>"
                            "</GetDiagramData>"
                            "</soap12:Body>\n"
                            "</soap12:Envelope>",SystemID,type,DateFrom,DateTo];
    //the soap message length as a string
    NSString *soapMessageLength = [NSString stringWithFormat:@"%d",[soapMessage length]];
    //url which the webservice exists on
     NSURL *weburl = [NSURL URLWithString:@"http://183.129.206.88:8083/WebService_SmartlLink.asmx"];
    //request url
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:weburl];
    
    
    
    //url request parameters
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: @"http://tempuri.org/GetDiagramData"forHTTPHeaderField:@"SOAPAction"];
    [urlRequest addValue: soapMessageLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSError *error= [[NSError alloc] init];
    NSURLResponse *response;
    //get the url data
    NSData *urlData=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

    
    //initialise the property, "Type"
    Type = [[NSString alloc] initWithString:type];
    
    //parser
    NSXMLParser* parser=[[NSXMLParser alloc] initWithData:urlData];
    parser.delegate=self;
    [parser parse];
    
}






-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //only when the element name is qty (quantity) and also the isparse variable is 4 does the program add an object to the coordinates points array
    if ([elementName isEqualToString:@"qty"]&& isparse==4) {
        if (!Coordinates)
        {
            //initialise the objects with the correct information
            Coordinates = [[CoordinatePoint alloc] initWithQuantity:Quantity systemDate:[NSString stringWithFormat:@"%@-%@-%@",year,month,day]];
            //add object to coordinatepoint
            [CoordinatePoints addObject:Coordinates];
            //nilling everything so it may be used later (not necessary)
            Coordinates=nil;
            year=nil;
            month=nil;
            day=nil;
            Quantity=nil;
        }
    }
}




-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //switching between different situations(cases)
    switch (isparse) {
        case 1:
            //we are reading year
            year=string;
            break;
        case 2:
            //we are reading month
            month=string;
            break;
        case 3:
            //we are reading day
            day=string;
            break;
        case 4:
            //we are reeading quantity
            Quantity= string;
            break;
        default:
            break;
    }
}




-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //element name is read and isparse is set
    if ([elementName isEqualToString:@"Year"]) {
        year = [[NSString alloc] init];
        isparse = 1;
    }
    else if ([elementName isEqualToString:@"Month"])
    {
        month = [[NSString alloc]init];
        isparse = 2;
    }
    else if ([elementName isEqualToString:@"Day"])
    {
        day = [[NSString alloc] init];
        isparse =3;
    }
    else if ([elementName isEqualToString:@"qty"])
    {
        Quantity = [[NSString alloc] init];
        isparse = 4;
    }
    else
    {
        isparse = 5;
    }
}
@end
