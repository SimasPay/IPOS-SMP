//
//  DIMOPreloader.m
//  DIMOPayiOS
//
//
#import <CoreText/CoreText.h>

#import "DIMOPreloader.h"
#import "DIMOFontConstant.h"
#import "DIMOUtility.h"
//This preloader loads all needed asset and resources before executing SDK


//font file type
static NSString *const DIMO_FILE_TTF_TYPE = @"ttf";
static NSString *const DIMO_FILE_OTF_TYPE = @"otf";

@implementation DIMOPreloader

+ (void) loadCustomFont:(NSString*)name ofType:(NSString*)type {
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:name ofType:type inDirectory:@"DIMOPayiOSResources.bundle"];
    NSData *inData = [NSData dataWithContentsOfFile:fontPath];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    
    if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        DLog([NSString stringWithFormat:@"Failed to load font: %@", errorDescription]);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}

+ (void) loadAllCustomFonts {
    //*already included in iOS Font Family
    //[[DIMOPreloader instance] loadCustomFont:DIMOHELVETICANEUE ofType:DIMO_FILE_OTF_TYPE];
    
    [DIMOPreloader loadCustomFont:DIMO_FONT_BASE_FAMILY_NAME_REGULER ofType:DIMO_FILE_OTF_TYPE];
    [DIMOPreloader loadCustomFont:DIMO_FONT_BASE_FAMILY_NAME_LIGHT ofType:DIMO_FILE_OTF_TYPE];
    [DIMOPreloader loadCustomFont:DIMO_FONT_BASE_FAMILY_NAME_BOLD ofType:DIMO_FILE_OTF_TYPE];
}

@end
