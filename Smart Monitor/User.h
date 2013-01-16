//
//  User.h
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) id detailItem;

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;

// 初始化方法
-(id)initWithUsername:(NSString *)username password:(NSString *)password;

@end
