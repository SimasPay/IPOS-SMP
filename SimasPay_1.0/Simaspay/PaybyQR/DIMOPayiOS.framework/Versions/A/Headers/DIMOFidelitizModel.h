//
//  DIMOFidelitizModel.h
//  DIMOPayiOS
//
//  Created by Kendy Susantho on 6/1/16.
//  Copyright © 2016 DIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIMOFidelitizModel : NSObject
@property(nonatomic, strong) NSString *loyaltyProgramLabel;
@property(nonatomic, strong) NSString *rewardType;
@property(nonatomic, assign) int couponValue;
@property(nonatomic, assign) int pointAmountForCoupon;
@property(nonatomic, assign) int pointsBalance;
@property(nonatomic, assign) int pointsGenerated;
@property(nonatomic, assign) int couponsBalance;
@property(nonatomic, assign) int couponsGenerated;

+ (DIMOFidelitizModel *)fidelitizFromDict:(NSDictionary *)dict;
@end
