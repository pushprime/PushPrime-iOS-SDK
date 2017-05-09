//
//  PushPrimeAPIClient.h
//  Pods
//
//  Created by PushPrime on 06/10/2016.
//
//

#import <Foundation/Foundation.h>

/**
 * PushPrimeAPIClient handles the basic communication with the PushPrime server. This class was written specifically to talk to PushPrime API and should not be used in parsing other REST based API's.
 */
@interface PushPrimeAPIClient : NSObject {
    NSURLSession *session;
    NSMutableURLRequest *request;
    NSMutableDictionary *parameters;
    NSString *apiKey;
}

/**
 * Creates and returns an api client.
 * @return PushPrimeAPIClient object
 */
+(instancetype)Builder;

/**
 * Sets the API end point for the request.
 * @param endPoint API end point
 * @return PushPrimeAPIClient object
 */
-(instancetype)setEndPoint:(NSString *)endPoint;

/**
 * Sets the asset url to be fetched from a remote location
 * @param endPoint Remote asset end point
 * @return PushPrimeAPIClient object
 */
-(instancetype)setAssetUrl:(NSString *)endPoint;

/**
 * Sets the method to be used for the request. `GET`, `POST`, `PUT` or `DELETE`
 * @param method Method to use for the request.
 * @return PushPrimeAPIClient object
 */
-(instancetype)setMehod:(NSString *)method;

/**
 * Appends parameters to be sent to server.
 * @param key Key in the key value pair of the parameter
 * @param value Value in the key value pair of the parameter.
 * @return PushPrimeAPIClient object
 */
-(instancetype)setParameter:(NSString *)key withValue:(NSString *)value;

/**
 * Sends asynchronous call to server.
 * @param callback Block to execute once the data is received from the server.
 */
-(void)send:(void (^)(id responseObject))callback;

/**
 * Fetch the asset asynchronously.
 * @param callback Block to execute once the asset have been downloaded and saved in the cache.
 */
-(void)fetch:(void (^)(NSURL *cacheUrl))callback;

@end
