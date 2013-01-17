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
    // A post请求服务
    // post提交的参数，格式如下
    NSString *postParam=nil;
    postParam=[[NSString alloc] initWithFormat:@"User_ID=%@&User_Pwd=&IME=9774d56d682e549c",username];
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [postParam dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //设置提交目的url
    [request setURL:[NSURL URLWithString:@"http://180.166.19.26:8088/WebServices/StockWebService.asmx/Login"]];
    
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:[NSString stringWithFormat:@"%d",[postData length]] forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    // B 获取返回xml数据
    NSError *error= [[NSError alloc] init];
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // C 解析xml数据
    parser=[[NSXMLParser alloc] initWithData:urlData];
    parser.delegate=self;
    [parser parse];
    
    // 释放内存
    postParam=nil;
    postData=nil;
    request=nil;
    error=nil;
    response=nil;
    urlData=nil;
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
