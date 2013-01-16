//
//  System.m
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "System.h"

@implementation System

@synthesize systemID=_systemID;
@synthesize systemName=_systemName;
@synthesize systemDesc=_systemDesc;

-(id)initWithSystemID:(NSString *)systemID systemName:(NSString *)systemName systemDesc:(NSString *)systemDesc 
{
    if ((self=[super init])) {
        self.systemID=systemID;
        self.systemName=systemName;
        self.systemDesc=systemDesc;
    }
    return self;
}

@end
