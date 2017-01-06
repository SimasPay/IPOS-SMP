//
//  DIMOAlertView.m
//  DIMOPayiOS
//
//

#import "DIMOAlertView.h"
#import "DIMOUtility.h"

typedef void(^AlertCallback)(NSInteger buttonIndex, UIAlertView *alert);

@interface DIMOAlertView () <UIAlertViewDelegate>
//@property (nonatomic, strong) AlertCallback alertCallback;

@property (nonatomic, strong) NSMutableDictionary *alertCallBackDictionary;
@property (nonatomic, strong) NSMutableArray *alertArray;
@end

@implementation DIMOAlertView
static NSString *const ApplicationNameString = @"DIMO";
static NSString *const NOT_IMPLEMENTED_MESSAGE = @"Not implemented yet";

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle {
    
    [self showAlertWithTitle:title
                     message:message
                  alertStyle:UIAlertViewStyleDefault
clickedButtonAtIndexCallback:nil
           cancelButtonTitle:cancelButtonTitle ? cancelButtonTitle : @"OK"
           otherButtonTitles: nil];
}

+ (void)showAlertWithMessage:(NSString *)message
                  alertStyle:(UIAlertViewStyle)alertStyle
clickedButtonAtIndexCallback:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    [self showAlertWithTitle:ApplicationNameString
                     message:message
                  alertStyle:alertStyle
clickedButtonAtIndexCallback:callback
           cancelButtonTitle:cancelButtonTitle ? cancelButtonTitle : @"OK"
           otherButtonTitles:otherButtonTitles, nil];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                alertStyle:(UIAlertViewStyle)alertStyle
clickedButtonAtIndexCallback:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    [self showAlertWithTitle:title message:message view:nil alertStyle:alertStyle clickedButtonAtIndexCallback:callback cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles , nil];
}

+ (void)showNormalTitle:(NSString *)title
          message:(NSString *)message
       alertStyle:(UIAlertViewStyle)alertStyle
clickedButtonAtIndexCallback:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback
      cancelButtonTitle:(NSString *)cancelButtonTitle {
//otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    [self showAlertWithTitle:title message:message view:nil alertStyle:alertStyle clickedButtonAtIndexCallback:callback cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                      view:(UIView *)view
                alertStyle:(UIAlertViewStyle)alertStyle
clickedButtonAtIndexCallback:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertWithTitle:title message:message alertStyle:alertStyle clickedButtonAtIndexCallback:callback cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
        });
        return;
    }
    
    DIMOAlertView *obj = [self getSharedAlertView];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:obj cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    alert.alertViewStyle = alertStyle;
    if (!title) {
        alert.title = @" ";
    }
//    alert.message = @"message";
    while ([obj.alertCallBackDictionary objectForKey:@(alert.tag)]) {
        alert.tag = rand()%1000;
    }
    
    if (view) {
        UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, MAX(100, view.frame.size.height))];
        [temp addSubview:view];
        [alert setValue:temp forKey:@"accessoryView"];
    }
    [alert show];
    
    
    [obj.alertArray addObject:alert];
    if (callback) {
        [obj.alertCallBackDictionary setObject:callback forKey:@(alert.tag)];
    }
}

+ (void)hideAllAlert {
    DIMOAlertView *obj = [self getSharedAlertView];
    
    [obj.alertArray enumerateObjectsUsingBlock:^(UIAlertView *alert , NSUInteger idx, BOOL *stop) {
        [alert removeFromSuperview];
    }];
    
    [obj.alertArray removeAllObjects];
    [obj.alertCallBackDictionary removeAllObjects];
}

+ (void)showPromptWithMessage:(NSString *) message
                      okTitle:(NSString *) stringOkBtn
                     complete:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback {
    [self showAlertWithTitle:nil message:message alertStyle:UIAlertViewStyleDefault clickedButtonAtIndexCallback:callback cancelButtonTitle:@"Cancel" otherButtonTitles:stringOkBtn, nil];
}

+ (void)showPromptWithTitle:(NSString *)title
                       view:(UIView *)view
                      okTitle:(NSString *) stringOkBtn
                     complete:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback {
    [self showAlertWithTitle:title message:nil view:view alertStyle:UIAlertViewStyleDefault clickedButtonAtIndexCallback:callback cancelButtonTitle:@"Cancel" otherButtonTitles:stringOkBtn, nil];
}
+ (void)showUnknownErrorCallback:(void(^)(NSInteger buttonIndex, UIAlertView *alert))callback {
    NSString *title = String(@"DIMOError");
    NSString *message = String(@"DIMOUnknownError");
    [self showAlertWithTitle:title message:message alertStyle:UIAlertViewStyleDefault clickedButtonAtIndexCallback:callback cancelButtonTitle:@"OK" otherButtonTitles:nil];
}
#pragma mark private
+ (DIMOAlertView *)getSharedAlertView {
    DIMOAlertView *obj = [self sharedInstance];
    if (!obj.alertArray) { obj.alertArray = [NSMutableArray array]; }
    if (!obj.alertCallBackDictionary) { obj.alertCallBackDictionary = [NSMutableDictionary dictionary]; }
    
    return obj;
}

#pragma mark UIAlert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DIMOAlertView *obj = [[self class] getSharedAlertView];
    [obj.alertArray removeObject:alertView];
    
    if ([obj.alertCallBackDictionary objectForKey:@(alertView.tag)]) {
        AlertCallback callback = [obj.alertCallBackDictionary objectForKey:@(alertView.tag)];
        callback(buttonIndex, alertView);
        [obj.alertCallBackDictionary removeObjectForKey:@(alertView.tag)];
    }
}

@end
