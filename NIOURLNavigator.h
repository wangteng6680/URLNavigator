//
//  NIOURLNavigator.h
//  NextevCar
//
//  Created by can.chen on 2017/7/14.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIOURLInfo.h"

@interface NIOURLNavigator : NSObject

/**
 Centralized registeration

 @param plistNames plist file that conations NIOURLInfo
 */
+ (void)registerURLObjectWithPlists:(NSArray *)plistNames;

/**
 Centralized registeration

 @param urls NIOURLInfo Array
 */
+ (void)registerURLObjectArray:(NSArray<NIOURLInfo *> *)urls;

/**
 Decentralized registeration.
 Can be used in +load method.

 @param url http or nio url
 */
+ (void)registerURLObject:(NIOURLInfo *)url;

/**
 Returns a Boolean value indicating whether or not the URL can be handled.

 @param url http or nio URL
 @return YES for URL that had registered
 */
+ (BOOL)canHandleURL:(NSString *)url;

/**
 Get a view controller with url that had registered.

 @param url The URL
 @return A view controller or nil if the url is not registered.
 */
+ (UIViewController *)viewControllerForURL:(NSString *)url;

/**
 Navigate to view controller with url that had registered.
 
 @param url The URL
 */
+ (void)openURL:(NSString *)url;

@end
