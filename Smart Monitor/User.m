//
//  User.m
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username=_username;
@synthesize password=_password;

// 对象初始化方法
-(id)initWithUsername:(NSString *)username password:(NSString *)password
{
    if ((self=[super init])) {
        self.username=username;
        self.password=password;
    }
    return self;
}

@end
