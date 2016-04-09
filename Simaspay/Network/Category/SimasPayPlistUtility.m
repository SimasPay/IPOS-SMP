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
@end


