//
//  PushPrimeLogger.h
//  Pods
//
//  Created by PushPrime on 14/02/2017.
//
//

#import <Foundation/Foundation.h>

/**
 * PushPrimeLogger Handles the event loggin of PushPrime SDK.
 */
@interface PushPrimeLogger : NSObject

/**
 * Print a message to console with PushPrime tag.
 * @param string Message to print
 */
+(void)print:(NSString *)string;

/**
 * Log device heartbeat.
 */
+(void)heartbeat;

/**
 * Log notification click event.
 * @param notification Notification clicked by the user.
 */
+(void)trackClick:(PushPrimeNotification *)notification;

/**
 * Log notification delivery event.
 * @param notification Notification received by the user.
 */
+(void)trackDelivery:(PushPrimeNotification *)notification;

@end
