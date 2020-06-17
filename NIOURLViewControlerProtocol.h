//
//  NIOURLViewControlerProtocol.h
//
//  Created by can.chen on 2017/7/16.
//

#import <Foundation/Foundation.h>
#import "NIOURLInfo.h"
#import "NIOURLMatchResult.h"

@protocol NIOURLViewControlerProtocol <NSObject>

@optional

/**
 根据URL信息，创建vc实例。
 推荐使用pod 'NSURL+QueryDictionary', '~> 1.2.0'获取URL中的参数信息

 @param urlObject NIOURLInfo
 @return view controller
 */
+ (UIViewController<NIOURLViewControlerProtocol> *)instantiateWithURLInfo:(NIOURLInfo *)urlObject matchResult:(NIOURLMatchResult *)result error:(NSError **)error;

- (void)dismissSelf;

/**
 open aync

 @param shouldOpen aync block
 */
- (void)shouldOpen:(void (^)(BOOL))shouldOpen;
@end
