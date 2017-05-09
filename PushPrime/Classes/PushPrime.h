//
//  PushPrime.h
//  Pods
//
//  Created by PushPrime on 06/10/2016.
//
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "PushPrimeNotification.h"

#define PushPrimeId @"PushPrimeId"
#define PushPrimeDeviceToken @"PushPrimeDeviceToken"
#define PushPrimeLastLogDate @"PushPrimeLastLogDate"

/**
 * `PushPrime` is responsible for handling the core features of this sdk. This class is an abstraction layer over the PushPrime service and makes it easy to integrate your iOS application with PushPrime.
 *  This class should neither be instanciated nor subclassed instead the sharedHandler static method should be used to obtain a reference to underlying global object.
 */
@interface PushPrime : NSObject
{
    PushPrimeNotification *notification;
    
    NSString *segmentId;
    
    NSString *customData;
}

/**
 * @abstract Notification Received block.
 * @discussion This block is executed everytime a notification is received by the application. Please note that this block doesn't execute if a notification is not silent.
 * @param notification `PushPrimeNotification` object representing the received notification.
 */
@property (nonatomic, copy) void (^notificationReceived) (PushPrimeNotification *notification);

/**
 * @abstract Notification clicked block.
 * @discussion This block is executed everytime a notification is clicked by the user. This block is not executed if application is completely terminated and user clicks on one of the action buttons. In that case you have to implement
 * @param notification `PushPrimeNotification` object representing the clicked notification.
 * @param buttonClicked The index of the action button clicked, if user clicked on the notification itself, buttonClicked will be -1.
 */
@property (nonatomic, copy) void (^notificationClicked) (PushPrimeNotification *notification, int buttonClicked);

/**
 * Creates and returns global `PushPrime` object.
 */
+ (instancetype) sharedHandler;

/**
 * Initialises the opt-in process. If user has not granted permission to send notificaiton, they will be prompted for the permission after this call.
 */
- (void) bootOptIn;

/**
 * Should be called from the didFinishLaunchingWithOptions method of your AppDelegate class. This method should be implemented in order to properly track the notifications received when application is in background.
 * @param application UIApplication object
 * @param launchOptions A dictionary containing launch options
 */
- (void) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 * Should be called from the applicationDidBecomeActive method of your AppDelegate class. This method should be implemented in order to properly track users for reminder or notification based on user activity. 
 * @param application UIApplication object
 */
- (void) applicationDidBecomeActive:(UIApplication *)application;

/**
 * Should be called from the didRegisterForRemoteNotificationsWithDeviceToken method of your AppDelegate class. This method should be implemented in order to properly register/track push notification tokens from APNS.
 * @param application UIApplication object
 * @param deviceToken NSData object containing APNS token
 */
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/**
 * Should be called from the didFailToRegisterForRemoteNotificationsWithError method of your AppDelegate class.
 * @param application UIApplication object
 * @param error NSError object containing the reason for registration failure
 */
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

/**
 * Should be called from the didReceiveRemoteNotification method of your AppDelegate class. This method should be implemented in order to properly parse, track and handling of the incoming notifications.
 * @param application UIApplication object
 * @param userInfo Dictionary containing the notification payload
 * @param completionHandler Block to be executed for silent notifications.
 * @return A `PushPrimeNotification` object is returned which can be used to perform operation based on the notification. Please note that in case of silent notifications received while the app is not running, this is the only method which will be called and not the `notificationClicked` block.
 * @warning Please make sure to call `completionHandler()` block for silent notifications.
 */
- (PushPrimeNotification *) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 * Should be called from the handleActionWithIdentifier method of your AppDelegate class. This method should be implemented in order to properly parse, track and handling of the action button clicks on notification buttons.
 * @param application UIApplication object
 * @param identifier Identifier for the button clicked
 * @param userInfo Dictionary containing the notification payload
 * @param clickedHandler Block to be executed after the notification has been parsed. Parameters for the block are same as the notification clicked block.
 */
- (void) application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)(PushPrimeNotification *notification, int buttonClicked))clickedHandler;

+ (void)didReceiveNotificationWithBestAttempt:(UNMutableNotificationContent *)bestAttemptContent withContentHandler:(void (^)(UNMutableNotificationContent * _Nonnull))contentHandler;

/**
 * Adds the current user to the specified segment.
 * @param segmentId Numeric id of the segment
 */
- (void) setUserSegment:(NSString *_Nonnull)segmentId;

/**
 * Removes current user to the specified segment.
 * @param segmentId Numeric id of the segment
 */
- (void) removeUserSegment:(NSString *_Nonnull)segmentId;

/**
 * Saves custom data for the current user.
 * @param data NSDictionary containing the user data.
 * @discussion It is recommened that you include a numeric id in the dictionary to properly track users in your PushPrime dashboard.
 */
- (void) setCustomData:(NSDictionary *_Nonnull)data;

/**
 * Returns whether the current user is subscribed for notifications or note.
 * @return Boolean true if user is subscribed for notifications, false if user is not subscribed.
 */
- (BOOL) isSubscribed;

/**
 * Returns PushPrime Id for the current user.
 * @return Returns a unique NSString containing PushPrime Id for the current user.
 */
- (NSString *_Nonnull)getPushPrimeId;


@end
