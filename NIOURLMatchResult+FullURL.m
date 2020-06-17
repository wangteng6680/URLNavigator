//
//  NIOURLMatchResult+FullURL.m
//  NextevCar
//
//  Created by can.chen on 2017/7/27.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import "NIOURLMatchResult+FullURL.h"
#import "NSURL+QueryDictionary.h"

@implementation NIOURLMatchResult (FullURL)

- (NSURL *)fullURL {
    NSURL *url = [NSURL URLWithString:self.urlWithoutParams];

    return [url uq_URLByAppendingQueryDictionary:self.params];
}

@end
