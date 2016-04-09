//
//  ServiceModel.h
//  DIMO
//
//  Created by avenue on 15/01/14.
//  Copyright (c) 2014 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject


+(void)connectGETURL:(NSString *)urlString successBlock:(void (^)(NSDictionary *response))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

+(void)connectPOSTURL:(NSString *)urlString postData:(NSDictionary *)postData successBlock:(void (^)(NSDictionary *response))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

+(void)connectJSONURL:(NSString *)urlString postData:(NSDictionary *)postData successBlock:(void (^)(id responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

+(void)downloadDataForURL:(NSString *)urlString   successBlock:(void (^)(NSData *responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

@end
