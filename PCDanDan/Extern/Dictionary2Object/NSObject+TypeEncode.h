//
//  NSObject+TypeEncode.h
//  AFNETTEST
//
//  Created by hesh on 13-8-23.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TypeEncode)

-(NSString *)asString;
-(NSNumber *)asNumber;
-(int)asInteger;
-(long)asLong;
-(double)asDouble;
-(float)asFloat;
-(NSDate *)asDate;
-(NSData *)asData;

@end

@interface NSNumber (TypeEncode)

-(NSString *)asString;
-(NSNumber *)asNumber;
-(int)asInteger;
-(long)asLong;
-(double)asDouble;
-(float)asFloat;
-(NSDate *)asDate;
-(NSData *)asData;

@end

@interface NSObject (TypeEncode)

-(NSString *)asString;
-(NSNumber *)asNumber;
-(int)asInteger;
-(long)asLong;
-(double)asDouble;
-(float)asFloat;
-(NSDate *)asDate;
-(NSData *)asData;

-(id)objectAsBaseClass:(Class)class;

-(NSValue *)objectAsTypeCode:(char)typecode;

@end
