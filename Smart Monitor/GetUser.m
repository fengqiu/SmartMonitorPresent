//
//  GetUser.m
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "GetUser.h"
#import "User.h"

@interface GetUser()

@property (nonatomic) BOOL isparse;
@property (nonatomic) BOOL isLogin;

@end

@implementation GetUser

@synthesize isparse=_isparse;
@synthesize isLogin=_isLogin;

NSXMLParser		*parser;

-(BOOL)checkUser:(NSString *)username password:(NSString *)password;
{
    // A post请求服务
    // post提交的参数，格式如下
    NSString *postParam=nil;
    postParam=[[NSString alloc] initWithFormat:@"User_ID=%@&User_Pwd=%@&IME=9774d56d682e549c",username,password];
    
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
    // NSString *resultdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    // NSLog(@"response data:%@",resultdata);
    
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
    
    return self.isLogin;
}

#pragma mark - NSXMLParserDelegate

// 开始解析到节点
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"string"]) {  
        self.isparse=YES;
    }
}

// 获取到节点中的字符串
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //监控返回  boolean
    if (self.isparse) {
        if ([@"true" isEqualToString:string]) {
            self.isLogin=YES;
        }
        else
        {
            self.isLogin=NO;
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    if ([elementName isEqualToString:@"string"]) {
//    }
    self.isparse=NO;
}

@end
