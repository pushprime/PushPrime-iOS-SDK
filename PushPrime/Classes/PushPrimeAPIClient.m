//
//  PushPrimeAPIClient.m
//  Pods
//
//  Created by PushPrime on 06/10/2016.
//
//

#import "PushPrime.h"
#import "PushPrimeAPIClient.h"
#import "PushPrimeLogger.h"

@implementation PushPrimeAPIClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        session = [NSURLSession sharedSession];
        request = [[NSMutableURLRequest alloc] init];
        parameters = [[NSMutableDictionary alloc] init];
        apiKey = [[NSBundle mainBundle].infoDictionary valueForKey:@"PushPrimeApiKey"];
        
        [request setValue:apiKey forHTTPHeaderField:@"token"];
    }
    return self;
}

+(instancetype)Builder{
    return [PushPrimeAPIClient new];
}

-(instancetype)setEndPoint:(NSString *)endPoint{
    NSURL *url = [NSURL URLWithString:[@"https://pushprime.com/api" stringByAppendingString:endPoint]];
    request.URL = url;
    return self;
}

-(instancetype)setAssetUrl:(NSString *)endPoint{
    NSURL *url = [NSURL URLWithString:endPoint];
    request.URL = url;
    return self;
}

-(instancetype)setMehod:(NSString *)method{
    [request setHTTPMethod:method];
    return self;
}

-(instancetype)setParameter:(NSString *)key withValue:(NSString *)value{
    [parameters setObject:value forKey:key];
    return self;
}

-(void)send:(void (^)(id responseObject))callback{
    
    NSString *dataString = @"";
    NSString *glue = @"";
    
    for (NSString* key in parameters) {
        NSString *value = [parameters objectForKey:key];
        NSString *escapedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLHostAllowedCharacterSet];
        NSString *escapedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLHostAllowedCharacterSet];
        dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@"%@%@=%@", glue, escapedKey, escapedValue]];
        glue = @"&";
    }
    
    if(dataString.length > 0){
        [request setHTTPBody:[dataString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:true]];
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
#ifdef DEBUG
                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                   [PushPrimeLogger print:responseString];
#endif
                
                   if(callback){
                       if(error == nil){
                           NSError *jsonError;
                           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                           if(jsonError == nil){
                               callback(json);
                           }
                       }
                   }
    }];
    [task resume];
}

-(void)fetch:(void (^)(NSURL *cacheUrl))callback{
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        callback(location);
    }];
    [task resume];
}

@end
