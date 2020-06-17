//
//  NIOURLInfo.h
//  NextevCar
//
//  Created by can.chen on 2017/7/14.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CCURLNavigationMode) {
    CCURLNavigationModeNone = 0,
    CCURLNavigationModePush,    //push a viewController in NavigationController
    CCURLNavigationModePresent, //present a viewController in NavigationController
    CCURLNavigationModeShare,   //pop to the viewController already in NavigationController or tabBarController
    CCURLNavigationModePresentNotInNav, //present a viewController only, not in NavigationController
    CCURLNavigationModePresentNotInNavNoAnimated, //present a viewController only, not in NavigationController, No animation

};

@interface NIOURLInfo : NSObject

/*
 instantiate logic
 
 1. only class exit
 1.1 instantiateWithURLInfo
 1.2 new
 2. only (sbName && sbID) exist
 2.1 instantiateViewControllerWithIdentifier
 3. class and (sbName && sbID) are all exist
 3.1 instantiateWithURLInfo
 3.2 instantiateViewControllerWithIdentifier
 */

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *urlKey;
@property (nonatomic, strong) NSDictionary *keyMap;

@property (nonatomic, copy) NSString *bundlePath;
@property (nonatomic, copy) NSString *sbName;
@property (nonatomic, copy) NSString *sbID;
@property (nonatomic, copy) NSString *nibName;

@property (nonatomic, copy) NSString *className;
@property (nonatomic, strong) NSNumber *navigationMode;

+(instancetype)nioURLInfoWithDic:(NSDictionary *)dic;

@end
