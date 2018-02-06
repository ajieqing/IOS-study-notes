//
//  FirebaseMessage.h
//  StyleInstaBox
//
//  Created by 阿杰 on 2018/1/25.
//  Copyright © 2018年 bw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Firebase.h"
#import <UserNotifications/UserNotifications.h>
@interface FirebaseMessage : NSObject
+(FirebaseMessage*)manager;
-(void)configureWithApplication:(UIApplication * )application andAppDelegate:(UIResponder <UIApplicationDelegate,FIRMessagingDelegate,UNUserNotificationCenterDelegate> *) appDelegate;
@end
