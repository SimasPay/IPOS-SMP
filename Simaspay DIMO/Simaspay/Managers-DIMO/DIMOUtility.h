//
//  Utility.h
//  DIMOPayiOS
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserDefault.h"
#import "DIMOAlertView.h"
#import "DIMOAPIManager.h"
#import "DMBProgressHUD.h"

#define DateFormat @"dd MMMM yyyy"
#define DateShortFormat @"dd/MM/yyyy"
#define isiPhone4  ([[UIScreen mainScreen] bounds].size.height == 480) ? TRUE : FALSE
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568) ? TRUE : FALSE
#define isiPhone6  ([[UIScreen mainScreen] bounds].size.height == 667) ? TRUE : FALSE
#define isiPhone6plus  ([[UIScreen mainScreen] bounds].size.height == 736) ? TRUE : FALSE
#define isiOS8OrLater    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//#define isiPad ([[UIScreen mainScreen] bounds].size.height == 768) ? TRUE : FALSE
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_8               SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define ScreenSize  [UIScreen mainScreen].bounds.size

static BOOL const DIMO_IS_DEBUG = 1;
typedef enum :NSInteger {
    LocaleEnglish,
    LocaleIndonesia,
}Locale;

void DLog(NSString *message);

@interface SimasUtility : NSObject
+ (CGSize)screenSize;
+ (void)DIMOLog:(NSString *)string;
@end

@interface UIFont(extention)
+ (UIFont *)dimoFontWithName:(NSString *)fontName size:(CGFloat)fontSize;
@end

@interface NSDictionary (Helpers)
- (id)objectForKeyPaths:(NSString *)key;
@end

@interface NSString (Helpers)

- (NSDate *)toDateWithFormat:(NSString *)dateFormat;
- (NSDate *)toShortDate;
- (NSDate *)toDate;
//- (NSString *)removeAllWhiteSpace;
- (NSString *)urlEncode;
+ (NSString *)generateRandomStringWithLength:(NSInteger) length;

- (BOOL)isNotNull;
- (BOOL)isEmail;
- (BOOL)isDecimal;
- (BOOL)isNumber;
- (BOOL)isUrl;

+ (NSString *)setCurrencyFormatter:(int)i;
@end

@interface NSDate (Helpers)

//- (NSString *)toShortString;
//- (NSString *)toString;
//- (NSString *)toStringWithFormat:(NSString *)format;
+ (NSDate *)getLocalDate;
@end

@interface NSArray (Helpers)
- (id)objectAtIndexOrNil:(NSInteger)index;
- (id)objectAtRandomIndex;
- (id)firstObjectOrNil;
- (id)lastObjectOrNil;
- (id)addObjectToArray:(id)object;
- (id)deleteObjectAtArray:(id)object;
- (id)insertObjectAtIndex:(id)object index:(int)index;
@end


@interface UIImageView(Helpers)
- (void)setImageFromStringURL:(NSString *)imageURL;
@end


@interface UILabel(Helpers)
@end

@interface UIButton(Helpers)
@end

@interface UIColor(extention)
+ (UIColor *)colorWithHexString:(NSString*)hex;
@end
