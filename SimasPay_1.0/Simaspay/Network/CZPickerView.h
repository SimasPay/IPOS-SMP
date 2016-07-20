//
//  CZPickerView.h
//
//  Created by chenzeyu on 9/6/15.
//  Copyright (c) 2015 chenzeyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AUISelectiveBorder.h"

@class CZPickerView;

@protocol CZPickerViewDataSource <NSObject>

@required
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView;

@optional
/*
 Implement at least one of the following method,
 CZPickerView:(CZPickerView *)pickerView
 attributedTitleForRow:(NSInteger)row has higer priority
*/

/* attributed picker item title for each row */
- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView attributedTitleForRow:(NSInteger)row;

- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView attributedDetailTextTitleForRow:(NSInteger)row;

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row;

@end

@protocol CZPickerViewDelegate <NSObject>

@optional

/** delegate method for canceling */
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView;

- (void)czpickerViewDidClickOKButton:(CZPickerView *)pickerView otpText:(NSString *) otpText;

- (void)czpickerViewResendOTP:(CZPickerView *)pickerView;

@end

@interface CZPickerView : UIView <UITextFieldDelegate>

- (id)initWithHeaderTitle:(NSString *)headerTitle messageText:(NSString *)messageText viewController:(UIViewController *) viewController;

/** show the picker */
- (void)show;
- (void)hide;
- (void) reSendOTPSuccess;

@property id<CZPickerViewDelegate> delegate;

@property id<CZPickerViewDataSource> dataSource;

/** whether to show footer (including confirm and cancel buttons), default NO */
@property BOOL needFooterView;

@property BOOL isFlashizView;

/** whether allow tap background to dismiss the picker, default YES */
@property BOOL tapBackgroundToDismiss;

/** picker header background color */
@property (nonatomic, strong) UIColor *headerBackgroundColor;

/** picker header title color */
@property (nonatomic, strong) UIColor *headerTitleColor;

/** picker cancel button background color */
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;

/** picker cancel button normal state color */
@property (nonatomic, strong) UIColor *cancelButtonNormalColor;

/** picker cancel button highlighted state color */
@property (nonatomic, strong) UIColor *cancelButtonHighlightedColor;

/** picker confirm button background color */
@property (nonatomic, strong) UIColor *confirmButtonBackgroundColor;

/** picker confirm button normal state color */
@property (nonatomic, strong) UIColor *confirmButtonNormalColor;

/** picker confirm button highlighted state color */
@property (nonatomic, strong) UIColor *confirmButtonHighlightedColor;

@end
