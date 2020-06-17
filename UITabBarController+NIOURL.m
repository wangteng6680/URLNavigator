//
//  UITabBarController+NIOURL.m
//  NextevCar
//
//  Created by can.chen on 2017/8/21.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import "UITabBarController+NIOURL.h"

@implementation UITabBarController (NIOURL)

- (NSArray<UIViewController *> *)nioURL_subViewControllers {
    return self.viewControllers;
}

- (void)nioURL_setSelectedIndex:(NSUInteger)aSelectedIndex animated:(BOOL)aniamted {
    [self setSelectedIndex:aSelectedIndex];
}

- (NSUInteger)nioURL_currentSelectedIndex {
    return self.selectedIndex;
}

- (BOOL)nioURL_shouldChangeSelectedIndex:(NSUInteger)aSelectedIndex {
    BOOL shouldChange = YES;
    ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        shouldChange = [self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[aSelectedIndex]];
    }
    return shouldChange;
}

@end
