//
//  PushPrimeNotification.m
//  Pods
//
//  Created by PushPrime on 14/02/2017.
//
//

#import "PushPrime.h"
#import "PushPrimeNotification.h"
#import "PushPrimeLogger.h"

@implementation PushPrimeNotification

@synthesize title, body, sound, tag, inAppAlertType, badgeCount, shownToUser, buttonsArray, dataDictionary, isSilent, imageUrl;

-(instancetype)initWithUserInfo:(NSDictionary *)userInfo{
    self = [super init];
    if (self) {
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        NSDictionary *alert = [aps objectForKey:@"alert"];
        NSDictionary *data = [aps objectForKey:@"data"];
        tag = [userInfo objectForKey:@"t"];
        
        if(alert != nil){
            self.title = [alert objectForKey:@"title"];
            if(self.title == nil) self.title = @"";
            
            self.body = [alert objectForKey:@"body"];
            if(self.body == nil) self.body = @"";
            
            if(self.title.length <= 0 || self.body.length <= 0){
                self.isSilent = YES;
            }
        }
        
        if([aps objectForKey:@"badge"] != nil){
            self.badgeCount = [[aps objectForKey:@"badge"] integerValue];
        }
        
        self.sound = [aps objectForKey:@"sound"];
        if(self.sound == nil) self.sound = @"";
        
        if(data != nil){
            if([data objectForKey:@"custom"] != nil){
                self.dataDictionary = [data objectForKey:@"custom"];
            }
            
            if([data objectForKey:@"nbu"] != nil){
                self.buttonsArray = [data objectForKey:@"nbu"];
            }
            
            if([data objectForKey:@"nia"] != nil){
                self.inAppAlertType = [[data objectForKey:@"nia"] integerValue];
            }
            
            if([data objectForKey:@"dt"] != nil){
                self.imageUrl = [data objectForKey:@"dt"];
            }
        }
    }
    return self;
}

-(void)show NS_EXTENSION_UNAVAILABLE_IOS(""){
    if(self.inAppAlertType == 1 && !self.isSilent){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:self.body delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
        if(buttonsArray.count > 0){
            for (NSDictionary *button in buttonsArray) {
                [alert addButtonWithTitle:[button objectForKey:@"t"]];
            }
        }else{
            [alert addButtonWithTitle:@"Ok"];
        }
    
        [alert show];
        self.shownToUser = YES;
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if([PushPrime sharedHandler].notificationClicked != nil) {
        [PushPrime sharedHandler].notificationClicked(self, buttonIndex);
        [PushPrimeLogger trackClick:self];
    }
}

-(NSString *)getCustomData:(NSString *)key defaultValue:(NSString *)value {
    if(self.dataDictionary != nil){
        if([self.dataDictionary objectForKey:key] != nil){
            return [self.dataDictionary objectForKey:key];
        }
    }
    
    return value;
}

-(UNNotificationCategory *)getCategory{
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    int index = 0;
    for (NSDictionary *button in buttonsArray) {
        UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:[NSString stringWithFormat:@"%d", index] title:[button objectForKey:@"t"] options:0];
        [actions addObject:action];
        index++;
    }
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"PUSHPRIME_DEFAULT" actions:actions intentIdentifiers:@[] options:0];
    
    return category;
}

@end
