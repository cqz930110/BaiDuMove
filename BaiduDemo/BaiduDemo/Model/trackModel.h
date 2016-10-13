//
//  _root_.h
//  NewProject
//
//  Created by _author on 16-03-04.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/

#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
#import "trackdata.h"

@interface trackModel : NSObject
{
	NSNumber *_code;
	NSMutableArray *_data;
	NSString *_errmsg;
}


@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, copy) NSString *errmsg;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 