//
//  NSObject+TypeEncode.m
//  AFNETTEST
//
//  Created by hesh on 13-8-23.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "NSObject+TypeEncode.h"
#import <objc/runtime.h>

#define DATEFORMAT_DEFAULT @"yyyy-MM-dd HH:mm:ss"

@implementation NSString (TypeEncode)

-(NSString *)asString;{
    return [NSString stringWithString:self];
}

-(NSNumber *)asNumber;{
    NSString *regEx = @"^-?\\d+.?\\d?";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    BOOL isMatch            = [pred evaluateWithObject:self];
    if (isMatch) {
        const char *_char =  [self UTF8String];
        return [NSNumber numberWithChar:*_char];
    }
    return nil;
}

-(int)asInteger;{
    NSNumber *number = [self asNumber];
    return [number asInteger];
}

-(long)asLong;{
    NSNumber *number = [self asNumber];
    return [number asLong];
}

-(double)asDouble;{
    NSNumber *number = [self asNumber];
    return [number asDouble];
}

-(float)asFloat;{
    NSNumber *number = [self asNumber];
    return [number asFloat];
}

-(NSDate *)asDate;{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:DATEFORMAT_DEFAULT];
    return [formatter dateFromString:self];
}

-(NSData *)asData;{
    return [self dataUsingEncoding: NSASCIIStringEncoding];
}

@end

@implementation NSNumber (TypeEncode)

-(NSString *)asString;{
    return self.description;
}

-(NSNumber *)asNumber;{
    return self;
}

-(int)asInteger;{
    return (int)self.integerValue;
}

-(long)asLong;{
    return self.longValue;
}

-(double)asDouble;{
    return self.doubleValue;
}

-(float)asFloat;{
    return self.floatValue;
}

-(NSDate *)asDate;{
    double time = self.doubleValue;
    return [NSDate dateWithTimeIntervalSince1970:time];
}

-(NSData *)asData;{
    NSString *string = [self asString];
    return [string dataUsingEncoding: NSASCIIStringEncoding];
}

@end

@implementation NSObject (TypeEncode)

-(NSString *)asString;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asString];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asString];
    }
    return self.description;
}

-(NSNumber *)asNumber;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asNumber];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asNumber];
    }
    return nil;
}

-(int)asInteger;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asInteger];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asInteger];
    }
    return 0;
}

-(long)asLong;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asLong];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asLong];
    }
    return 0;
}

-(double)asDouble;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asDouble];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asDouble];
    }
    return 0.0;
}

-(float)asFloat;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asFloat];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asFloat];
    }
    return 0.0f;
}

-(NSDate *)asDate;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asDate];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asDate];
    }
    return nil;
}

-(NSData *)asData;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asData];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asData];
    }
    return nil;
}

-(id)objectAsBaseClass:(Class)class;{
    if ([self isMemberOfClass:class]) {
        return self;
    }else if(class == [NSString class]){
        return [self asString];
    }else if(class == [NSNumber class]){
        return [self asNumber];
    }else if(class == [NSData class]){
        return [self asData];
    }else if(class == [NSDate class]){
        return [self asDate];
    }
    return [NSNull null];
}

-(NSValue *)objectAsTypeCode:(char)typecode;{
    if ( typecode == _C_INT || typecode == _C_UINT || typecode == _C_BOOL || typecode == _C_SHT || typecode == _C_BFLD)
    {
        int vaule = [self asInteger];
        return  [NSValue value:&vaule withObjCType:&typecode];
    }
    else if ( typecode == _C_ULNG || typecode == _C_LNG || typecode == _C_ULNG || typecode == _C_LNG_LNG )
    {
        long value =[self asLong];
        return  [NSValue value:&value withObjCType:&typecode];
    }
    else if ( typecode == _C_DBL)
    {
        double value = [self asDouble];
        return  [NSValue value:&value withObjCType:&typecode];
    }
    else if ( typecode == _C_FLT)
    {
        double value = [self asFloat];
        return  [NSValue value:&value withObjCType:&typecode];
    }
    return nil;
}

@end
