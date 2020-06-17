//
//  NIOURLMatcher.h
//  NextevCar
//
//  Created by can.chen on 2017/7/19.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NIOURLMatchResult.h"

@interface NIOURLMatcher : NSObject

/**
 Initializes a url matcher.
 @param sourceURL The url to match.
 @return An url matcher instance.
 */
+ (instancetype)matcherWithSourceURL:(NSString *)sourceURL;

/**
 Matches a url against the route and returns a deep link.
 @param targetURL The url to be compared with the route.
 @return A DPLDeepLink instance if the URL matched the route, otherwise nil.
 */
- (NIOURLMatchResult *)matchTargetURL:(NSString *)targetURL;

@end
