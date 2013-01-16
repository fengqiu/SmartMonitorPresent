//
//  System.h
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface System : NSObject

// 属性分别有 系统id 系统名称 系统描述 系统账号 系统密码
@property (nonatomic, strong) NSString *systemID;
@property (nonatomic, strong) NSString *systemName;
@property (nonatomic, strong) NSString *systemDesc;

// 初始化方法
-(id)initWithSystemID:(NSString *)systemID systemName:(NSString *)systemName systemDesc:(NSString *)systemDesc;

@end
