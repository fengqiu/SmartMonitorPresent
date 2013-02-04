//
//  GetSystemParameter.m
//  Smart Monitor
//
//  Created by user on 13-1-16.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "GetSystemParameter.h"
#import "SystemParameter.h"

@interface GetSystemParameter()

@property (nonatomic,strong) SystemParameter *systemParameter;
@property (nonatomic,strong) NSString *currentString;
@property (nonatomic,strong) NSMutableString *datestring;
@property (nonatomic) BOOL isparse;

@end

@implementation GetSystemParameter

@synthesize systemParameterArray=_systemParameterArray;
@synthesize systemParameter=_systemParameter;
@synthesize currentString=_currentString;
@synthesize isparse=_isparse;
@synthesize datestring=_datestring;

NSXMLParser	*parser;

-(NSMutableArray *)getSystemParameterArray:(NSString *)systemID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                             "<soap12:Body>\n"
                             "<GetSysDataList xmlns=\"http://tempuri.org/\">"
                             "<sys_id>%@</sys_id>"
                             "</GetSysDataList>"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>",systemID];
    
    //请求发送到的路径
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    NSURL *weburl = [NSURL URLWithString:@"http://183.129.206.88:8083/WebService_SmartlLink.asmx"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:weburl];
    
    //以下对请求信息添加属性前四句是必有的，
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: @"http://tempuri.org/GetSysList" forHTTPHeaderField:@"SOAPAction"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"urlRequest %@",urlRequest);
    
    //请求
    NSError *error= [[NSError alloc] init];
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *resultdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    // NSLog(@"response data:%@",resultdata);
        
    parser=[[NSXMLParser alloc] initWithData:urlData];
    parser.delegate=self;
    [parser parse];
    
    // 释放内存
    soapMessage=nil;
    msgLength=nil;
    weburl=nil;
    error=nil;
    urlRequest=nil;
    response=nil;
    urlData=nil;
    resultdata=nil;
    parser=nil;
    
    return self.systemParameterArray;
}

#pragma mark - NSXMLParserDelegate

// 开始解析到节点
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // 当获取到整个DataSet的开始节点
    if ([elementName isEqualToString:@"NewDataSet"]) {
        // 初始化属性
        self.systemParameterArray=[[NSMutableArray alloc] initWithCapacity:50];
        self.systemParameter=[[SystemParameter alloc] init];
        self.currentString=[[NSString alloc] init];
        self.currentString=@"";
    }
    else if ([elementName isEqualToString:@"ds"])
    {
        if (!self.systemParameter) {
            self.systemParameter=[[SystemParameter alloc] init];
        }
        if (!self.datestring) {
            self.datestring=[[NSMutableString alloc] init];
            [self.datestring setString:@""];
        }
    }
    // 当碰到需要的数据的节点
    else if ([elementName isEqualToString:@"id"]||[elementName isEqualToString:@"sys_id"]||[elementName isEqualToString:@"type"]||[elementName isEqualToString:@"Year"]||[elementName isEqualToString:@"Month"]||[elementName isEqualToString:@"Day"]||[elementName isEqualToString:@"qty"]||[elementName isEqualToString:@"value"])
    {
        // 设置是否需要解析的参数为正确
        self.isparse=YES;
    }
}

// 获取到节点中的字符串
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // 如果允许解析 则储存节点的数据
    if (self.isparse) {
        self.currentString =string;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // 当获取到整个DataSet的结束节点
    if ([elementName isEqualToString:@"NewDataSet"]) {
        self.systemParameter=nil;
        self.currentString=nil;
    }
    else if ([elementName isEqualToString:@"sys_id"])
    {
        self.systemParameter.systemID=self.currentString;
    }
    else if ([elementName isEqualToString:@"type"])
    {
        self.systemParameter.systemParameter=self.currentString;
        // NSLog(@"currentstring: %@",self.currentString);
    }
    else if ([elementName isEqualToString:@"value"])
    {
        self.systemParameter.ParameterID = self.currentString;
    }
    else if ([elementName isEqualToString:@"Year"]||[elementName isEqualToString:@"Month"])
    {
        //NSLog(@"currentstring: %@",self.currentString);
        [self.datestring appendString:self.currentString];
        [self.datestring appendString:@"-"];
        //NSLog(@"date: %@",(NSString *)self.datestring);
    }
    else if ([elementName isEqualToString:@"Day"])
    {        
        [self.datestring appendString:self.currentString];
        self.systemParameter.systemDate=(NSString *)self.datestring;

        //NSLog(@"date: %@",self.systemParameter.systemDate);
    }
//    else if ([elementName isEqualToString:@"date"])
//    {
//        [self.datestring  stringByAppendingString:@"/"];
//        self.systemParameter.systemDate=self.currentString;
//    }
    else if ([elementName isEqualToString:@"qty"])
    {
        self.systemParameter.quantity=self.currentString;
    }
    else if ([elementName isEqualToString:@"ds"])
    {
        [self.systemParameterArray addObject:self.systemParameter];
        self.systemParameter=nil;
        self.datestring=nil;
    }
    self.isparse=NO;
}

@end
