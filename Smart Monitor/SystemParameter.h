//
//  SystemParameter.h
//  Smart Monitor
//
//  Created by user on 13-1-16.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemParameter : NSObject

// 属性分别有 系统id 系统参数类型 统计数量 统计的日期
@property (nonatomic, strong) NSString *systemID;
@property (nonatomic, strong) NSString *systemParameterType;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *systemDate;

// 初始化方法
-(id)initWithSystemID:(NSString *)systemID systemParameterType:(NSString *)systemParameterType quantity:(NSString *)quantity systemDate:(NSString *)systemDate;

@end
