//
//  _root_.m
//  NewProject
//
//  Created by _author on 16-03-04.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "trackModel.h"
#import "DTApiBaseBean.h"


@implementation trackModel

@synthesize code = _code;
@synthesize data = _data;
@synthesize errmsg = _errmsg;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_NUMBER(code, @"0");
		self.data = [DTApiBaseBean arrayForKey:@"data" inDictionary:dict withClass:[trackdata class]];
		DTAPI_DICT_ASSIGN_STRING(errmsg, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(code);
	DTAPI_DICT_EXPORT_ARRAY_BEAN(data);
	DTAPI_DICT_EXPORT_BASICTYPE(errmsg);
    return md;
}
@end
