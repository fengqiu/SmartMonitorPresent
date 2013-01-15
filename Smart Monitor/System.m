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
@synthesize systemAccount=_systemAccount;
@synthesize systemPwd=_systemPwd;

-(id)initWithSystemID:(NSString *)systemID systemName:(NSString *)systemName systemDesc:(NSString *)systemDesc systemAccount:(NSString *)systemAccount systemPWd:(NSString *)systemPwd
{
    if ((self=[super init])) {
        self.systemID=systemID;
        self.systemName=systemName;
        self.systemDesc=systemDesc;
        self.systemAccount=systemAccount;
        self.systemPwd=systemPwd;
    }
    return self;
}

@end
