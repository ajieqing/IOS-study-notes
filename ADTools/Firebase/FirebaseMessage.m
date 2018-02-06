//
//  FirebaseMessage.m
//  StyleInstaBox
//
//  Created by 阿杰 on 2018/1/25.
//  Copyright © 2018年 bw. All rights reserved.
//
#import "FirebaseMessage.h"
static FirebaseMessage* manager;

@implementation FirebaseMessage
+(FirebaseMessage*)manager{
    if (!manager) {
//        [FIRApp configure];
        manager = [[FirebaseMessage alloc]init];
    }
    return manager;
}

-(void)configureWithApplication:(UIApplication * )application andAppDelegate:(UIResponder <UIApplicationDelegate,FIRMessagingDelegate,UNUserNotificationCenterDelegate> *) appDelegate{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = appDelegate;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    [FIRMessaging messaging].delegate = appDelegate;
    [application registerForRemoteNotifications];
}

@end
