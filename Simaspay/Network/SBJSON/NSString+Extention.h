//
//  NSString+Extention.h
//  DIMO
//
//  Created by avenue on 16/01/14.
//  Copyright (c) 2014 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extention)


- (NSString *)constructUrlStringWithParams:(NSDictionary *)parameters;
- (NSString *)applyCardPanFormat;
- (BOOL)isValid;
@end
