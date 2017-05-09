//
//  PushPrime.m
//  Pods
//
//  Created by PushPrime on 06/10/2016.
//
//

#import "PushPrime.h"
#import "PushPrimePermissionHandler.h"
#import "PushPrimeNotification.h"
#import "PushPrimeAPIClient.h"
#import "PushPrimeStorage.h"
#import "PushPrimeLogger.h"

@implementation PushPrime

@synthesize notificationReceived, notificationClicked;

static PushPrime *sharedHandler = nil;

+(instancetype)sharedHandler{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    return sharedHandler;
}

-(void)bootOptIn{
    [PushPrimePermissionHandler checkPermissions];
}

-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSDictionary *openerNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (openerNotification) {
        notification = [[PushPrimeNotification alloc] initWithUserInfo:openerNotification];
        notification.shownToUser = YES;
        if(notificationClicked != nil) {
            notificationClicked(notification, -1);
            [PushPrimeLogger trackClick:notification];
        }
    }
    
    if([self isSubscribed]){
        [self bootOptIn];
    }
    
    [PushPrimeLogger heartbeat];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    [PushPrimeLogger heartbeat];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *existinToken = [PushPrimeStorage getValueWithKey:PushPrimeId andDefaultValue:@""];
    if([existinToken isEqualToString:newToken]){
        return;
    }
    
    [PushPrimeLogger print:@"Token Updated, Sending to server"];
    
    PushPrimeAPIClient *client = [[[PushPrimeAPIClient Builder] setMehod:@"POST"] setEndPoint:@"/register"];
    [client setParameter:@"endpoint" withValue:newToken];
    [client setParameter:@"t" withValue:@"ios"];
    if([self isSubscribed]){
        [client setParameter:@"pi" withValue:[self getPushPrimeId]];
    }
    
    if(segmentId != nil) {
        [client setParameter:@"s" withValue:segmentId];
    }
    
    if(customData != nil) {
        [client setParameter:@"c" withValue:customData];
    }
    
#if DEBUG
    [client setParameter:@"d" withValue:@"1"];
#else
    [client setParameter:@"d" withValue:@"0"];
#endif
    
    [client send:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"]){
            [PushPrimeStorage saveValue:[responseObject objectForKey:@"t"] forKey:PushPrimeId];
            [PushPrimeStorage saveValue:newToken forKey:PushPrimeDeviceToken];
        }
    }];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    //TODO
}

- (PushPrimeNotification *) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    notification = [[PushPrimeNotification alloc] initWithUserInfo:userInfo];
    if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground){
        notification.shownToUser = YES;
        if(notificationClicked != nil) {
            notificationClicked(notification, 0);
            [PushPrimeLogger trackClick:notification];
        }
    } else {
        [notification show];
        if(self.notificationReceived != nil){
            self.notificationReceived(notification);
            [PushPrimeLogger trackDelivery:notification];
        }
    }
    
    return notification;
}

- (void) application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)(PushPrimeNotification *notification, int buttonClicked))clickedHandler {
    PushPrimeNotification *clickedNotification = [[PushPrimeNotification alloc] initWithUserInfo:userInfo];
    clickedNotification.shownToUser = YES;
    
    int clickedButton = -1;
    for (int i = 0; i < clickedNotification.buttonsArray.count; i++) {
        if([[NSString stringWithFormat:@"%d", i] isEqualToString:identifier]){
            clickedButton = i;
            break;
        }
    }
    
    [PushPrimeLogger trackClick:clickedNotification];
    
    if(clickedHandler){
        clickedHandler(clickedNotification, clickedButton);
    }
}

- (void) setUserSegment:(NSString *)segmentId{
    if([self isSubscribed]){
        PushPrimeAPIClient *client = [[[PushPrimeAPIClient Builder] setMehod:@"POST"] setEndPoint:@"/setSegment"];
        [client setParameter:@"t" withValue:[self getPushPrimeId]];
        [client setParameter:@"s" withValue:segmentId];
        [client send:nil];
    } else {
        self->segmentId = segmentId;
    }
}

- (void) removeUserSegment:(NSString *)segmentId{
    if([self isSubscribed]){
        PushPrimeAPIClient *client = [[[PushPrimeAPIClient Builder] setMehod:@"POST"] setEndPoint:@"/removeSegment"];
        [client setParameter:@"t" withValue:[self getPushPrimeId]];
        [client setParameter:@"s" withValue:segmentId];
        [client send:nil];
    }
}

- (void) setCustomData:(NSDictionary *)data{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:0
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if(jsonData){
        if([self isSubscribed]){
            PushPrimeAPIClient *client = [[[PushPrimeAPIClient Builder] setMehod:@"POST"] setEndPoint:@"/customData"];
            [client setParameter:@"t" withValue:[self getPushPrimeId]];
            [client setParameter:@"c" withValue:jsonString];
            [client send:nil];
        } else {
            self->customData = jsonString;
        }
    }
}

-(BOOL)isSubscribed{
    return ![[self getPushPrimeId] isEqualToString:@"0"];
}

-(NSString *)getPushPrimeId{
    return [PushPrimeStorage getValueWithKey:PushPrimeId andDefaultValue:@"0"];
}


+ (void)didReceiveNotificationWithBestAttempt:(UNMutableNotificationContent *)bestAttemptContent withContentHandler:(void (^)(UNMutableNotificationContent * _Nonnull))contentHandler{
    
    PushPrimeNotification *notification = [[PushPrimeNotification alloc] initWithUserInfo:bestAttemptContent.userInfo];
    
    [PushPrimeLogger trackDelivery:notification];
    
    if(notification.buttonsArray != nil){
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
            
            NSMutableSet *mutableCategories = [NSMutableSet setWithSet:categories];
            [mutableCategories addObject:[notification getCategory]];
            
            bestAttemptContent.categoryIdentifier = @"PUSHPRIME_DEFAULT";
            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:mutableCategories];

        }];
    }
    
    if(notification.imageUrl != nil){
        NSString *attachment = notification.imageUrl;
        NSURL *attachmentUrl = [NSURL URLWithString:attachment];
    
        [[[[PushPrimeAPIClient Builder] setMehod:@"GET"] setAssetUrl:attachment] fetch:^(NSURL *cacheUrl) {
            NSString *temporaryDirectory = NSTemporaryDirectory();
            NSURL *tempUrl = [NSURL fileURLWithPath:[temporaryDirectory stringByAppendingString:attachmentUrl.lastPathComponent]];
        
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtURL:tempUrl error:nil];
            [[NSFileManager defaultManager] copyItemAtURL:cacheUrl toURL:tempUrl error:&error];
            if(error == nil){
                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentUrl.lastPathComponent URL:tempUrl options:nil error:&error];
        
                if(error == nil){
                    bestAttemptContent.attachments = @[attachment];
                }
            }
        
            contentHandler(bestAttemptContent);
        }];
    }
}

@end
