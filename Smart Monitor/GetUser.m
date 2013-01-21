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
    NSURL *url = [NSURL URLWithString:@"http://183.129.206.88:8083/WebService_SmartlLink.asmx"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
            
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
        
    return self.isLogin;
    

    
    /*
    // post提交的参数，格式如下
    NSString *postParam=nil;
    postParam=[[NSString alloc] initWithFormat:@"User_ID=%@&User_Pwd=%@&IME=9774d56d682e549c",username,password];
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [postParam dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //设置提交目的url
    [request setURL:[NSURL URLWithString:@"http://183.129.206.88:8083/WebService_SmartlLink.asmx/Login"]];
    
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
    self.isLogin=NO;
     */
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
