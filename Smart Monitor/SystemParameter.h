//
//  SystemParameter.h
//  Smart Monitor
//
//  Created by user on 13-1-16.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemParameter : NSObject

// 属性分别有 系统id 系统参数 系统日期 系统统计数 
@property (nonatomic, strong) NSString *systemID;
@property (nonatomic, strong) NSString *ParameterID;
@property (nonatomic, strong) NSString *systemParameter;
@property (nonatomic, strong) NSString *systemDate;
@property (nonatomic, strong) NSString *quantity;

// 初始化方法
-(id)initWithSystemID:(NSString *)systemID systemParameter:(NSString *)systemParameter systemDate:(NSString *)systemDate quantity:(NSString *)quantity ParameterID:(NSString *) Parameter;

@end
