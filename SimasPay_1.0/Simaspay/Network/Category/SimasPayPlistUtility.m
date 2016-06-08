//
//  LoyaltyLaneUtility.m
//  LoyaltyLane
//
//  Created by Rajesh Pothuraju on 15/02/16.
//  Copyright © 2016 SHOP COMMERCE. All rights reserved.
//

#import "SimasPayPlistUtility.h"


@implementation SimasPayPlistUtility

+(NSString *) getAppDataPlistPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"simaspayApplication.plist"];
    
    return path;
}


+(id) getDataFromPlistForKey:(NSString *) toGetKey {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: [self getAppDataPlistPath]];
    id dataForKey = [savedStock objectForKey:toGetKey];
    return dataForKey;
    
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(void) saveDataToPlist :(id) toSaveData key:(NSString *) toSaveKey {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"simaspayApplication.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"simaspayApplication.plist"] ];
    }
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        if (toSaveData) {
            [data setObject:toSaveData forKey:toSaveKey];
        }
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
        if (toSaveData) {
            [data setObject:toSaveData forKey:toSaveKey];
        }
        
    }
    [data writeToFile: path atomically:YES];
}


+ (NSDate *)dateFromPeriodType:(NSInteger) periodType
{
    NSDateComponents *componentstoSubstract = [[NSDateComponents alloc] init];
    NSDate *toDate = nil;
    switch (periodType) {
        case 0:
        {
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            components.day = 1;
            return [[NSCalendar currentCalendar] dateFromComponents:components];
        }
            break;
        case 1:
        {
            componentstoSubstract.month = -1;
        }
            break;
        case 2:
        {
            componentstoSubstract.month = -2;
        }
    }
    
    toDate = [[NSCalendar currentCalendar] dateByAddingComponents:componentstoSubstract toDate:[NSDate date] options:0];
    return toDate;
}

+ (NSDate *)dateForThreeMonths:(NSInteger) periodType fromDate:(NSDate *) fromDatae
{
    NSDateComponents *componentstoSubstract = [[NSDateComponents alloc] init];
    NSDate *toDate = nil;
    componentstoSubstract.month = 3;
    toDate = [[NSCalendar currentCalendar] dateByAddingComponents:componentstoSubstract toDate:fromDatae options:0];
    return toDate;
}


+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


+(NSRange ) getNumberOfDaysInMonth:(NSString *)currentDateString
{
    // NSDate *today = [NSDate date]; //Get a date object for today's date
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMyyyy"];
    NSDate *fromDate = [dateformatter dateFromString:currentDateString];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:fromDate];
    return days;
}

+(NSString *) showDownLoadedPDf:(NSData *) responseData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Rincian Transaksi.pdf"];
    BOOL __unused success = [fileManager createFileAtPath:filePath contents:responseData attributes:nil];

    return filePath;
}

+ (NSString *)constructUrlStringWithParams:(NSDictionary *)parameters
{
    
    NSMutableString *sampleURL = [NSMutableString stringWithString:@""];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [sampleURL appendFormat:@"%@=%@",key,obj];
        [sampleURL appendString:@"&"];
        
    }];
    
    // CONDITIONLOG(DEBUG_MODE, @"Before URL:%@",sampleURL);
    [sampleURL deleteCharactersInRange:NSMakeRange(sampleURL.length - 1, 1)];
    
    //   CONDITIONLOG(DEBUG_MODE, @"After URL:%@",sampleURL);
    NSString *normalisedStr = [NSString stringWithString:sampleURL];
    return normalisedStr;
    
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end


