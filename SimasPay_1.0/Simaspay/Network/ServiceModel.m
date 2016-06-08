//
//  ServiceModel.m
//  DIMO
//
//  Created by avenue on 15/01/14.
//  Copyright (c) 2014 Mfino. All rights reserved.
//

#import "ServiceModel.h"
#import "NetworkWrapper.h"
#import "XMLReader.h"
#import "Reachability.h"
#import "SBJSON.h"

@implementation ServiceModel



+(void)connectGETURL:(NSString *)urlString successBlock:(void (^)(NSDictionary *response))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock

{
    
    NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
    {
        dispatch_queue_t processing_queue = dispatch_queue_create("com.Rand.SimasPay.processing", NULL);
        
        dispatch_async(processing_queue, ^{
            NSError *error = nil;
            
            NSDictionary *response = (NSDictionary *)[XMLReader dictionaryForXMLData:data error:&error];
            
            wrapperSuccessBlock (response);
        });
    };
    
    NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
    {
        wrapperFailedBlock (error);
    };
    
    
    
    [NetworkWrapper connectWithURLString:urlString successBlock:userSuccessBlock failureBlock:userFailureBlock];
}




+(void)connectPOSTURL:(NSString *)urlString postData:(NSDictionary *)postData successBlock:(void (^)(NSDictionary *response))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock
{
    NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
    {
        dispatch_queue_t processing_queue = dispatch_queue_create("com.Rand.SimasPay.processing", NULL);
        
        dispatch_async(processing_queue, ^{
            NSError *error = nil;
            
            NSDictionary *response = (NSDictionary *)[XMLReader dictionaryForXMLData:data error:&error];
            
            wrapperSuccessBlock (response);
        });
    };
    
    NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
    {
        wrapperFailedBlock (error);
    };
    
    [NetworkWrapper connectWithURLString:urlString postData:postData successBlock:userSuccessBlock failureBlock:userFailureBlock];
}


+(void)connectJSONURL:(NSString *)urlString postData:(NSDictionary *)postData successBlock:(void (^)(id responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock
{
        NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
        {
            dispatch_queue_t processing_queue = dispatch_queue_create("com.Rand.SimasPay.processing", NULL);
            
            dispatch_async(processing_queue, ^{
                
                id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    wrapperSuccessBlock (result);
            });
        };
        
        NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
        {
            wrapperFailedBlock (error);
        };
        
        
        
        [NetworkWrapper connectWithURLString:urlString postData:postData successBlock:userSuccessBlock failureBlock:userFailureBlock];
    
}


+(void)downloadDataForURL:(NSString *)urlString   successBlock:(void (^)(NSData *responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock

{

    NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
    {
        dispatch_queue_t processing_queue = dispatch_queue_create("com.Rand.SimasPay.processing", NULL);
        
        dispatch_async(processing_queue, ^{

            wrapperSuccessBlock (data);
        });
    };
    
    NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
    {
        wrapperFailedBlock (error);
    };
    
    
    
    [NetworkWrapper connectWithURLString:urlString successBlock:userSuccessBlock failureBlock:userFailureBlock];
}
@end
