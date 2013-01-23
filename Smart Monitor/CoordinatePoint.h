//
//  CoordinatePoint.h
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinatePoint : NSObject

// 属性分别有 统计数量 统计的日期
@property (nonatomic, strong) NSNumber *_quantity;
@property (nonatomic, strong) NSString *_systemDate;

// 初始化方法
-(id)initWithQuantity:(NSString *)quantity systemDate:(NSString *)systemDate;

@end
