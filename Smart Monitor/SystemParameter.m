//
//  SystemParameter.m
//  Smart Monitor
//
//  Created by user on 13-1-16.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "SystemParameter.h"

@implementation SystemParameter

@synthesize systemID=_systemID;
@synthesize systemParameter=_systemParameter;
@synthesize systemDate=_systemDate;
@synthesize quantity=_quantity;

// 初始化方法
-(id)initWithSystemID:(NSString *)systemID systemParameter:(NSString *)systemParameter systemDate:(NSString *)systemDate quantity:(NSString *)quantity
{
    if ((self=[super init])) {
        self.systemID=systemID;
        self.systemParameter=systemParameter;
        self.systemDate=systemDate;
        self.quantity=quantity;
    }
    return self;
}

@end
