//
//  CoordinatePoint.m
//  Smartlink-Monitor
//
//  Created by user on 13-1-11.
//  Copyright (c) 2013年 Service-Indeed. All rights reserved.
//

#import "CoordinatePoint.h"

@implementation CoordinatePoint

@synthesize _systemDate,_quantity;

-(id)initWithQuantity:(NSString *)quantity systemDate:(NSString *)systemDate
{
    if ((self=[super init]))
    {
        _quantity = [[NSNumber alloc]init];
        _systemDate = [[NSString alloc] init];

        _systemDate=systemDate;
        //convert to nsnumber type to be used later
        _quantity= [NSNumber numberWithInt:[quantity intValue]];
    }
    return self;
}

@end
