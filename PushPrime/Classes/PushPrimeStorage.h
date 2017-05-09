//
//  PushPrimeStorage.h
//  Pods
//
//  Created by PushPrime on 14/02/2017.
//
//

#import <Foundation/Foundation.h>

@interface PushPrimeStorage : NSObject

+(void)saveValue:(NSString *)value forKey:(NSString *)key;
+(NSString *)getValueWithKey:(NSString *)key andDefaultValue:(NSString *)value;
+(void)saveDate:(NSDate *)value forKey:(NSString *)key;
+(NSDate *)getDateWithKey:(NSString *)key andDefaultDate:(NSDate *)date;

@end
