//
//  PushPrimeLogger.m
//  Pods
//
//  Created by PushPrime on 14/02/2017.
//
//

#import "PushPrime.h"
#import "PushPrimeLogger.h"
#import "PushPrimeStorage.h"
#import "PushPrimeAPIClient.h"
#import "PushPrimeNotification.h"

@implementation PushPrimeLogger

+(void)print:(NSString *)string{
    NSLog(@"PushPrime Log - %@", string);
}

+(void)heartbeat{
    if([[PushPrime sharedHandler] isSubscribed]){
        NSDate *date = [NSDate date];
        NSDate *previousDate = [PushPrimeStorage getDateWithKey:PushPrimeLastLogDate andDefaultDate:date];
        NSTimeInterval distanceBetweenDates = [date timeIntervalSinceDate:previousDate];
        double secondsInMinute = 60;
        NSInteger minutesBetween = distanceBetweenDates / secondsInMinute;
        
        if(minutesBetween > 40){
            PushPrimeAPIClient *client = [[[PushPrimeAPIClient Builder] setMehod:@"GET"] setEndPoint:[NSString stringWithFormat:@"/heartbeat/%@", [[PushPrime sharedHandler] getPushPrimeId]]];
            [client send:nil];
            [PushPrimeStorage saveDate:[NSDate date] forKey:PushPrimeLastLogDate];
        }
    }
}

+(void)trackClick:(PushPrimeNotification *)notification{
    NSString *key = [NSString stringWithFormat:@"pptn_%@", notification.tag];
    NSString *trackStatus = [PushPrimeStorage getValueWithKey:key andDefaultValue:@"0"];
    
    if([trackStatus isEqualToString:@"0"]){
        [PushPrimeStorage saveValue:@"1" forKey:key];
        NSString *trackUrl = [NSString stringWithFormat:@"/heartbeat/click/%@/%@", [[PushPrime sharedHandler] getPushPrimeId], notification.tag];
        PushPrimeAPIClient *client = [[[PushPrimeAPIClient Builder] setMehod:@"GET"] setEndPoint:trackUrl];
        [client send:nil];
    }
}

+(void)trackDelivery:(PushPrimeNotification *)notification{
    NSString *key = [NSString stringWithFormat:@"ppdn_%@", notification.tag];
    NSString *trackStatus = [PushPrimeStorage getValueWithKey:key andDefaultValue:@"0"];
    
    if([trackStatus isEqualToString:@"0"]){
        [PushPrimeStorage saveValue:@"1" forKey:key];
        NSString *trackUrl = [NSString stringWithFormat:@"/heartbeat/delivery/%@/%@", [[PushPrime sharedHandler] getPushPrimeId], notification.tag];
        PushPrimeAPIClient *client = [[[PushPrimeAPIClient Builder] setMehod:@"GET"] setEndPoint:trackUrl];
        [client send:nil];
    }

}

@end
