//
//  NIOURLMatcher.m
//  NextevCar
//
//  Created by can.chen on 2017/7/19.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import "NIOURLMatcher.h"
#import "NIOURLMatchResult.h"
#import "NIOURLRegularExpression.h"
#import "NSURL+QueryDictionary.h"

@interface NIOURLMatcher ()

@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, strong) NIOURLRegularExpression *regexMatcher;

@end

@implementation NIOURLMatcher

+ (instancetype)matcherWithSourceURL:(NSString *)sourceURL {
    return [[self alloc] initWithSourceURL:sourceURL];
}

- (instancetype)initWithSourceURL:(NSString *)route {
    if (![route length]) {
        return nil;
    }

    self = [super init];
    if (self) {
        NSArray *parts = [route componentsSeparatedByString:@"://"];
        _scheme = parts.count > 1 ? [parts firstObject] : nil;
        _regexMatcher = [NIOURLRegularExpression regularExpressionWithPattern:[parts lastObject]];
    }

    return self;
}

- (NIOURLMatchResult *)matchTargetURL:(NSString *)targetURL {
    NSURL *url = [NSURL URLWithString:targetURL];

    if (!url) {
        NSLog(@"targetURL invalid");
        return nil;
    }

    NIOURLMatchResult *result;

    NSString *hostAndPath = [NSString stringWithFormat:@"%@%@", url.host, url.path];

    if (!self.scheme.length || [self.scheme isEqualToString:url.scheme]) {
        result = [self.regexMatcher matchResultForString:hostAndPath];
        if (result.isMatch) {
            [result.params addEntriesFromDictionary:[url.query uq_URLQueryDictionary]];
            result.urlWithoutParams = self.scheme ? [NSString stringWithFormat:@"%@://%@", self.scheme, hostAndPath] : hostAndPath;
        }
    }

    return result;
}

@end
