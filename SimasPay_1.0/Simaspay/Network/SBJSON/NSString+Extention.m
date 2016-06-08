//
//  NSString+Extention.m
//  DIMO
//
//  Created by avenue on 16/01/14.
//  Copyright (c) 2014 Mfino. All rights reserved.
//

#import "NSString+Extention.h"
#import "DimoConstants.h"

@implementation NSString (Extention)


// Construct String from the Dictionary keys and Values

- (NSString *)constructUrlStringWithParams:(NSDictionary *)parameters
{
    
    NSMutableString *sampleURL = [NSMutableString stringWithString:self];
    
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

//Apply Format for card Pan

- (NSString *)applyCardPanFormat
{

    return [NSString stringWithFormat:@"%@-%@-%@-%@",[self substringToIndex:4],[self substringWithRange:NSMakeRange(4, 4)],[self substringWithRange:NSMakeRange(8, 4)],[self substringWithRange:NSMakeRange(12, 4)]];
    
}

// Check if the string is valid by its text length
- (BOOL)isValid

{
    return (self.length > 0) ? YES : NO;
}
@end
