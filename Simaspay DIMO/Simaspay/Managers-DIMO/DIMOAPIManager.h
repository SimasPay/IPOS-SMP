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
#define kDIMO_RESULT_SUCCESS                    @"success"
#define kDIMO_RESULT_NOK                        @"NOK"
#define kDIMO_ERROR_MESSAGE                     @"errorMessage"

typedef enum {
    ConnectionManagerHTTPMethodGET = 0,
    ConnectionManagerHTTPMethodPOST = 1
} ConnectionManagerHTTPMethod;

@interface DIMOAPIManager : NSObject
+ (instancetype)sharedInstance;
+ (void)setEnvironment:(NSString *)environment;
+ (BOOL)isInternetConnectionExist;
//+ (void)checkInternetConnection;
+ (NSString *)errorMessageFrom:(NSError *)error;
@end
