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
    //coordinatepoint object to store information
    CoordinatePoint *Coordinates;
    //information from webservice
    NSString *year;
    NSString *month;
    NSString *day;
    NSString *Quantity;
    NSString *Type;
    //a selector
    int isparse;
}
//array to store all coordinate point objects
@property (strong , nonatomic) NSMutableArray *CoordinatePoints;
//dates which we enter to webservice
@property (strong , nonatomic) NSString* DateTo;
@property (strong , nonatomic) NSString* DateFrom;
//method to getthedata
-(void) GetCoordinatePoints:(NSString *) SystemID DataType:(NSString *) type;
//initialising the getCoordinatePoint Object with appropiate to and from parameters
-(id) initWithPropertiesTo:(NSString *)to from:(NSString*) From;

@end
