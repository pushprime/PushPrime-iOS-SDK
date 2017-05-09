//
//  PushPrimeNotification.h
//  Pods
//
//  Created by PushPrime on 14/02/2017.
//
//

#import <Foundation/Foundation.h>

/**
 * This class represents a notification sent from the PushPrime.
 */
@interface PushPrimeNotification : NSObject <UIAlertViewDelegate>

/**
 * Title of the notification.
 */
@property(nonatomic, retain) NSString *title;

/**
 * Message of the notification.
 */
@property(nonatomic, retain) NSString *body;

/**
 * Name of the sound file to play when notification is received.
 * @discussion Please specify the complete name of the sound file (including extension). The sound file should already exist in the application bundle.
 */
@property(nonatomic, retain) NSString *sound;

/**
 * An array containing the action buttons
 */
@property(nonatomic, retain) NSArray *buttonsArray;

/**
 * A dictionary containing the custom data specified in the notification.
 */
@property(nonatomic, retain) NSDictionary *dataDictionary;

/**
 * Thumbnail Image url.
 */
@property(nonatomic, retain) NSString *imageUrl;

@property(nonatomic, retain) NSString *tag;

/**
 * Badge count to set on the application icon on home screen.
 */
@property(nonatomic, assign) int badgeCount;

/**
 * In app alert type.
 * @discussion Possible values are 0 for nothing or 1 for Alert.
 */
@property(nonatomic, assign) int inAppAlertType;

/**
 * Boolean value specifying wether or not the application is shown to user.
 */
@property(nonatomic, assign) BOOL shownToUser;

/**
 * Boolean value specifying if the notification is silent or not.
 */
@property(nonatomic, assign) BOOL isSilent;

/**
 * @abstract Designated initializer.
 * @param userInfo Dictionary containing the notification data
 * @return PushPrimeNotification object
 */
-(instancetype)initWithUserInfo:(NSDictionary *)userInfo;

/**
 * Can be used to fetch individual values from the custom data included in the notification payload.
 * @param key The key to get data against.
 * @param value Default value to return if the key is missing or is null.
 * @return NSString containing the data.
 */
-(NSString *)getCustomData:(NSString *)key defaultValue:(NSString *)value;

/**
 * Show notification to the user.
 */
-(void)show;

/**
 * Get the UNNotificationCategory object containing the action buttons specified in the notification
 * @return UNNotificationCategory object containing action buttons
 */
-(UNNotificationCategory *)getCategory;

@end
