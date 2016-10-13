//
//  data.m
//  NewProject
//
//  Created by _author on 16-03-04.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "trackdata.h"
#import "DTApiBaseBean.h"


@implementation trackdata

@synthesize carId = _carId;
@synthesize heading = _heading;
@synthesize lat = _lat;
@synthesize latR = _latR;
@synthesize lon = _lon;
@synthesize lonR = _lonR;
@synthesize ptType = _ptType;
@synthesize satelliteTime = _satelliteTime;
@synthesize satelliteTimeStr = _satelliteTimeStr;
@synthesize sourceType = _sourceType;
@synthesize speed = _speed;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_NUMBER(carId, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(heading, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(lat, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(latR, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(lon, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(lonR, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(ptType, @"0");
		DTAPI_DICT_ASSIGN_STRING(satelliteTime, @"");
		DTAPI_DICT_ASSIGN_STRING(satelliteTimeStr, @"");
		DTAPI_DICT_ASSIGN_NUMBER(sourceType, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(speed, @"0");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(carId);
	DTAPI_DICT_EXPORT_BASICTYPE(heading);
	DTAPI_DICT_EXPORT_BASICTYPE(lat);
	DTAPI_DICT_EXPORT_BASICTYPE(latR);
	DTAPI_DICT_EXPORT_BASICTYPE(lon);
	DTAPI_DICT_EXPORT_BASICTYPE(lonR);
	DTAPI_DICT_EXPORT_BASICTYPE(ptType);
	DTAPI_DICT_EXPORT_BASICTYPE(satelliteTime);
	DTAPI_DICT_EXPORT_BASICTYPE(satelliteTimeStr);
	DTAPI_DICT_EXPORT_BASICTYPE(sourceType);
	DTAPI_DICT_EXPORT_BASICTYPE(speed);
    return md;
}
@end
