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

@property (nonatomic,strong) User *user;
@property (nonatomic,strong) NSMutableString *currentString;
@property (nonatomic) BOOL isparse;

@end

@implementation GetUser

@synthesize userArray=_userArray;
@synthesize user=_user;
@synthesize currentString=_currentString;
@synthesize isparse=_isparse;

NSXMLParser		*parser;

-(NSMutableArray *) getUserArray
{    
    NSString *weburl;
    if (!weburl) {
        weburl=[[NSString alloc] init];
    }
    weburl=@"";
    //weburl= [NSString  stringWithFormat:@"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName?theCityName=%@",city];
    NSURL *urllocation=[NSURL URLWithString:weburl];
    NSData *data=[[NSData alloc] initWithContentsOfURL:urllocation];
    parser=[[NSXMLParser alloc] initWithData:data];
    parser.delegate=self;
    [parser parse];
    
    weburl=nil;
    data=nil;
    parser=nil;
    
    return  self.userArray;
    
    self.userArray=nil;
}

#pragma mark - NSXMLParserDelegate

// 开始解析到节点
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"NewDataSet"]) {
        self.userArray=[[NSMutableArray alloc] initWithCapacity:50];
        self.user=[[User alloc] init];
        self.currentString=[NSMutableString string];
        [self.currentString setString:@""];
        self.isparse=YES;
    }
    else if ([elementName isEqualToString:@"account"]||[elementName isEqualToString:@"password"])
    {
        self.isparse=YES;
    }
}

// 获取到节点中的字符串
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.isparse) {
        [self.currentString setString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"NewDataSet"]) {        
        self.user=nil;
        self.currentString=nil;
    }
    else if ([elementName isEqualToString:@"account"])
    {
        self.user.username=self.currentString;
    }
    else if ([elementName isEqualToString:@"password"])
    {
        self.user.password=self.currentString;
    }
    else if ([elementName isEqualToString:@"ds"])
    {
        [self.userArray addObject:self.user];
    }
    self.isparse=NO;
}

@end
