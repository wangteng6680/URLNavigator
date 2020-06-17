//
//  UINavigationController+NIOURL.m
//  NextevCar
//
//  Created by can.chen on 2017/8/21.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import "UINavigationController+NIOURL.h"

@implementation UINavigationController (NIOURL)

- (NSArray<UIViewController *> *)nioURL_subViewControllers {
    return self.viewControllers;
}

- (void)nioURL_setSelectedIndex:(NSUInteger)aSelectedIndex animated:(BOOL)aniamted {
    [self popToViewController:self.viewControllers[aSelectedIndex] animated:aniamted];
}

- (NSUInteger)nioURL_currentSelectedIndex {
    NSUInteger count = [self.viewControllers count];
    return count > 0 ? count - 1 : 0;
}

@end
