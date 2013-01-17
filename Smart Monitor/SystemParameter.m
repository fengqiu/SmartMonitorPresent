//
//  SystemParameter.m
//  Smart Monitor
//
//  Created by user on 13-1-16.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "SystemParameter.h"

@implementation SystemParameter

-(id)initWithSystemID:(NSString *)systemID systemParameterType:(NSString *)systemParameterType quantity:(NSString *)quantity systemDate:(NSString *)systemDate
{
    if ((self=[super init])) {
        self.systemID=systemID;
        self.systemParameterType=systemParameterType;
        self.quantity=quantity;
        self.systemDate=systemDate;
    }
    return  self;
}

@end
