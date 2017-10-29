//
//  JSONBase.m
//  MusicSearch-Framework
//
//  Created by Gaurang Jogi on 28/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import "JSONBase.h"

@interface JSONBase ()
@property (nonatomic,strong,readonly) NSMutableDictionary *data;
@end

@implementation JSONBase

-(instancetype) initWithDictionary:(NSDictionary*)dictionary
{
    if(self=[super init])
    {
        _data = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        return self;
    }
    return nil;
}
-(instancetype) initWithData:(NSData*)data
{
    if(self=[super init])
    {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error!=nil) {
            NSLog(@"Error while reading JSON Data,%@",[error description]);
            return nil;
        }
        _data = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        return self;
    }
    return nil;
}
-(instancetype) initWithString:(NSString*)string
{
    if(self=[super init])
    {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if (error!=nil) {
            NSLog(@"Error while reading JSON string,%@",[error description]);
            return nil;
        }
        _data = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        return self;
    }
    return nil;
}
#pragma mark - Implementation of dynamic Getter and setter to read and write data dictionary
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSString *sel = NSStringFromSelector(selector);
    if ([sel rangeOfString:@"set"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    } else {
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *key = NSStringFromSelector([invocation selector]);
    if ([key rangeOfString:@"set"].location == 0) {
        key = [[key substringWithRange:NSMakeRange(3, [key length]-4)] lowercaseString];
        id obj;
        [invocation getArgument:&obj atIndex:2];
        if(obj!=nil)
        [_data setObject:obj forKey:key];
    } else {
        id obj = [_data objectForKey:key];
        [invocation setReturnValue:&obj];
    }
}


@end
