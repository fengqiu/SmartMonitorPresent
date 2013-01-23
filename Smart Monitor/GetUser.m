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
    NSString *soapMessage = [NSString stringWithFormat:
                             
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                             "<soap12:Body>\n"
                             "<GetUser xmlns=\"http://tempuri.org/\">"
                             "<account>%@</account>"
                             "<password>%@</password>"
                             "</GetUser>"                             
                             "</soap12:Body>\n"
                             "</soap12:Envelope>",username,password];
    
    //请求发送到的路径
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    NSURL *weburl = [NSURL URLWithString:@"http://183.129.206.88:8083/WebService_SmartlLink.asmx"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:weburl];
            
    //以下对请求信息添加属性前四句是必有的，
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: @"http://tempuri.org/GetUser" forHTTPHeaderField:@"SOAPAction"];
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
    
    return self.isLogin;
}

#pragma mark - NSXMLParserDelegate

// 开始解析到节点
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetUserResult"]) {  
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
    if ([elementName isEqualToString:@"GetUserResult"]) {
        self.isparse=NO;
    }
}

@end
