//
//  LoyaltyLaneUtility.h
//  LoyaltyLane
//
//  Created by Rajesh Pothuraju on 15/02/16.
//  Copyright © 2016 SHOP COMMERCE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface SimasPayPlistUtility : NSObject

+(NSString *) getAppDataPlistPath;

+(id) getDataFromPlistForKey:(NSString *) toGetKey;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+(void) saveDataToPlist :(id) toSaveData key:(NSString *) toSaveKey;

+ (NSDate *)dateFromPeriodType:(NSInteger) periodType;

+ (NSDate *)dateForThreeMonths:(NSInteger) periodType fromDate:(NSDate *) fromDatae;

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

+(NSRange ) getNumberOfDaysInMonth:(NSString *)currentDateString;

+(NSString *) showDownLoadedPDf:(NSData *) responseData;


+ (NSString *)constructUrlStringWithParams:(NSDictionary *)parameters;

+ (NSDictionary *)parseQueryString:(NSString *)query;
@end
