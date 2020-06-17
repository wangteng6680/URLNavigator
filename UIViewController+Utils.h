//
//  UIViewController+Utils.h
//
//  Created by Can on 11/6/14.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)
+ (UIViewController *)currentViewController NS_EXTENSION_UNAVAILABLE_IOS("Can not use");

- (IBAction)dismissSelf;
- (IBAction)dismissSelfWithNoAnimated;
- (IBAction)dismissSelfAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (IBAction)popSelf;
- (IBAction)popSelfWithNoAnimation;

@end
