//
//  NetworkWrapper.m
//  DIMO
//
//  Created by avenue on 15/01/14.
//  Copyright (c) 2014 Mfino. All rights reserved.
//

#import "NetworkWrapper.h"
#import "NSURLRequest+SSLValidation.h"
#import "DimoConstants.h"

NSString *const kNetworkUtilitiesErrorDomain = @"kDimoErrorDomain";
NSInteger const kNetworkUtilitiesHttpErrorCode = 5;

@implementation NetworkWrapper

+(void)connectWithURLString:(NSString *)urlStr successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock

{
    dispatch_queue_t default_queuet = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(default_queuet, ^{
        
        CONDITIONLOG(DEBUG_MODE, @"URL STRING:%@",urlStr);
        
        NSString *modulatedURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *serviceUrl = [NSURL URLWithString:modulatedURL];
        NSURLRequest *serviceRequest = [NSURLRequest requestWithURL:serviceUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [NSURLRequest allowsAnyHTTPSCertificateForHost:[serviceUrl host]];
        
        [NSURLConnection sendAsynchronousRequest:serviceRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    
            if (connectionError) {
                
                failureBlock (response,connectionError);
                
            } else {
                
                successBlock (response,data);
            }
        }];
        
    });
    
}

+(void)connectWithURLString:(NSString *)urlStr postData:(NSDictionary *) postData successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock
{
    dispatch_queue_t default_queuet = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(default_queuet, ^{
        CONDITIONLOG(DEBUG_MODE, @"URL STRING:%@",urlStr);
        NSString *modulatedURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *serviceUrl = [NSURL URLWithString:modulatedURL];
        NSMutableURLRequest *serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [serviceRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [serviceRequest setHTTPMethod:@"POST"];
        
        [serviceRequest setHTTPBody:[self httpBodyForParamsDictionary:postData]];
        
        
        [NSURLRequest allowsAnyHTTPSCertificateForHost:[serviceUrl host]];
        
        [NSURLConnection sendAsynchronousRequest:serviceRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (connectionError) {
                
                failureBlock (response,connectionError);
                
            } else {
                
                successBlock (response,data);
            }
        }];
        
    });
}

+(NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    NSMutableArray *parameterArray = [NSMutableArray array];
    
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+(void) canCelAsyncRequest
{
    
}
@end
