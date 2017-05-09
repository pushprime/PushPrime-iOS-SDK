//
//  NotificationPermissionHandler.m
//  Soulgap
//
//  Created by Billa Ustad on 29/09/2014.
//  Copyright (c) 2014 Architact Inc. All rights reserved.
//

#import "PushPrimePermissionHandler.h"

@implementation PushPrimePermissionHandler
#ifdef __IPHONE_8_0
static const UIUserNotificationType USER_NOTIFICATION_TYPES_REQUIRED = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
#endif
static const UIRemoteNotificationType REMOTE_NOTIFICATION_TYPES_REQUIRED = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;

+ (void)checkPermissions NS_EXTENSION_UNAVAILABLE_IOS("")
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }else{
        bool isIOS8OrGreater = [[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)];
        if (!isIOS8OrGreater)
        {
            [PushPrimePermissionHandler iOS7AndBelowPermissions];
            return;
        }
    
        [PushPrimePermissionHandler iOS8AndAbovePermissions];
    }
}

+ (void)iOS7AndBelowPermissions NS_EXTENSION_UNAVAILABLE_IOS("")
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:REMOTE_NOTIFICATION_TYPES_REQUIRED];
}

+ (void)iOS8AndAbovePermissions NS_EXTENSION_UNAVAILABLE_IOS("")
{
    if ([PushPrimePermissionHandler canSendNotifications])
    {
        //return;
    }
#ifdef __IPHONE_8_0
    UIUserNotificationSettings* requestedSettings = [UIUserNotificationSettings settingsForTypes:USER_NOTIFICATION_TYPES_REQUIRED categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:requestedSettings];
#endif
}

+ (bool)canSendNotifications NS_EXTENSION_UNAVAILABLE_IOS("")
{
    UIApplication *application = [UIApplication sharedApplication];
    bool isIOS8OrGreater = [application respondsToSelector:@selector(currentUserNotificationSettings)];
    
    if (!isIOS8OrGreater)
    {
        // We actually just don't know if we can, no way to tell programmatically before iOS8
        return true;
    }
#ifdef __IPHONE_8_0
    UIUserNotificationSettings* notificationSettings = [application currentUserNotificationSettings];
    bool canSendNotifications = notificationSettings.types == USER_NOTIFICATION_TYPES_REQUIRED;
    
    return canSendNotifications;
#endif
    return true;
}

@end
