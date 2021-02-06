//
//  @author 4what
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OCFunctions : NSObject

+ (NSString *)deviceType;

#pragma mark

#define OCColorWithRGBA(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIImage *)imageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

#pragma mark

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory path:(NSString *)path;

#pragma mark

+ (NSString *)defaultString:(NSString *)str;
+ (BOOL)isEmpty:(NSString *)str;

#pragma mark

+ (NSDictionary *)parseParameters:(NSString *)params;
+ (NSString *)serializeParameters:(NSDictionary *)params;

#pragma mark

+ (NSData *)md5Data:(NSData *)data;
+ (NSString *)md5String:(NSString *)string;

+ (NSData *)sha1Data:(NSData *)data;
+ (NSString *)sha1String:(NSString *)string;

+ (NSString *)toHex:(unsigned char *)md length:(int)length;

@end
