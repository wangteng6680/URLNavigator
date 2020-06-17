//
//  NIOURLMatchResult.h
//  NextevCar
//
//  Created by can.chen on 2017/7/19.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIOURLMatchResult : NSObject

@property (nonatomic, assign, getter=isMatch) BOOL match;
@property (nonatomic, copy) NSString *urlWithoutParams;
@property (nonatomic, strong) NSMutableDictionary *params;

@end
