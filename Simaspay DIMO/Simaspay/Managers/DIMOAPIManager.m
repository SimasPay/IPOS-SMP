//
//  APIManager.m
//  DIMOPayiOS
//
//

#import "DIMOAPIManager.h"
#import "DAFNetworking.h"
#import "DIMOUtility.h"
#import "DReachability.h"

@implementation DIMOAPIManager
static int const errorCode401 = 401;
static NSString *BASE_URL = @"https://my.flashiz.co.id/";

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
+ (void)setEnvironment:(NSString *)environment {
    if ([environment caseInsensitiveCompare:@"uat"] == NSOrderedSame) {
        BASE_URL = @"https://uat.flashiz.co.id/";
    } else if ([environment caseInsensitiveCompare:@"dev"] == NSOrderedSame) {
        BASE_URL = @"https://sandbox.flashiz.co.id/";
    } else if ([environment caseInsensitiveCompare:@"live"] == NSOrderedSame) {
        BASE_URL = @"https://my.flashiz.co.id/";
    } else {
        BASE_URL = environment;
    }
    DLog([NSString stringWithFormat:@"Server point to : %@", BASE_URL]);
}

+ (BOOL)isInternetConnectionExist {
    DReachability *networkReachability = [DReachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        DLog(@"There IS NO internet connection");
        return NO;
    } else {
        DLog(@"There IS internet connection");
        return YES;
    }
    //return ((AFNetworkReachabilityManager*)[NSClassFromString(@"AFNetworkReachabilityManager") sharedManager]).reachable;
}

+ (NSString *)errorMessageFrom:(NSError *)error {
    NSString *message = [error.userInfo objectForKey:kDIMO_ERROR_MESSAGE];
    message = message ? message : String(@"DIMOUnknownError");
    return message;
}

#pragma mark - Private Methods

+ (BOOL)checkConnectionAndUrlCompatible:(NSString *)url {
    //check compatible of api here
    if (![self isInternetConnectionExist]) {
        //no internet connection
        DLog(@"Internet connection not exist detected");
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_SIMASPAY_API_NO_INTERNET_CONNECTION object:nil];
        return NO;
    }
    return YES;
}

+ (DAFHTTPRequestOperationManager *)createRequestManager {
    DAFHTTPRequestOperationManager *manager = [DAFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.securityPolicy.allowInvalidCertificates = YES;
    //manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet set];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[manager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    /*
    NSString *token = [UserDefault objectFromUserDefaultsForKey:TokenKey];
    if ([token isNotNull]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", token] forHTTPHeaderField:@"Authorization"];
    }*/
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:appVersion forHTTPHeaderField:@"AppVersion"];
    [manager.requestSerializer setTimeoutInterval:30];
    return manager;
}

+ (void)startHTTPRequestWithUrlString:(NSString *)urlString
                               params:(NSDictionary *)params
                                 data:(NSArray *)arrayData
                           completion:(void(^)(DAFHTTPRequestOperation *operation, id responseObject, NSError *err))completion
{
    if (!urlString) {
        completion(nil, nil, nil);
        return;
    }
    // Remove all white space
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![self checkConnectionAndUrlCompatible:urlString]) return;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    /*
     NSArray *arrayDatax = @[
     @{
     @"data" : [NSData data],
     @"name" : @"image",
     @"file_name" : @"image.jpg",
     @"mime_type" : @"image/jpeg"
     },
     @{
     @"data" : [NSData data],
     @"name" : @"video",
     @"file_name" : @"video.mov",
     @"mime_type" : @"video/quicktime"
     },
     @{
     @"data" : [NSData data],
     @"name" : @"sound",
     @"file_name" : @"sound.m4a",
     @"mime_type" : @"audio/m4a"
     }
     ];*/
    DAFHTTPRequestOperationManager *manager = [self createRequestManager];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *dic in arrayData) {
            NSData *data = [dic objectForKey:@"data"];
            NSString *name = [dic objectForKey:@"name"];
            NSString *fileName = [dic objectForKey:@"file_name"];
            NSString *mimeType = [dic objectForKey:@"mime_type"];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
    } success:^(DAFHTTPRequestOperation *operation, id responseObject) {
        [DIMOAPIManager handleSuccessForOperation:operation
                                      responseObject:responseObject
                                          completion:completion];
    } failure:^(DAFHTTPRequestOperation *operation, NSError *error) {
        [DIMOAPIManager handleErrorForOperation:operation
                                             error:error
                                        completion:completion];
    }];
}
+ (void)startHTTPRequestWithMethod:(ConnectionManagerHTTPMethod)method
                         urlString:(NSString *)urlString
                            params:(NSDictionary *)params
                        completion:(void(^)(DAFHTTPRequestOperation *operation, id responseObject, NSError *err))completion
{
    if (!urlString) {
        completion(nil, nil, nil);
        return;
    }
    // Remove all white space
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![self checkConnectionAndUrlCompatible:urlString]) return;
    
    // Logging url called
    DLog([NSString stringWithFormat:@"Try to call : %@\nwith params %@", urlString, params]);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    DAFHTTPRequestOperationManager *manager = [self createRequestManager];
    if (method == ConnectionManagerHTTPMethodPOST) {
        [manager POST:urlString parameters:params success:^(DAFHTTPRequestOperation *operation, id responseObject) {
            [DIMOAPIManager handleSuccessForOperation:operation
                                          responseObject:responseObject
                                              completion:completion];
        } failure:^(DAFHTTPRequestOperation *operation, NSError *error) {
            [DIMOAPIManager handleErrorForOperation:operation
                                                 error:error
                                            completion:completion];
        }];
    } else {
        [manager GET:urlString parameters:params success:^(DAFHTTPRequestOperation *operation, id responseObject) {
            [DIMOAPIManager handleSuccessForOperation:operation
                                          responseObject:responseObject
                                              completion:completion];
        } failure:^(DAFHTTPRequestOperation *operation, NSError *error) {
            [DIMOAPIManager handleErrorForOperation:operation
                                                 error:error
                                            completion:completion];
        }];
    }
}

+ (void)startHTTPRequestWithMethodAndHeader:(ConnectionManagerHTTPMethod)method
                                    headers:(NSDictionary *)headers
                                  urlString:(NSString *)urlString
                                     params:(NSDictionary *)params
                                 completion:(void(^)(DAFHTTPRequestOperation *operation, id responseObject, NSError *err))completion
{
    if (!urlString) {
        completion(nil, nil, nil);
        return;
    }
    // Remove all white space
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![self checkConnectionAndUrlCompatible:urlString]) return;
    
    // Logging url called
    DLog([NSString stringWithFormat:@"Try to call : %@\nwith params %@", urlString, params]);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    DAFHTTPRequestOperationManager *manager = [self createRequestManager];
    if (method == ConnectionManagerHTTPMethodPOST) {
        manager.requestSerializer = [DAFJSONRequestSerializer serializer];
        for (NSString *key in headers) {
            [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
        [manager POST:urlString parameters:params success:^(DAFHTTPRequestOperation *operation, id responseObject) {
            [DIMOAPIManager handleSuccessForOperation:operation
                                       responseObject:responseObject
                                           completion:completion];
        } failure:^(DAFHTTPRequestOperation *operation, NSError *error) {
            [DIMOAPIManager handleErrorForOperation:operation
                                              error:error
                                         completion:completion];
        }];
    } else {
        for (NSString *key in headers) {
            [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
        [manager GET:urlString parameters:params success:^(DAFHTTPRequestOperation *operation, id responseObject) {
            [DIMOAPIManager handleSuccessForOperation:operation
                                       responseObject:responseObject
                                           completion:completion];
        } failure:^(DAFHTTPRequestOperation *operation, NSError *error) {
            [DIMOAPIManager handleErrorForOperation:operation
                                              error:error
                                         completion:completion];
        }];
    }
}

+ (void)handleSuccessForOperation:(DAFHTTPRequestOperation *)operation
                   responseObject:(id)responseObject
                       completion:(void(^)(DAFHTTPRequestOperation *operation, id responseObject, NSError *err))completion
{
    static int successCode = 200;
    id result = nil;
    NSString *response = operation.responseString;
    if (response && response != NULL) {
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (completion && completion != NULL) {
        if (operation.response.statusCode == successCode) {
            if ([result isKindOfClass:[NSArray class]]) {
                // means success with array
                completion(operation, result, nil);
                return;
            }
            
            if ([[result objectForKey:@"result"] isEqualToString:kDIMO_RESULT_SUCCESS]) {
                completion(operation, result, nil);
            } else if ([[result objectForKey:@"result"] isEqualToString:kDIMO_RESULT_NOK]) {
                NSError *err = [NSError errorWithDomain:@"NOK"
                                                   code:operation.response.statusCode
                                               userInfo:result];
                completion(operation, result, err);
            } else {
                NSError *err = [NSError errorWithDomain:@"Unknown result type"
                                                   code:operation.response.statusCode
                                               userInfo:result];
                completion(operation, result, err);
            }
        } else {
            // 401 for authentication error
            if (operation.response.statusCode == errorCode401) {
                DLog(@"Error code 401");
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_SIMASPAY_AUTHENTICATION_ERROR object:nil];
            } else {
                NSError *err = [NSError errorWithDomain:@"ConnectionManagerError:StatusCodeNot200"
                                                   code:operation.response.statusCode
                                               userInfo:@{@"error" : @"Status code not 200"}];
                completion(operation, result, err);
            }
        }
    }
}

+ (void)handleErrorForOperation:(DAFHTTPRequestOperation *)operation
                          error:(NSError *)error
                     completion:(void(^)(DAFHTTPRequestOperation *operation, id responseObject, NSError *err))completion
{
    id result = nil;
    NSString *response = operation.responseString;
    if (response && response != NULL) {
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 401 for authentication error
    if (operation.response.statusCode == errorCode401) {
        DLog(@"Error code 401");
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_SIMASPAY_AUTHENTICATION_ERROR object:nil];
    } else if (operation.response.statusCode == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_SIMASPAY_UNKNOWN_ERROR object:nil];
        //completion(operation, result, nil);
    }
    
    DLog([NSString stringWithFormat:@"operation.response.statusCode : %d", (int)operation.response.statusCode]);
    
    if (completion && completion != NULL) {
        completion(operation, result, error);
    }
}

@end
