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

-(void) GetCoordinatePoints:(NSString*) SystemID DataType:(NSString *) type
{
    
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
    NSString *soapMessageLength = [NSString stringWithFormat:@"%d",[soapMessage length]];
     NSURL *weburl = [NSURL URLWithString:@"http://183.129.206.88:8083/WebService_SmartlLink.asmx"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:weburl];
    
    
    
    
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: @"http://tempuri.org/GetDiagramData"forHTTPHeaderField:@"SOAPAction"];
    [urlRequest addValue: soapMessageLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    Type = [[NSString alloc] initWithString:type];
    
    NSError *error= [[NSError alloc] init];
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *resultdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"response data:%@",resultdata);
    
    //parser
    NSXMLParser* parser=[[NSXMLParser alloc] initWithData:urlData];
    parser.delegate=self;
    [parser parse];
    
}






-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"qty"]&& isparse==4) {
        if (!Coordinates)
        {
            Coordinates = [[CoordinatePoint alloc] initWithQuantity:Quantity systemDate:[NSString stringWithFormat:@"%@-%@-%@",year,month,day]];
            [CoordinatePoints addObject:Coordinates];
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
    switch (isparse) {
        case 1:
            year=string;
            break;
        case 2:
            month=string;
            break;
        case 3:
            day=string;
            break;
        case 4:
            Quantity= string;
            break;
        default:
            break;
    }
}




-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
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
