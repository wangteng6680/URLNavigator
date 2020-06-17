//
//  NIOURLInfo.m
//  NextevCar
//
//  Created by can.chen on 2017/7/14.
//  Copyright © 2017年 Nextev. All rights reserved.
//

#import "NIOURLInfo.h"

@implementation NIOURLInfo

+(instancetype)nioURLInfoWithDic:(NSDictionary *)dic {
    NIOURLInfo *urlInfo = [[NIOURLInfo alloc] init];
    urlInfo.url = dic[@"url"];
    urlInfo.urlKey = dic[@"urlKey"];
    urlInfo.keyMap = dic[@"keyMap"];
    urlInfo.bundlePath = dic[@"bundlePath"];
    urlInfo.sbName = dic[@"sbName"];
    urlInfo.sbID = dic[@"sbID"];
    urlInfo.nibName = dic[@"nibName"];
    urlInfo.className = dic[@"className"];
    urlInfo.navigationMode = dic[@"navigationMode"];
    return urlInfo;
}

@end
