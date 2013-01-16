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
    NSString *weburl;
    if (!weburl) {
        weburl=[[NSString alloc] init];
    }
    weburl=@"";
    //weburl= [NSString  stringWithFormat:@"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName?theCityName=%@",username];
    NSURL *urllocation=[NSURL URLWithString:weburl];
    NSData *data=[[NSData alloc] initWithContentsOfURL:urllocation];
    parser=[[NSXMLParser alloc] initWithData:data];
    parser.delegate=self;
    [parser parse];
    
    weburl=nil;
    data=nil;
    parser=nil;
    
    return  self.systemArray;
    
    self.systemArray=nil;
}

#pragma mark - NSXMLParserDelegate

// 开始解析到节点
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // 当获取到整个DataSet的开始节点
    if ([elementName isEqualToString:@"NewDataSet"]) {
        // 初始化属性
        self.systemArray=[[NSMutableArray alloc] initWithCapacity:50];
        self.system=[[System alloc] init];
        self.currentString=[[NSString alloc] init];
        self.currentString=@"";
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
    }
    self.isparse=NO;
}

@end
