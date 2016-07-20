//
//  FlahsizPINView.h
//  Simaspay
//
//  Created by Rajesh Pothuraju on 15/07/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlahsizPINView;

@protocol FlahsizPINViewDelegate <NSObject>

@optional

- (void)flashizPINViewDidClickCancleButton:(FlahsizPINView *)pickerView;
- (void)flashizPINViewDidClickOKButton:(FlahsizPINView *)pickerView withMPIN:(NSString *) mPINText;

@end

@interface FlahsizPINView : UIView

@property id<FlahsizPINViewDelegate> delegate;

- (id)initFlahsizView;

- (void)show;
@end
