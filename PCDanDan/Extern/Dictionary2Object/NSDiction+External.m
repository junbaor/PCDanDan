//
//  NSDiction+External.m
//  AFNETTEST
//
//  Created by hesh on 13-8-22.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "NSDiction+External.h"
#import <objc/runtime.h>
#import "NSObject+TypeEncode.h"

@implementation NSDictionary(External)

-(id)objectByClass:(Class)clazz
{
    if (clazz == [NSDictionary class]) {
        return [NSDictionary dictionaryWithDictionary:self];
    }else if(clazz == [NSMutableDictionary class]){
        return [NSMutableDictionary dictionaryWithDictionary:self];
    }else if(clazz == [NSString class]){
        return self.description;
    }else if(clazz == [NSMutableString class]){
        return [NSMutableString stringWithString:self.description];
    }else if(clazz == [NSArray class] || clazz == [NSMutableArray class]){
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject * key in self.allKeys) {
            NSString *string = [NSString stringWithFormat:@"%@:%@",key,[self objectForKey:key]];
            [array addObject:string];
        }
        return array;
    }
    __autoreleasing NSObject *object = [[clazz alloc]init];
    NSArray *allkeys = self.allKeys;
    int flag = NO;
    for (NSObject * tkey in allkeys) {
        if ([tkey isKindOfClass:[NSString class]]) {
            NSString *key = (NSString *)tkey;
            objc_property_t protpery_t = class_getProperty(clazz, [key UTF8String]);
            if (protpery_t) {
                id value = [self objectForKey:key];
                if ([value isKindOfClass:[NSArray class]]) {
                    NSString *propertyClass = [NSString stringWithFormat:@"__%@Class",key];
                    SEL sel = NSSelectorFromString(propertyClass);
                    if ([clazz respondsToSelector:sel]) {
                        NSMutableArray *array =  [NSMutableArray array];
                        for (NSObject * cValue in (NSArray *)value) {
                            Class propertyClass = [clazz performSelector:sel];
                            id tvalue = [(NSDictionary *)cValue objectByClass:propertyClass];
                            [array addObject:tvalue];
                        }
                        value = array;
                    }
                }else if ([value isKindOfClass:[NSDictionary class]]) {
                    const char *	attr = property_getAttributes(protpery_t);
                    if ( attr[0] != 'T' ){
                        continue;
                    }
                    const char * type = &attr[1];
                    if ( type[0] == '@' )
                    {
                        if ( type[1] != '"' )
                            continue;
                        char typeClazz[128] = { 0 };
                        const char * mclazz = &type[2];
                        const char * clazzEnd = strchr( mclazz, '"' );
                        if ( clazzEnd && mclazz != clazzEnd )
                        {
                            unsigned int size = (unsigned int)(clazzEnd - mclazz);
                            strncpy( &typeClazz[0], mclazz, size );
                        }
                        if (typeClazz) {
                            Class mclass = NSClassFromString([NSString stringWithUTF8String:typeClazz]);
                            value = [(NSDictionary *)value objectByClass:mclass];
                        }
                    }
                }else{
                    const char *	attr = property_getAttributes(protpery_t);
                    if ( attr[0] != 'T' ){
                        continue;
                    }
                    const char * type = &attr[1];
                    if ( type[0] == '@' )
                    {
                        if ( type[1] != '"' )
                            continue;
                        char typeClazz[128] = { 0 };
                        const char * mclazz = &type[2];
                        const char * clazzEnd = strchr( mclazz, '"' );
                        if ( clazzEnd && mclazz != clazzEnd )
                        {
                            unsigned int size = (unsigned int)(clazzEnd - mclazz);
                            strncpy( &typeClazz[0], mclazz, size );
                        }
                        if (typeClazz) {
                            Class mclass = NSClassFromString([NSString stringWithUTF8String:typeClazz]);
                            value = [(NSObject *)value objectAsBaseClass:mclass];
                        }
                    }
                }
                if (!value || [value isEqual:[NSNull null]]) {
                    continue;
                }
                [object setValue:value forKey:key];
                flag = YES;
            }
        }
    }
    if (flag) {
        return object;
    }
    return NO;
}

@end
