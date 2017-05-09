//
//  PushPrimeStorage.m
//  Pods
//
//  Created by PushPrime on 14/02/2017.
//
//

#import "PushPrimeStorage.h"

@implementation PushPrimeStorage

+(void)saveValue:(NSString *)value forKey:(NSString *)key{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:value forKey:key];
    [prefs synchronize];
}

+(NSString *)getValueWithKey:(NSString *)key andDefaultValue:(NSString *)value{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *fetchedValue = [prefs stringForKey:key];
    if(fetchedValue != nil)
        return fetchedValue;
    
    return value;
}

+(void)saveDate:(NSDate *)value forKey:(NSString *)key{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:value forKey:key];
    [prefs synchronize];
}

+(NSDate *)getDateWithKey:(NSString *)key andDefaultDate:(NSDate *)date{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDate *fetchedValue = [prefs objectForKey:key];
    if(fetchedValue != nil)
        return fetchedValue;
    
    return date;
}


@end
