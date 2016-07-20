//
//  AppInfo.h
//  dimopay-iOS
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DIMOInvoiceModel.h"
#import "DIMOFidelitizModel.h"

typedef enum {
    ServerURLUat,
    ServerURLDev,
    ServerURLLive
} ServerURL;


typedef enum {
    SDKLocaleEnglish,
    SDKLocaleIndonesian,
} SDKLocale;

typedef enum {
    PaymentStatusSuccess,
    PaymentStatusFailed,
    PaymentStatusFailedTimeOut,
    
    // used for error dialog only
    PaymentStatusFailedInvalidQR,
    PaymentStatusFailedAuthenticationError,
    PaymentStatusFailedUnknownError,
    PaymentStatusFailedMinimumTransaction,
    PaymentStatusFailedInternetConnection,
} PaymentStatus;

@protocol DIMOPayDelegate;

@interface DIMOPay : NSObject
@property (nonatomic, strong) NSString *callbackUrl;

+ (DIMOPay*)sharedInstance;

/// Start SDK from controller and with delegate
+ (void)startSDK:(UIViewController *)parentView withDelegate:(id<DIMOPayDelegate>)delegate;

/// Start SDK with loyalty list, and without scanner page
+ (void)startLoyalty:(UIViewController *)parentView withDelegate:(id<DIMOPayDelegate>)delegate;

/// Start SDK, used for in-app flow that need invoice id from other apps. and callbackURL for after finished or close SDK action
+ (void)startSDK:(UIViewController *)parentView withDelegate:(id<DIMOPayDelegate>)delegate invoiceId:(NSString *)invoiceId andCallBackURL:(NSString *)callback;

/// Force close SDK from host-app
+ (void)closeSDK;

/// Set server URL, default Live
+ (void)setServerURL:(ServerURL)serverUrl;

/// Set minimum transaction, default 0
+ (void)setMinimumTransaction:(int)minimumTrx;
+ (int)getMinimumTransaction;

/// isInAppModule will become YES, if SDK started with invoiceId
+ (BOOL)isInAppModule;

/// Eula Setter and Getter
+ (void)setEULAState:(BOOL)state;
+ (BOOL)getEULAState;

/// User API Key Setter and Getter
+ (void)setUserAPIKey:(NSString *)apiKey;
+ (NSString *)getUserAPIKey;

/// Remove user api key
+ (void)resetUserAPIKey;

/// isPolling Setter and Getter, isPolling is flag for SDK to doing automatic check status payment to server, default is YES. if host-app set isPolling to NO, host-app need to call "notifyTransaction" after doing payment
+ (void)setIsPolling:(BOOL)isPolling;
+ (BOOL)isPolling;

/// isUsingCustomDialog Setter and Getter, isUsingCustomDialog YES means SDK will call "callbackShowDialog" so host-app need to do something to display their own error dialog
+ (void)setIsUsingCustomDialog:(BOOL)isUsingCustomDialog;
+ (BOOL)isUsingCustomDialog;

/// Send Notification for payment status, to open success or error page in SDK.
+ (void)notifyTransaction:(PaymentStatus)paymentStatus withMessage:(NSString *)message isDefaultLayout:(BOOL)isDefaultLayout;

/// Create EULA from URL
+ (UIViewController *)EULAWithURL:(NSString *)URL;
/// Create EULA with HTML Code
+ (UIViewController *)EULAWithStringHTML:(NSString *)content;

/// This function to change SDK language
+ (void)setSDKLocale:(SDKLocale)locale;

@property (nonatomic, weak) id<DIMOPayDelegate> delegate;
@end


@protocol DIMOPayDelegate <NSObject>;

/// This function will be called when EULA state is false
/// Return view controller, there is a standard view controller for eula or using your own EULA view controller
/// example : [DIMOPay EULAWithStringHTML:@"test<br>Test2"];
- (UIViewController *)callbackShowEULA;

/// This function will be called when the EULA state changed
- (void)callbackEULAStateChanged:(BOOL)state;

/// This function will be called when the SDK opened at the first time or there is no user api key found
- (void)callbackGenerateUserAPIKey;

/// This function will be called when user cancel process payment or close invoice summary
- (void)callbackUserHasCancelTransaction;

/// This function will be called when user clicked pay button and host-app need to doing payment here
- (void)callbackPayInvoice:(DIMOInvoiceModel *)invoice;

/// This function will be called when isUsingCustomDialog is Yes, and host-app need to show their own dialog
- (void)callbackShowDialog:(PaymentStatus)paymentStatus withMessage:(NSString *)message andLoyaltyModel:(DIMOFidelitizModel *)fidelitiz;

/// This function will be called when the sdk has been closed
- (void)callbackSDKClosed;

/// This function will be called when lost internet connection error page appear
- (void)callbackLostConnection;

/// Return true to close sdk
/// This function will be called when invalid qr code error page appear
- (BOOL)callbackInvalidQRCode;

/// Return true to close sdk
/// This function will be called when payment failed error page appear
- (BOOL)callbackTransactionStatus:(PaymentStatus)paymentStatus withMessage:(NSString *)message;

/// Return true to close sdk
/// This function will be called when unknown error page appear
- (BOOL)callbackUnknowError;

/// This function will be called when authentication error page appear
- (void)callbackAuthenticationError;

@end
