//
//  Utility.m
//  DIMOPayiOS
//
//

#import "DIMOUtility.h"
#import <CommonCrypto/CommonDigest.h>
#import <math.h>

@implementation DIMOUtility
static NSString *strLocale = @"INDONESIAN";

void DLog(NSString *message) {
    if (DIMO_IS_DEBUG) {
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
        NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
        [array removeObject:@""];
        //NSLog(@"Class caller = %@", [array objectAtIndex:3]);
        //NSLog(@"Function caller = %@", [array objectAtIndex:4]);
        NSLog(@"%@ - %@ %@", [array objectAtIndex:3], [array objectAtIndex:4], message);
    }
}

NSBundle *mainBundle() {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"DIMOPayiOSResources.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
    /*
    NSString *pathBundle = [[NSBundle mainBundle] pathForResource:@"DIMOPayiOSResources" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:pathBundle];
    return bundle;
     */
}

NSString *String(NSString *key) {
    NSString *result = NSLocalizedStringFromTableInBundle(key, strLocale, mainBundle(), nil);
    if ([result isEqualToString:key]) {
        result = NSLocalizedStringFromTableInBundle(key, @"INDONESIAN", mainBundle(), nil);
    }
    if (!result || result.length == 0) result = @"";
    return result;
}

NSString *StringWithMoney(NSString *key, int amount) {
    NSString *message = String(key);
    message = [message stringByReplacingOccurrencesOfString:String(@"DIMORenderMoney") withString:[NSString stringWithFormat:@"%@ %@", String(@"DIMORupiah"), [NSString setCurrencyFormatter:amount]]];
    return message;
}

NSString *StringWithPoint(NSString *key, int point) {
    NSString *message = String(key);
    message = [message stringByReplacingOccurrencesOfString:String(@"DIMORenderPoint") withString:[NSString stringWithFormat:@"%@ %@", [NSString setCurrencyFormatter:point], String(@"DIMOPoin")]];
    return message;
}

+ (NSAttributedString *)setLabelWithPreCurrency:(int)n currencySymbolSize:(int)curSize amountSize:(int)amSize{
    //currency
    UIFont *pre = [UIFont dimoFontWithName:DIMO_FONT_BASE_FAMILY_NAME_BOLD size:curSize];
    NSDictionary *preDict = [NSDictionary dictionaryWithObject:pre forKey:NSFontAttributeName];
    
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:String(@"DIMORupiah") attributes: preDict];
    
    //the amount
    UIFont *a = [UIFont dimoFontWithName:DIMO_FONT_BASE_FAMILY_NAME_BOLD size:amSize];
    NSDictionary *aDict = [NSDictionary dictionaryWithObject:a forKey:NSFontAttributeName];
    
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", [NSString setCurrencyFormatter:n]] attributes:aDict];
    [aAttrString appendAttributedString:s];
    return aAttrString;
}

+ (UIImage *)imageNamedInFramework:(NSString *)name extension:(NSString *)ext{
    NSString *filePath =[[NSBundle mainBundle] pathForResource:name ofType:ext inDirectory:@"DIMOPayiOSResources.bundle"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (image) return image;
    
    return [UIImage imageNamed:filePath];
}

+ (NSString *)applicationDocumentsDirectory {
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
+ (UIImage *)imageFromBinaryArray:(NSArray *)binaryArray fileName:(NSString *)fileName {
    // currently is being used only for promo
    if (!binaryArray || binaryArray.count == 0) return nil;
    //[DIMOUtility imageNamedInFramework:@"ico-no-promo-image" extension:@"png"];
    
    NSString *filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    //check if a local copy exist
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [UIImage imageWithContentsOfFile:filePath];
    } else {
        if (!binaryArray) return nil;
        
        unsigned char *buffer = (unsigned char*)malloc([binaryArray count]);
        int j = 0;
        
        for (NSDecimalNumber *num in binaryArray) {
            buffer[j++] = [num intValue];
        }
        
        NSData *data = [NSData dataWithBytes:buffer length:[binaryArray count]];
        
        
        // Create byte array of unsigned chars
        unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        
        // Create 16 byte MD5 hash value, store in buffer
        CC_MD5([data bytes], (int)[data length], md5Buffer);
        
        // Convert unsigned char buffer to NSString of hex values
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
            [output appendFormat:@"%02x",md5Buffer[i]];
        }
        
        //NSString *fileName = [NSString stringWithFormat:@"%@.png",output];
        
        free(buffer);
        
        NSData *dataImage = UIImagePNGRepresentation([UIImage imageWithData:data]);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:dataImage attributes:nil];
        
        if ([UIImage imageWithData:dataImage] == nil) {
            return [DIMOUtility imageNamedInFramework:@"ico-no-image" extension:@"png"];
        } else {
            return [UIImage imageWithData:dataImage];
        }
    }
}

+ (NSData *)dataFromBase64EncodedString:(NSString *)string {
    if (string.length > 0) {
        //the iPhone has base 64 decoding built in but not obviously. The trick is to
        //create a data url that's base 64 encoded and ask an NSData to load it.
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        return data;
    }
    return nil;
}

+ (NSString *)numberFormat:(NSNumber *)input {
    return [NSString stringWithFormat:@"%@ %@", String(@"DIMORupiah"), [NSString setCurrencyFormatter:[input intValue]]];
}

+ (void)setSDKLocale:(SDKLocale)locale {
    if (locale == SDKLocaleEnglish) {
        strLocale = @"ENGLISH";
    } else {
        strLocale = @"INDONESIAN";
    }
}
+ (CGSize)screenSize {
    return ScreenSize;
}
@end

@implementation UIFont(extention)
+ (UIFont *)dimoFontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    if ([fontName isEqualToString:@"HelveticaNeue"]) {
        return [UIFont systemFontOfSize:fontSize];
    } else if ([fontName isEqualToString:@"HelveticaNeue-Medium"]) {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    return font ? font : [UIFont systemFontOfSize:fontSize];
}
@end

@implementation NSDictionary (Helpers)

- (id)objectForKeyOrNil:(NSString *)key
{
    if ([self objectForKey:key] &&
        ![[self objectForKey:key] isEqual:[NSNull null]]) {
        return [self objectForKey:key];
    }
    return nil;
}

- (id)objectForKeyPaths:(NSString *)key {
    NSArray *keys = [key componentsSeparatedByString:@"."];
    id object;
    id lastValue;
    for (NSString *key in keys) {
        if (!lastValue) {
            lastValue = [self objectForKey:key];
        } else {
            if (![lastValue isKindOfClass:[NSDictionary class]]) {
                object = lastValue;
            } else {
                lastValue = [lastValue objectForKey:key];
                if (lastValue) {
                    object = lastValue;
                } else {
                    return nil;
                }
            }
        }
    }
    return object;
}

@end

@implementation NSString (Helpers)

#pragma mark - Public Function

- (NSDate *)toDateWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [df setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateStyle:NSDateFormatterLongStyle];
    [df setDateFormat:dateFormat];
    NSDate *dt = [df dateFromString:self];
    return dt;
}

- (NSDate *)toShortDate {
    return  [self toDateWithFormat:DateShortFormat];
}

- (NSDate *)toDate
{
    return [self toDateWithFormat:DateFormat];
}

- (NSString *)removeAllWhiteSpace {
    NSString *new = self;
    new = [new stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  new;
}

- (NSString *)urlEncode
{
    if (!self){
        return @"";
    }
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}

+ (NSString *)generateRandomStringWithLength:(NSInteger) length{
    NSMutableString* string = [NSMutableString stringWithCapacity:6];
    for(int counter = 0; counter < length; counter++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}


- (BOOL)isNotNull
{
    if(!self) {
        return NO;
    }
    BOOL isNotNull = YES;
    if([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        isNotNull = NO;
    }
    return isNotNull;
}

- (BOOL)isEmail {
    if(!self) {
        return NO;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger match = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if(match == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)isDecimal {
    if(!self) {
        return NO;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
                                                                           options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger match = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if(match == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)isNumber {
    //return ?false : true;
    if(![self isNotNull]) return NO;
    if([self characterAtIndex:0] == '+') {
        NSString *removePlus = [self substringFromIndex:1];
        BOOL isNumber =  [removePlus isNumber];
        return isNumber;
    } else {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([self rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            return YES;
            // newString consists only of the digits 0 through 9
        }
        return NO;
    }
}

- (BOOL)isUrl {
    //NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    return [[self lowercaseString] rangeOfString:@"http"].location != NSNotFound;
    /*
     NSString *urlRegEx = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
     NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
     return [urlTest evaluateWithObject:self];*/
}

#pragma mark - Private Function

+ (BOOL)isLUHNFormat:(NSString *)value
{
    BOOL isOdd = YES;
    NSInteger sum = 0;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    for(NSInteger index = [value length] - 1; index >= 0; index--) {
        NSString *digit = [value substringWithRange:NSMakeRange(index, 1)];
        NSNumber *digitNumber = [numberFormatter numberFromString:digit];
        if(digitNumber == nil) {
            return NO;
        }
        NSInteger digitInteger = [digitNumber intValue];
        isOdd = !isOdd;
        if(isOdd) {
            digitInteger *= 2;
        }
        if(digitInteger > 9) {
            digitInteger -= 9;
        }
        sum += digitInteger;
    }
    if(sum % 10 == 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isExpiredMonth:(NSInteger)month andYear:(NSInteger)year
{
    NSDate *now = [NSDate date];
    month = month + 1;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:1];
    NSDate *expiryDate = [calendar dateFromComponents:components];
    return ([expiryDate compare:now] == NSOrderedAscending);
}

+ (BOOL)isExpiredMonth:(NSString *)value
{
    static int maxNumberMonth = 12;
    static int minNumberMonth = 1;
    if(!value) {
        return NO;
    }
    NSInteger expMonth = [value integerValue];
    if(expMonth > maxNumberMonth || expMonth < minNumberMonth) {
        return NO;
    }
    return YES;
}

+ (NSInteger)currentYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    return [components year];
}

+ (BOOL)isExpiredYear:(NSString *)value
{
    static int modulusNumber = 100;
    if(!value) {
        return NO;
    }
    NSInteger expYear = [value integerValue];
    NSInteger currentYear = [NSString currentYear];
    if(expYear < (currentYear % modulusNumber)) {
        return NO;
    }
    return YES;
}


+ (NSString *)setCurrencyFormatter:(int)i {
    //Set comma delimiter
    double currency = i;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:currency]];
    return numberAsString;
}
@end



@implementation NSDate (Helpers)
- (NSString *)toShortString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DateShortFormat];
    return [df stringFromDate:self];
}
- (NSString *)toString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DateFormat];
    return [df stringFromDate:self];
}

- (NSString *)toStringWithFormat:(NSString *)format {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df stringFromDate:self];
}

+ (NSDate *)getLocalDate {
    NSDate *date = [NSDate date];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setTimeZone:[NSTimeZone timeZoneWithName:[NSTimeZone localTimeZone].name]];
    [formater setDateFormat:DateFormat];
    
    NSString* stringDate = [formater stringFromDate:date];
    
    date = [stringDate toDateWithFormat:DateFormat];
    return date;
    
    /*
     NSArray *timezoneNames = [NSTimeZone knownTimeZoneNames] ;
     NSLog(@"timezone : %@", timezoneNames);
     */
}

@end

@implementation NSArray (Helpers)
- (id)objectAtRandomIndex {
    id obj = nil;
    if(self.count != 0) {
        obj = self[(arc4random() % [self count])];
    }
    return obj;
}

- (id)objectAtIndexOrNil:(NSInteger)index {
    if (index < 0) return nil;
    if (index >= self.count) return nil;
    
    return [self objectAtIndex:index];;
}

- (id)firstObjectOrNil {
    id obj = nil;
    if(self.count != 0) {
        obj = self[0];
    }
    return obj;
}

- (id)lastObjectOrNil {
    id obj = nil;
    if(self.count != 0) {
        obj = self[self.count - 1];
    }
    return obj;
}

- (id)addObjectToArray:(id)object {
    id lastObject = [self lastObjectOrNil];
    if (lastObject && [lastObject isKindOfClass:[object class]]) {
        NSMutableArray *temp = [self mutableCopy];
        [temp addObject:object];
        return temp;
    } else {
        NSLog(@"NSArray+Helpers : error when adding object to different kind of array, object : %@", object);
        return self;
    }
}

- (id)deleteObjectAtArray:(id)object {
    NSMutableArray *temp = [self mutableCopy];
    [temp removeObject:object];
    return temp;
}

- (id)insertObjectAtIndex:(id)object index:(int)index {
    if(index <= self.count && index >= 0) {
        NSMutableArray *temp = [self mutableCopy];
        [temp insertObject:object atIndex:index];
        return temp;
    } else {
        NSLog(@"NSArray+Helpers : error when insert object, index : %d & length :%lu", index, (unsigned long)self.count);
        return self;
    }
}
@end

@implementation UIImageView(Helpers)
static NSSearchPathDirectory directorySave = NSLibraryDirectory;
- (NSString *)removeCharacterUnused:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"http:" withString:@""];
    return string;
}
- (void)saveImageToDirectory:(NSData *)imageData withName:(NSString *)name {
    name = [self removeCharacterUnused:name];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directorySave, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:name];
    [imageData writeToFile:savedImagePath atomically:NO];
}
- (UIImage *)getImageWithName:(NSString *)name {
    name = [self removeCharacterUnused:name];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directorySave, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:getImagePath]) {
        UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
        return img;
    } else {
        return nil;
    }
}
- (void)setImageFromStringURL:(NSString *)imageURL {
    UIImage *image = [self getImageWithName:imageURL];
    if (image) {
        self.image = image;
        return;
    }
    
    if (imageURL && imageURL.length > 0 && ![imageURL isKindOfClass:[NSNull class]]) {
        self.image = [DIMOUtility imageNamedInFramework:@"loading-image" extension:@"png"];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            if (imageData && imageData.length > 0) {
                [self saveImageToDirectory:imageData withName:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    self.image = [UIImage imageWithData:imageData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.image = [DIMOUtility imageNamedInFramework:@"ico-no-image" extension:@"png"];
                });
            }
        });
    }
}

@end

@implementation UILabel (Helpers)
@end

@implementation UIButton (Helpers)
@end

@implementation UIColor (extention)
+ (UIColor *)colorWithHexString:(NSString *)hex {
    hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
