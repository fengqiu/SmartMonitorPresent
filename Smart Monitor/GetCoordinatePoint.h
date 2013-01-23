//
//  GetCoordinatePoint.h
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinatePoint.h"

@interface GetCoordinatePoint : NSObject<NSXMLParserDelegate>
{
    CoordinatePoint *Coordinates;
    NSString *year;
    NSString *month;
    NSString *day;
    NSString *Quantity;
    NSString *Type;
    int isparse;
}

@property (strong , nonatomic) NSMutableArray *CoordinatePoints;
@property (strong , nonatomic) NSString* DateTo;
@property (strong , nonatomic) NSString* DateFrom;

-(void) GetCoordinatePoints:(NSString *) SystemID DataType:(NSString *) type;
-(id) initWithPropertiesTo:(NSString *)to from:(NSString*) From;

@end
