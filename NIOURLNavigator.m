//
//  NIOURLNavigator.m
//  NextevCar
//
//  Created by can.chen on 2017/7/14.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import "NIOURLNavigator.h"
#import "NIOURLInfo.h"
#import "NIOURLViewControlerProtocol.h"
#import "NIOURLMatcher.h"
#import "NIOURLMatchResult+FullURL.h"
#import "NIOURLContainerViewController.h"
#import "UIViewController+Utils.h"

static NSMutableDictionary<NSString *, NIOURLInfo *> *g_urlDic = nil;

@implementation NIOURLNavigator

#pragma mark - Lifestyle

+ (NSMutableDictionary<NSString *, NIOURLInfo *> *)urlDic {
    if (!g_urlDic) {
        g_urlDic = [NSMutableDictionary dictionary];
    }
    return g_urlDic;
}

#pragma mark - Navigator
+ (void)showVC:(nonnull UIViewController *)vc routeMode:(CCURLNavigationMode)routeMode {
    switch (routeMode) {
        case CCURLNavigationModeNone:
        case CCURLNavigationModePush:
            [self pushViewController:vc];
            break;
        case CCURLNavigationModePresent:
            [self presentedViewController:vc];
            break;
        case CCURLNavigationModeShare:
            [self popToSharedViewController:vc];
            break;
        case CCURLNavigationModePresentNotInNav:
            [self presentedViewControllerNotInNav:vc];
            break;
        case CCURLNavigationModePresentNotInNavNoAnimated:
            [self presentedViewControllerNotInNavNoAnimated:vc];
            break;
        default:
            break;
    }
}

+ (void)pushViewController:(nonnull UIViewController *)vc {
    UIViewController *currentVC = [UIViewController currentViewController];
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:vc animated:YES];
    } else {
        [self presentedViewController:vc];
    }
}

+ (void)presentedViewController:(nonnull UIViewController *)vc {
    UINavigationController *nav;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)vc;
    } else {
        nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.navigationBar.translucent = NO;

        if ([vc respondsToSelector:@selector(dismissSelf)]) {
            vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:vc action:@selector(dismissSelf)];
        }
    }
    if (nav) {
        UIViewController *currentVC = [UIViewController currentViewController];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [currentVC presentViewController:nav animated:YES completion:nil];
    }
}

+ (void)popToSharedViewController:(nonnull UIViewController *)vc {
    UIViewController *rootViewContoller = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootViewContoller) return;

    [self popToSharedViewController:vc fromVC:rootViewContoller];
}

+ (void)presentedViewControllerNotInNav:(nonnull UIViewController *)vc {
    UIViewController *currentVC = [UIViewController currentViewController];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [currentVC presentViewController:vc animated:YES completion:nil];
}

+ (void)presentedViewControllerNotInNavNoAnimated:(nonnull UIViewController *)vc {
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC presentViewController:vc animated:NO completion:nil];
}

#pragma mark - Public

#pragma mark Registeration

+ (void)registerURLObjectWithPlists:(NSArray *)plistNames {
    if (!plistNames || plistNames.count == 0) {
        NSLog(@"NO plist file");
        return;
    }

    for (NSString *fileName in plistNames) {
        NSLog(@"NIOURLNavigator will register info in %@", fileName);
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];

        NSDictionary *tempDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (!tempDic) {
            NSLog(@"load %@ failed", fileName);
            continue;
        }

        if (tempDic) {
            NSArray *urlArray = tempDic[@"URLs"];
            NSMutableArray *urlObjectArray = [[NSMutableArray alloc] init];
            for (NSDictionary *urlDic in urlArray) {
                NIOURLInfo *urlInfo = [NIOURLInfo nioURLInfoWithDic:urlDic];
                [urlObjectArray addObject:urlInfo];
            }
            [self registerURLObjectArray:urlObjectArray];
        }
    }

    if ([[self.urlDic allKeys] count] > 0) {
        NSLog(@"URL had registered:");
        for (NIOURLInfo *object in [self.urlDic allValues]) {
            NSLog(@"%@\n", object);
        }
    }
}

+ (void)registerURLObjectArray:(NSArray *)urls {
    for (NIOURLInfo *urlObject in urls) {
        [self registerURLObject:urlObject];
    }
}

+ (void)registerURLObject:(nonnull NIOURLInfo *)urlObject {
    [self.urlDic setObject:urlObject forKey:urlObject.url];
}

#pragma mark Handle URL

+ (BOOL)canHandleURL:(NSString *)url {
    return ([self urlInfoForURL:url matchResult:nil] != nil);
}

+ (UIViewController *)viewControllerForURL:(NSString *)url {
    NIOURLMatchResult *matchResult;
    NIOURLInfo *urlInfo = [self urlInfoForURL:url matchResult:&matchResult];

    return [self viewControllerForURLInfo:urlInfo matchResult:matchResult];
}

+ (void)openURL:(NSString *)url {
    NIOURLMatchResult *matchResult;
    NIOURLInfo *urlInfo = [self urlInfoForURL:url matchResult:&matchResult];

    UIViewController *vc;
    if ([urlInfo.navigationMode intValue] == CCURLNavigationModeShare) {
        vc = [self findVCForURLInfo:urlInfo matchResult:matchResult];
    } else {
        vc = [self viewControllerForURLInfo:urlInfo matchResult:matchResult];
    }

    void (^openBlock)(void) = ^(void) {
        [self showVC:vc routeMode:[urlInfo.navigationMode intValue]];
    };

    if (vc) {
        BOOL shouldOpenSync = YES;
        if ([vc conformsToProtocol:@protocol(NIOURLViewControlerProtocol)]) {
            if ([(id<NIOURLViewControlerProtocol>)vc respondsToSelector:@selector(shouldOpen:)]) {
                shouldOpenSync = NO;
                [(id<NIOURLViewControlerProtocol>)vc shouldOpen:^(BOOL shouldOpen) {
                    if (shouldOpen) {
                        openBlock();
                    }
                }];
            }
        }

        if (shouldOpenSync) {
            openBlock();
        }
    }
}

#pragma mark - Other

+ (UIViewController *)viewControllerForURLInfo:(NIOURLInfo *)urlInfo matchResult:(NIOURLMatchResult *)matchResult {
    NSString *className = urlInfo.className;

    Class class;
    if (className) {
        class = NSClassFromString(className);
        if (!class) {
            NSLog(@"Can not find class %@", className);
            return nil;
        }
    }

    UIViewController *vc;

    NSString *bundlePath = urlInfo.bundlePath;
    NSString *sbName = urlInfo.sbName;
    NSString *sbID = urlInfo.sbID;
    NSString *nibName = urlInfo.nibName;

    int condition = 0;
    condition = condition | (className ? 1 << 1 : 0);
    condition = condition | ((sbName && sbID) || (nibName != nil) ? 1 : 0);

    //1 for instantiateWithURLInfo
    //2 for instantiateViewControllerWithIdentifier or alloc and init with xib
    //3 for new
    int instantiateMethod = 0;

    switch (condition) {
        case 0:;
            break;
        case 1:
            instantiateMethod = 2;
            break;
        case 2: {
            if ([class conformsToProtocol:@protocol(NIOURLViewControlerProtocol)] && [class respondsToSelector:@selector(instantiateWithURLInfo:matchResult:error:)]) {
                instantiateMethod = 1;
            } else {
                instantiateMethod = 3;
            }
        } break;
        case 3: {
            if ([class conformsToProtocol:@protocol(NIOURLViewControlerProtocol)] && [class respondsToSelector:@selector(instantiateWithURLInfo:matchResult:error:)]) {
                instantiateMethod = 1;
            } else {
                instantiateMethod = 2;
            }
        }

        break;
        default:
            break;
    }

    switch (instantiateMethod) {
        case 0:;
            break;
        case 1: {
            NSError *error;
            vc = [class instantiateWithURLInfo:urlInfo matchResult:matchResult error:&error];
            if (error) {
                NSLog(@"instantiateWithURLInfo failed: %@", error);
            }
        } break;
        case 2: {
            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
            if(sbName && sbID) {
                vc = [[UIStoryboard storyboardWithName:sbName bundle:bundle] instantiateViewControllerWithIdentifier:sbID];
            } else if (nibName) {
                vc = [[class alloc] initWithNibName:nibName bundle:bundle];
            }
        }   
            break;
        case 3:
            vc = [class new];
            break;
        default:
            break;
    }

    if (vc) {
        if (instantiateMethod != 1) {
            NSDictionary *keyMap = urlInfo.keyMap;
            for (NSString *key in matchResult.params) {
                NSString *vcPropertyKey;

                NSString *keyInMap = keyMap[key];
                if (keyInMap) {
                    vcPropertyKey = keyInMap;
                } else {
                    vcPropertyKey = key;
                }

                @try {
                    [vc setValue:matchResult.params[key] forKey:vcPropertyKey];
                } @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            }

            NSString *urlKey = urlInfo.urlKey;
            if (urlKey) {
                @try {
                    [vc setValue:[[matchResult fullURL] absoluteString] forKey:urlKey];
                } @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            }
        }
    }

    return vc;
}

+ (UIViewController *)findVCForURLInfo:(NIOURLInfo *)urlInfo matchResult:(NIOURLMatchResult *)matchResul {
    UIViewController *rootViewContoller = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self findVCWithClassName:urlInfo.className condition:nil fromVC:rootViewContoller];
}

+ (UIViewController *)findVCWithClassName:(NSString *)className condition:(NSDictionary *)condition fromVC:(UIViewController *)fromVC {
    UIViewController *resultVC;
    if (!fromVC) return resultVC;

    Class class = NSClassFromString(className);
    if (!class) {
        return resultVC;
    }

    if ([fromVC isKindOfClass:class]) {
        resultVC = fromVC;
    } else {
        if (fromVC.presentedViewController) {
            resultVC = [self findVCWithClassName:className condition:condition fromVC:fromVC.presentedViewController];
        }

        if (!resultVC) {
            if ([fromVC conformsToProtocol:@protocol(NIOURLContainerViewController)]) {
                id<NIOURLContainerViewController> container = (id<NIOURLContainerViewController>)fromVC;
                NSArray *subVCs = [container nioURL_subViewControllers];
                for (int i = 0; i < [subVCs count]; i++) {
                    UIViewController *tmpController = subVCs[i];
                    UIViewController *tryVC = [self findVCWithClassName:className condition:condition fromVC:tmpController];
                    if (tryVC) {
                        resultVC = tryVC;
                        break;
                    }
                }
            }
        }
    }
    return resultVC;
}

+ (BOOL)popToSharedViewController:(nonnull UIViewController *)vc fromVC:(nonnull UIViewController *)fromVC {
    BOOL popResult = NO;

    if (fromVC.presentedViewController) {
        popResult = [self popToSharedViewController:vc fromVC:fromVC.presentedViewController];
    }

    if (!popResult) {
        if ([fromVC conformsToProtocol:@protocol(NIOURLContainerViewController)]) {
            id<NIOURLContainerViewController> container = (id<NIOURLContainerViewController>)fromVC;
            NSArray *subVCs = [container nioURL_subViewControllers];
            NSInteger selectIndex = -1;
            for (int i = 0; i < [subVCs count]; i++) {
                UIViewController *tmpController = subVCs[i];
                if (tmpController == vc) {
                    selectIndex = i;
                    break;
                } else {
                    popResult = [self popToSharedViewController:vc fromVC:tmpController];
                    if (popResult) {
                        selectIndex = i;
                        break;
                    }
                }
            }
            if (selectIndex != -1 && selectIndex != container.nioURL_currentSelectedIndex) {
                if ([container respondsToSelector:@selector(nioURL_shouldChangeSelectedIndex:)]) {
                    //ignore return value
                    [container nioURL_shouldChangeSelectedIndex:selectIndex];
                }
                [container nioURL_setSelectedIndex:selectIndex animated:NO];
                popResult = YES;
            }
        }
        if (popResult && fromVC.presentedViewController) {
            [fromVC.presentedViewController dismissSelf];
        }
    }

    return popResult;
}

//TODO: add cache
+ (NIOURLInfo *)urlInfoForURL:(NSString *)url matchResult:(NIOURLMatchResult **)result {
    NIOURLInfo *urlObject;

    NSArray *allURL = [self.urlDic allKeys];
    for (NSString *sourceURL in allURL) {
        NIOURLMatcher *matcher = [NIOURLMatcher matcherWithSourceURL:sourceURL];

        NIOURLMatchResult *matchResult = [matcher matchTargetURL:url];
        if (matchResult.isMatch) {
            urlObject = [self.urlDic objectForKey:sourceURL];
            if (result) {
                *result = matchResult;
            }
            break;
        }
    }
    return urlObject;
}

@end
