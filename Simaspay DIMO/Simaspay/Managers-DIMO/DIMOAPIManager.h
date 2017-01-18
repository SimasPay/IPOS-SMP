//
//  APIManager.h
//  DIMOPayiOS
//
//

#import <Foundation/Foundation.h>

//NOTIFICATION KEY
#define kNotif_SIMASPAY_API_NO_INTERNET_CONNECTION  @"kNotif_SIMASPAY_API_NO_INTERNET_CONNECTION"
#define kNotif_SIMASPAY_AUTHENTICATION_ERROR        @"SIMASPAY_ERROR_AUTHENTICATION_TOKEN_NOTIFICATION"
#define kNotif_SIMASPAY_UNKNOWN_ERROR               @"kNotif_SIMASPAY_UNKNOWN_ERROR"

//payment
#define kDIMO_RESULT_SUCCESS                    @"Success"
#define kDIMO_RESULT_NOK                        @"false"

typedef enum {
    ConnectionManagerHTTPMethodGET = 0,
    ConnectionManagerHTTPMethodPOST = 1
} ConnectionManagerHTTPMethod;

@interface DIMOAPIManager : NSObject
+ (instancetype)sharedInstance;
+ (BOOL)isInternetConnectionExist;
+ (NSTimer *)staticTimer;
//+ (void)checkInternetConnection;

#pragma mark - API

+ (void)callAPIWithParameters:(NSDictionary *)dict
        andComplete:(void(^)(NSDictionary *response, NSError *err))completion;

+ (void)callAPIWithParameters:(NSDictionary *)dict
             withSessionCheck:(Boolean)isCheck
                  andComplete:(void(^)(NSDictionary *response, NSError *err))completion;

+ (void)callAPIPOSTWithParameters:(NSDictionary *)dict
                      andComplete:(void(^)(NSDictionary *response, NSError *err))completion;
@end

@interface NSURLRequest (SSLValidation)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;

@end
