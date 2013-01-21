//
//  GetSystem.m
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "GetSystem.h"
#import "System.h"

@interface GetSystem()

@property (nonatomic,strong) System *system;
@property (nonatomic,strong) NSString *currentString;
@property (nonatomic) BOOL isparse;

@end

@implementation GetSystem

@synthesize systemArray=_systemArray;
@synthesize system=_system;
@synthesize currentString=_currentString;
@synthesize isparse=_isparse;

NSXMLParser	*parser;

-(NSMutableArray *)getSystemArray:(NSString *)username
{
    NSString *soapMessage = [NSString stringWithFormat:                             
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                             "<soap12:Body>\n"
                             "<GetSysList xmlns=\"http://tempuri.org/\">"
                             "<account>%@</account>"                             
                             "</GetSysList>"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>",username];
    
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
    //NSLog(@"response data:%@",resultdata);
    
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

    return self.systemArray;
}

#pragma mark - NSXMLParserDelegate

// 开始解析到节点
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // 当获取到整个DataSet的开始节点
    if ([elementName isEqualToString:@"NewDataSet"]) {
        // 初始化属性
        if (!self.systemArray) {
             self.systemArray=[[NSMutableArray alloc] initWithCapacity:50];
        }
        self.system=[[System alloc] init];
        self.currentString=[[NSString alloc] init];
        self.currentString=@"";
    }
    else if ([elementName isEqualToString:@"ds"])
    {
        if (!self.system) {
            self.system=[[System alloc] init];
        }
    }
    // 当碰到需要的数据的节点
    else if ([elementName isEqualToString:@"id"]||[elementName isEqualToString:@"name"]||[elementName isEqualToString:@"desc"])
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
        self.system=nil;
        self.currentString=nil;
    }
    else if ([elementName isEqualToString:@"id"])
    {
        self.system.systemID=self.currentString;
    }
    else if ([elementName isEqualToString:@"name"])
    {
        self.system.systemName=self.currentString;
    }
    else if ([elementName isEqualToString:@"desc"])
    {
        self.system.systemDesc=self.currentString;
    }
    else if ([elementName isEqualToString:@"ds"])
    {
        [self.systemArray addObject:self.system];
        self.system=nil;
    }
    self.isparse=NO;
}

@end
