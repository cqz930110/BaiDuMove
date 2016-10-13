//
//  data.h
//  NewProject
//
//  Created by _author on 16-03-04.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface trackdata : NSObject
{
	NSNumber *_carId;
	NSNumber *_heading;
	NSNumber *_lat;
	NSNumber *_latR;
	NSNumber *_lon;
	NSNumber *_lonR;
	NSNumber *_ptType;
	NSString *_satelliteTime;
	NSString *_satelliteTimeStr;
	NSNumber *_sourceType;
	NSNumber *_speed;
}


@property (nonatomic, copy) NSNumber *carId;
@property (nonatomic, copy) NSNumber *heading;
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSNumber *latR;
@property (nonatomic, copy) NSNumber *lon;
@property (nonatomic, copy) NSNumber *lonR;
@property (nonatomic, copy) NSNumber *ptType;
@property (nonatomic, copy) NSString *satelliteTime;
@property (nonatomic, copy) NSString *satelliteTimeStr;
@property (nonatomic, copy) NSNumber *sourceType;
@property (nonatomic, copy) NSNumber *speed;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 