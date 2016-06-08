//
//  CZPickerView.h
//
//  Created by chenzeyu on 9/6/15.
//  Copyright (c) 2015 chenzeyu. All rights reserved.
//

#import "CZPickerView.h"
#import "SimasPayPlistUtility.h"

#define CZP_FOOTER_HEIGHT 34.0
#define CZP_HEADER_HEIGHT 34.0
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 
#define CZP_BACKGROUND_ALPHA 0.9
#else
#define CZP_BACKGROUND_ALPHA 0.3
#endif



typedef void (^CZDismissCompletionCallback)(void);

@interface CZPickerView ()
@property NSString *headerTitle;
@property NSString *messateText;
@property NSString *headerTitle1;
@property NSString *cancelButtonTitle;
@property NSString *confirmButtonTitle;
@property UIView *backgroundDimmingView;
@property UIView *containerView;
@property UIView *headerView;
@property UIView *messageView;
@property UIView *footerview;
@property UIView *contentView;
@property UILabel *resendTimerLabel;
@property UIButton *resendButton;
@property NSMutableArray *selectedRows;
@property UITextField *createNewTextField;
@property NSTimer *resendOTPTimer;
@property int resendTimer;
@property UIViewController *parentViewController;

@end

@implementation CZPickerView

- (id)initWithHeaderTitle:(NSString *)headerTitle messageText:(NSString *)messageText viewController:(UIViewController *) viewController{
    self = [super init];
    if(self){
        if([self needHandleOrientation]){
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector:@selector(deviceOrientationDidChange:)
                                                         name:UIDeviceOrientationDidChangeNotification
                                                       object: nil];
        }
        
    
        self.tapBackgroundToDismiss = YES;
        self.needFooterView = NO;
        
        self.parentViewController = viewController;
        
        self.messateText = messageText;
        //self.confirmButtonTitle = confirmButtonTitle;
        //self.cancelButtonTitle = cancelButtonTitle;
        
        self.headerTitle = headerTitle ? headerTitle : @"";
        self.headerTitleColor = [UIColor blackColor];
        
        self.headerBackgroundColor = [UIColor whiteColor];
        
        self.cancelButtonNormalColor = [UIColor whiteColor];
        self.cancelButtonHighlightedColor = [UIColor whiteColor];
        self.cancelButtonBackgroundColor = [UIColor whiteColor];
        
        self.confirmButtonNormalColor = [UIColor whiteColor];
        self.confirmButtonHighlightedColor = [UIColor whiteColor];
        self.confirmButtonBackgroundColor = [UIColor whiteColor];
        
        CGRect rect= [UIScreen mainScreen].bounds;
        self.frame = rect;
    }
    return self;
}

- (void)setupSubviews{
    if(!self.backgroundDimmingView){
        self.backgroundDimmingView = [self buildBackgroundDimmingView];
        [self addSubview:self.backgroundDimmingView];
    }
    
    self.containerView = [self buildContainerView];
    [self addSubview:self.containerView];
    
    self.contentView = [self addCreateNewOptionView];
    [self.containerView addSubview:self.contentView];
    
    self.headerView = [self buildHeaderView];
    [self.containerView addSubview:self.headerView];
    
    self.footerview = [self buildFooterView];
    [self.containerView addSubview:self.footerview];
    
    CGRect frame = self.containerView.frame;
    
    self.containerView.frame = CGRectMake(frame.origin.x,
                                          frame.origin.y,
                                          frame.size.width,
                                          self.headerView.frame.size.height + self.contentView.frame.size.height + self.footerview.frame.size.height);
    self.containerView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    
    [self reSendOTPSuccess];
    
}

- (void)performContainerAnimation {
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)show{
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    self.frame = mainWindow.frame;
    [self.parentViewController.view addSubview:self];
    [self setupSubviews];
    [self performContainerAnimation];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundDimmingView.alpha = CZP_BACKGROUND_ALPHA;
    }];
}

-(void) hide{
    
    [self dismissPicker:^{
        if([self.delegate respondsToSelector:@selector(czpickerViewDidClickCancelButton:)]){
            [self.delegate czpickerViewDidClickCancelButton:self];
        }
    }];
    
}

- (void)dismissPicker:(CZDismissCompletionCallback)completion{
    
    [self.resendOTPTimer invalidate];
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    }completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundDimmingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished){
            if(completion){
                completion();
            }
            [self removeFromSuperview];
        }
    }];
}

- (UIView *)buildContainerView{
    CGAffineTransform transform = CGAffineTransformMake(0.7, 0, 0, 0.7, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    UIView *cv = [[UIView alloc] initWithFrame:newRect];
    cv.layer.cornerRadius = 9.0f;
    cv.clipsToBounds = YES;
    cv.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    return cv;
}

- (UIView *)buildMessageView{
    
    CGAffineTransform transform = CGAffineTransformMake(0.7, 0, 0, 0.7, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);

    CGRect tableRect;
    float heightOffset = CZP_HEADER_HEIGHT + CZP_FOOTER_HEIGHT;
    
    float height = 3 * CZP_HEADER_HEIGHT;
    height = height > newRect.size.height - heightOffset ? newRect.size.height -heightOffset : height;
    tableRect = CGRectMake(0, CZP_HEADER_HEIGHT, newRect.size.width, height);
    
    self.messageView = [[UIView alloc] initWithFrame:tableRect];

    
    
    return self.messageView;
}

- (UIView *)buildBackgroundDimmingView{
    
    UIView *bgView;
    bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2f];
    if(self.tapBackgroundToDismiss){
        [bgView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(cancelButtonPressed:)]];
    }
    return bgView;
}

- (UIView *)buildFooterView{
    if (!self.needFooterView){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    CGRect rect = self.contentView.frame;
    CGRect newRect = CGRectMake(0,
                                rect.origin.y + rect.size.height,
                                rect.size.width,
                                CZP_FOOTER_HEIGHT);
    CGRect leftRect = CGRectMake(0,0, newRect.size.width /2, CZP_FOOTER_HEIGHT);
    CGRect rightRect = CGRectMake(newRect.size.width /2,0, newRect.size.width /2, CZP_FOOTER_HEIGHT);
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:newRect];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:leftRect];
    [cancelButton setTitle:@"Batal" forState:UIControlStateNormal];
    [cancelButton setTitleColor: [SimasPayPlistUtility colorFromHexString:@"#037AFF"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[SimasPayPlistUtility colorFromHexString:@"#037AFF"] forState:UIControlStateHighlighted];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    cancelButton.selectiveBorderFlag = AUISelectiveBordersFlagTop | AUISelectiveBordersFlagRight;
    cancelButton.selectiveBordersColor = [UIColor lightGrayColor];
    cancelButton.selectiveBordersWidth = 0.3;
    
    
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:rightRect];
    [confirmButton setTitle:@"OK" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[SimasPayPlistUtility colorFromHexString:@"#BEBEBE"] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[SimasPayPlistUtility colorFromHexString:@"#BEBEBE"] forState:UIControlStateHighlighted];
    confirmButton.backgroundColor = [UIColor whiteColor];
    [confirmButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.tag = 200;
    confirmButton.selectiveBorderFlag = AUISelectiveBordersFlagTop;
    confirmButton.selectiveBordersColor = [UIColor lightGrayColor];
    confirmButton.selectiveBordersWidth = 0.3;
    
    cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    
    [view addSubview:confirmButton];
    
    return view;
}

- (UIView *)buildHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, CZP_HEADER_HEIGHT)];
    view.backgroundColor = self.headerBackgroundColor;
    NSDictionary *dict = @{NSForegroundColorAttributeName: self.headerTitleColor,
                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f]
                           };
    NSAttributedString *at = [[NSAttributedString alloc] initWithString:self.headerTitle attributes:dict];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (CZP_HEADER_HEIGHT-21)/2, self.contentView.frame.size.width-20, 21)];
    label.attributedText = at;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [SimasPayPlistUtility colorFromHexString:@"#030303"];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 10;
    [view addSubview:label];
    //label.center = view.center;
    return view;
}
- (IBAction)resendButtonPressed:(id)sender{
    
    if([self.delegate respondsToSelector:@selector(czpickerViewResendOTP:)]){
        [self.delegate czpickerViewResendOTP:self];
    }

}

- (void) reSendOTPSuccess
{
    self.resendTimer = 59;
    self.resendTimerLabel.hidden = NO;
    self.resendButton.hidden = YES;
    
    self.resendTimerLabel.text = [NSString stringWithFormat:@"0:%02d",self.resendTimer];
    self.resendOTPTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}
-(void)updateTime
{
    self.resendTimer = self.resendTimer-1;
    
    
    if (self.resendTimer == 0) {
        
        self.resendTimerLabel.text = [NSString stringWithFormat:@"0:%02d",self.resendTimer];
        
        self.resendTimerLabel.hidden = YES;
        self.resendButton.hidden = NO;
        [self.resendOTPTimer invalidate];
        
    }else{
        self.resendTimerLabel.text = [NSString stringWithFormat:@"0:%02d",self.resendTimer];
    }
}

- (IBAction)cancelButtonPressed:(id)sender{
    
    if (self.createNewTextField) {
        [self.createNewTextField resignFirstResponder];
    }
    
    [self dismissPicker:^{
        if([self.delegate respondsToSelector:@selector(czpickerViewDidClickCancelButton:)]){
            [self.delegate czpickerViewDidClickCancelButton:self];
        }
    }];
}

- (IBAction)okButtonPressed:(id)sender{
    
    if (self.createNewTextField.text.length > 0) {
        
        [self dismissPicker:^{
            if([self.delegate respondsToSelector:@selector(czpickerViewDidClickOKButton:otpText:)]){
                [self.delegate czpickerViewDidClickOKButton:self otpText:self.createNewTextField.text];
            }
        }];
        
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"SimasPay" message:@"Masukkan Kode OTP" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


-(UIView *) addCreateNewOptionView
{
    // Header change
    
    CGAffineTransform transform = CGAffineTransformMake(0.7, 0, 0, 0.7, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    CGRect tableRect;
    //float heightOffset = CZP_HEADER_HEIGHT + CZP_FOOTER_HEIGHT;
    float height = 3 * CZP_HEADER_HEIGHT;
    //height = height > newRect.size.height - heightOffset ? newRect.size.height -heightOffset : height;
    tableRect = CGRectMake(0, CZP_HEADER_HEIGHT, newRect.size.width, height);
    
    UIView *contentView  = [[UIView alloc] initWithFrame:tableRect];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, newRect.size.width-20, 21)];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    //label.minimumScaleFactor = 10;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.messateText;
    CGRect currentFrame = label.frame;
    
    CGSize max = CGSizeMake(label.frame.size.width, 500);
    CGSize expected = [label.text boundingRectWithSize:max options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: label.font} context:nil].size;
    currentFrame.size.height = expected.height;
    label.frame = currentFrame;
    [contentView addSubview:label];
    
    self.resendTimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height+5, newRect.size.width, 21)];
    self.resendTimerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    self.resendTimerLabel.hidden = YES;
    self.resendTimerLabel.textColor = [SimasPayPlistUtility colorFromHexString:@"#6E6E6E"];
    self.resendTimerLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:self.resendTimerLabel];
    
    
    self.resendButton = [[UIButton alloc] initWithFrame:CGRectMake(10, label.frame.origin.y+label.frame.size.height+5, newRect.size.width-20, 30)];
    [self.resendButton setTitle:@"Kirim Ulang?" forState:UIControlStateNormal];
    [self.resendButton setTitleColor: [SimasPayPlistUtility colorFromHexString:@"#037AFF"] forState:UIControlStateNormal];
    [self.resendButton setTitleColor:[SimasPayPlistUtility colorFromHexString:@"#037AFF"] forState:UIControlStateHighlighted];
    self.resendButton.backgroundColor = [UIColor whiteColor];
    [self.resendButton addTarget:self action:@selector(resendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.resendButton];
    self.resendButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    
    
    self.createNewTextField = [[UITextField alloc] init];
    self.createNewTextField.frame = CGRectMake(10, self.resendButton.frame.origin.y+self.resendButton.frame.size.height+5, newRect.size.width-20, 25);
    self.createNewTextField.borderStyle = UITextBorderStyleNone;
    self.createNewTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    self.createNewTextField.placeholder = @"6 digit kode OTP.";
    self.createNewTextField.delegate = self;
    self.createNewTextField.secureTextEntry = YES;
    self.createNewTextField.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:self.createNewTextField];
    
    UIView *pwdLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 25)];
    self.createNewTextField.leftView = pwdLeftView;
    self.createNewTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    self.createNewTextField.selectiveBorderFlag = AUISelectiveBordersFlagLeft|AUISelectiveBordersFlagTop|AUISelectiveBordersFlagRight|AUISelectiveBordersFlagBottom;
    
    self.createNewTextField.selectiveBordersColor = [UIColor lightGrayColor];
    self.createNewTextField.selectiveBordersWidth = 0.3;
    
    CGRect newFrame = contentView.frame;
    newFrame.size.height = self.createNewTextField.frame.origin.y+self.createNewTextField.frame.size.height+10;
    contentView.frame = newFrame;
    
    return contentView;
}

- (IBAction)backGesturePressed:(id)sender
{
     [self.createNewTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    self.headerTitle1 = textField.text;
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    UIButton *okButton = (UIButton *) [self.footerview viewWithTag:200];
    
    if (newLength  >= 4) {
        [okButton setTitleColor: [SimasPayPlistUtility colorFromHexString:@"#037AFF"] forState:UIControlStateNormal];
        [okButton setTitleColor:[SimasPayPlistUtility colorFromHexString:@"#037AFF"] forState:UIControlStateHighlighted];
    }else{
        [okButton setTitleColor: [SimasPayPlistUtility colorFromHexString:@"#BEBEBE"] forState:UIControlStateNormal];
        [okButton setTitleColor:[SimasPayPlistUtility colorFromHexString:@"#BEBEBE"] forState:UIControlStateHighlighted];
    }
    
    return YES;
}


#pragma mark - Notification Handler

- (BOOL)needHandleOrientation{
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:@"UISupportedInterfaceOrientations"];
    NSMutableSet *set = [NSMutableSet set];
    for(NSString *o in supportedOrientations){
        NSRange range = [o rangeOfString:@"Portrait"];
        if ( range.location != NSNotFound ) {
            [set addObject:@"Portrait"];
        }
        
        range = [o rangeOfString:@"Landscape"];
        if ( range.location != NSNotFound ) {
            [set addObject:@"Landscape"];
        }
    }
    return set.count == 2;
}

- (BOOL)orientationSupported:(UIDeviceOrientation)orientation{
    NSString *orientationStr;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            orientationStr = @"UIInterfaceOrientationPortrait";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationStr = @"UIInterfaceOrientationPortraitUpsideDown";
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationStr = @"UIInterfaceOrientationLandscapeLeft";
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationStr = @"UIInterfaceOrientationLandscapeRight";
            break;
        default:
            orientationStr = @"Invalid Interface Orientation";
            break;
    }
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:@"UISupportedInterfaceOrientations"];
    for(NSString *o in supportedOrientations){
        if([o hasPrefix:orientationStr]){
            return YES;
        }
    }
    return NO;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification{
    if(![self orientationSupported:[[UIDevice currentDevice] orientation]]){
        return;
    }
    self.frame = [UIScreen mainScreen].bounds;
    for(UIView *v in self.subviews){
        if([v isEqual:self.backgroundDimmingView]) continue;
        
        [UIView animateWithDuration:0.2f animations:^{
            v.alpha = 0.0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
            //as backgroundDimmingView will not be removed
            if(self.subviews.count == 1){
                [self setupSubviews];
                [self performContainerAnimation];
            }
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
