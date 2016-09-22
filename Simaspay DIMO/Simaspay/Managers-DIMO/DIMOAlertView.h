//
//  DIMOAlertView.h
//  DIMOPayiOS
//
//

#import <UIKit/UIKit.h>

@interface DIMOAlertView : UIAlertView
+ (void)showAlertWithMessage:(NSString *)message
                  alertStyle:(UIAlertViewStyle)alertStyle
clickedButtonAtIndexCallback:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle;


+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                alertStyle:(UIAlertViewStyle)alertStyle
clickedButtonAtIndexCallback:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)hideAllAlert;

+ (void)showUnknownErrorCallback:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback;
@end
