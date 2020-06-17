
@import Foundation;

#import "NIOURLMatchResult.h"

@interface NIOURLRegularExpression : NSRegularExpression

@property (nonatomic, strong) NSArray *groupNames;

+ (instancetype)regularExpressionWithPattern:(NSString *)pattern;

- (NIOURLMatchResult *)matchResultForString:(NSString *)str;

@end
