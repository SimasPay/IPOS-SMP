//
//  NetworkWrapper.h
//  DIMO
//
//  Created by avenue on 15/01/14.
//  Copyright (c) 2014 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>

// Block that defines a successful HTTPS download
typedef void (^NetworkConnectionSuccessful)(NSURLResponse *response,NSData *data);

// Block that defines an unsucessful HTTPS download
typedef void (^NetworkConnectionFailure)(NSURLResponse *response,NSError *error);



@interface NetworkWrapper : NSObject

+(void)connectWithURLString:(NSString *)urlStr successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock;

+(void)connectWithURLString:(NSString *)urlStr postData:(NSDictionary *) postData successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock;


+(void) canCelAsyncRequest;
@end
