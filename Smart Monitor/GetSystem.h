//
//  GetSystem.h
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetSystem : NSObject<NSXMLParserDelegate>

@property (nonatomic,strong) NSMutableArray *systemArray;

-(NSMutableArray *)getSystemArray:(NSString *)username;

@end
