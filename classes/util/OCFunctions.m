//
//  @author 4what
//

#import "OCFunctions.h"

#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

@implementation OCFunctions : NSObject

+ (NSString *)deviceType {
	struct utsname systemName;
	uname(&systemName);

	return [NSString stringWithUTF8String:systemName.machine];
}

#pragma mark

+ (UIImage *)imageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	UIImage *image;

	UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, red / 255.f, green / 255.f, blue / 255.f, alpha);
	UIRectFill(CGRectMake(0, 0, 1, 1));
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

#pragma mark

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory path:(NSString *)path {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *result = [[fileManager URLForDirectory:directory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:path];
	if (![fileManager fileExistsAtPath:result.path]) {
		[fileManager createDirectoryAtURL:result withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return result;
}

#pragma mark

+ (NSString *)defaultString:(NSString *)str {
	return !str ? @"" : str;
}

+ (BOOL)isEmpty:(NSString *)str {
	NSInteger length = str.length;
/*
	if (!str || length == 0) {
		return true;
	}
*/
	for (int i = 0; i < length; i++) {
		if (![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[str characterAtIndex:i]]) {
			return false;
		}
	}
	return true;
}

#pragma mark

+ (NSDictionary *)parseParameters:(NSString *)params {
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	for (NSString *item in [params componentsSeparatedByString:@"&"]) {
		NSArray *entry = [item componentsSeparatedByString:@"="];
		result[entry[0]] = entry[1];
	}
	return result;
}

+ (NSString *)serializeParameters:(NSDictionary *)params {
	NSMutableArray *result = [NSMutableArray array];
	for (NSString *key in params) {
		[result addObject:[NSString stringWithFormat:@"%@=%@", key, [[NSString stringWithFormat:@"%@", params[key]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonBaseCharacterSet]]]];
	}
	return [result componentsJoinedByString:@"&"];
}

#pragma mark

+ (NSData *)md5Data:(NSData *)data {
	unsigned char md[CC_MD5_DIGEST_LENGTH];

	CC_MD5(data.bytes, (CC_LONG) data.length, md);

	return [NSData dataWithBytes:md length:CC_MD5_DIGEST_LENGTH];
}

+ (NSString *)md5String:(NSString *)string {
	unsigned char md[CC_MD5_DIGEST_LENGTH];

	CC_MD5([string UTF8String], (CC_LONG) [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], md);

	return [self toHex:md length:CC_MD5_DIGEST_LENGTH];
}

+ (NSData *)sha1Data:(NSData *)data {
	unsigned char md[CC_SHA1_DIGEST_LENGTH];

	CC_SHA1(data.bytes, (CC_LONG) data.length, md);

	return [NSData dataWithBytes:md length:CC_SHA1_DIGEST_LENGTH];
}

+ (NSString *)sha1String:(NSString *)string {
	unsigned char md[CC_SHA1_DIGEST_LENGTH];

	CC_SHA1([string UTF8String], (CC_LONG) [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], md);

	return [self toHex:md length:CC_SHA1_DIGEST_LENGTH];
}

+ (NSString *)toHex:(unsigned char *)data length:(int)length {
	NSMutableString *result = [NSMutableString string];

	for (int i = 0; i < length; i++) {
		[result appendFormat:@"%02x", data[i]];
	}

	return result;
}

@end
