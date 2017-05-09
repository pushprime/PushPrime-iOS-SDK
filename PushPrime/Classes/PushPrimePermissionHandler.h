//
//  NotificationPermissionHandler.h
//  Soulgap
//
//  Created by Billa Ustad on 29/09/2014.
//  Copyright (c) 2014 Architact Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface PushPrimePermissionHandler : NSObject
+ (void)checkPermissions;
+ (bool)canSendNotifications;
@end
