//
//  InvoiceModel.h
//  DIMOPayiOS
//
//  Created by Kendy Susantho on 10/27/15.
//  Copyright © 2015 DIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIMOInvoiceModel : NSObject
@property (nonatomic, strong) NSString *invoiceId;
@property (nonatomic, assign) double originalAmount;
@property (nonatomic, strong) NSString *merchantName;

//loyalty property
@property (nonatomic, strong) NSString *loyaltyProgramName;
@property (nonatomic, strong) NSString *discountType;

// Used for dynamic value for hostapp information
@property (nonatomic, assign) double amountOfDiscount;
@property (nonatomic, assign) double paidAmount;
@property (nonatomic, assign) int numberOfCoupons;
@property (nonatomic, assign) double tipAmount;

+ (DIMOInvoiceModel *)objectFromDictionary:(NSDictionary *)data;
@end
