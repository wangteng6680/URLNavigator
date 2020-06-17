//
//  NIOURLContainerViewController.h
//  NextevCar
//
//  Created by can.chen on 2017/8/21.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NIOURLContainerViewController <NSObject>

@required

- (NSArray<UIViewController *> *)nioURL_subViewControllers;

- (void)nioURL_setSelectedIndex:(NSUInteger)aSelectedIndex animated:(BOOL)aniamted;

- (NSUInteger)nioURL_currentSelectedIndex;

@optional

- (BOOL)nioURL_shouldChangeSelectedIndex:(NSUInteger)aSelectedIndex;

@end
