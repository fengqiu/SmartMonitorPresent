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
    // post提交的参数，格式如下
    NSString *postParam=nil;
    postParam=[[NSString alloc] initWithFormat:@"User_ID=%@&User_Pwd=%@&IME=9774d56d682e549c",username,password];
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [postParam dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSLog(@"postLength=%@",postLength);

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
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    

    NSError *error= [[NSError alloc] init];
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *resultdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"response data:%@",resultdata);
    parser=[[NSXMLParser alloc] initWithData:urlData];
    parser.delegate=self;
    [parser parse];

    return self.isLogin;
    self.isLogin=NO;
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

/*
 NSString *postParam=nil;
 // postParam=[[NSString alloc] initWithFormat:@"User_ID=%@&User_Pwd=%@&IME=9774d56d682e549c",username,password];
 postParam=[[NSString alloc] initWithFormat:@"theCityName=%@",@"北京"];
 // post提交的参数，格式如下
 // User_ID=string&User_Pwd=string&IME=string
 //NSString *postParam=[NSString stringWithFormat:@"User_ID=%@&User_Pwd=%@&IME=9774d56d682e549c",username,password];
 
 //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
 NSData *postData = [postParam dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
 
 //计算POST提交数据的长度
 NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
 NSLog(@"postLength=%@",postLength);
 
 // NSURL *url=;
 
 //定义NSMutableURLRequest
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 
 //设置提交目的url
 [request setURL:[NSURL URLWithString:@"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx?op=getWeatherbyCityName"]];
 
 //设置提交方式为 POST
 [request setHTTPMethod:@"POST"];
 //设置http-header:Content-Type
 //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 //设置http-header:Content-Length
 [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
 //设置需要post提交的内容
 [request setHTTPBody:postData];
 
 
 //    //[activityIndicator startAnimating];
 //    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
 //    if (conn) {
 //       NSData *webData = [[NSMutableData data] retain];
 //    }
 //
 
 NSError *error= [[NSError alloc] init];
 NSURLResponse *response;
 NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 NSString *resultdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
 NSLog(@"response data:%@",resultdata);
 
 
 
 //    [NSURLConnection connectionWithRequest:request delegate:self ];
 //    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 //    NSString *resultdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
 //    NSLog(@"response data:%@",resultdata);
 
 
 

 //定义
 NSHTTPURLResponse* urlResponse = nil;
 // NSError *error ;
 //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
 NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
 
 NSString *aa=@"11";
 
 //将NSData类型的返回值转换成NSString类型
 NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];


if ([@"true" isEqualToString:resultdata]) {
    return YES;
}
return NO;

 */



@end
