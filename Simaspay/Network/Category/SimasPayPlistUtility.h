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

+(void) saveDataToPlist :(id) toSaveData key:(NSString *) toSaveKey;

+ (NSDate *)dateFromPeriodType:(NSInteger) periodType;

+(NSRange ) getNumberOfDaysInMonth:(NSString *)currentDateString;

+(NSString *) showDownLoadedPDf:(NSData *) responseData;


+ (NSString *)constructUrlStringWithParams:(NSDictionary *)parameters;
@end
