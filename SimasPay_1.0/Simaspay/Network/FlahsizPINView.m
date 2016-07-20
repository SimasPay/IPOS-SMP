//
//  FlahsizPINView.m
//  Simaspay
//
//  Created by Rajesh Pothuraju on 15/07/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

#import "FlahsizPINView.h"
#import "DimoConstants.h"
#import "SimasPayPlistUtility.h"

typedef void (^FZDismissCompletionCallback)(void);


@interface FlahsizPINView () <UITextFieldDelegate>

@property UIView *customLoginView;
@property UITextField *createNewTextField;

@end

@implementation FlahsizPINView

- (id)initFlahsizView
{
    self = [super init];
    if(self){
    
        CGRect rect= [UIScreen mainScreen].bounds;
        self.frame = rect;
            }
    return self;
}


- (void)show{
    
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    self.frame = mainWindow.frame;
    [mainWindow addSubview:self];
    
    [self setupSubviews];
    
    [UIView animateWithDuration:0.3f animations:^{
        
    }];
}




-(void) setupSubviews
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"silver bg"]];
    backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);;
    [self addSubview:backgroundImageView];
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    customView.backgroundColor = [UIColor clearColor];
    [self addSubview:customView];
    
    //btn-back
    
    
    UIButton *leftMenuBtn =[[UIButton alloc] init];
    [leftMenuBtn setImage:[UIImage imageNamed:@"btn-back"] forState:UIControlStateNormal];
    leftMenuBtn.frame = CGRectMake(15, 30, 15, 23);
    [leftMenuBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:leftMenuBtn];
    
    UIImageView *simasPayLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-simaspay"]];
    simasPayLogo.frame = CGRectMake((self.frame.size.width-280)/2, 100, 280, 65);
    [customView addSubview:simasPayLogo];
    
    
    NSString *currentMDN = [SimasPayPlistUtility getDataFromPlistForKey:SOURCEMDN];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, simasPayLogo.frame.origin.y+simasPayLogo.frame.size.height + 30, self.frame.size.width, 21)];
    label.numberOfLines = 0;
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
    else
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0f];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Silakan masukkan mPIN untuk nomor HP %@",currentMDN];
    CGRect currentFrame = label.frame;
    label.textColor = [SimasPayPlistUtility colorFromHexString:@"#5B5B5B"];

    NSMutableAttributedString *attributesString3 =  [[NSMutableAttributedString alloc] initWithString:label.text];
    NSDictionary *mediumFontattribute3 = [NSDictionary dictionaryWithObject:label.font forKey:NSFontAttributeName];
    [attributesString3 addAttribute:NSForegroundColorAttributeName value:[SimasPayPlistUtility colorFromHexString:@"#494949"] range:[label.text rangeOfString:currentMDN]];
    [attributesString3 addAttributes:mediumFontattribute3 range:[label.text rangeOfString:currentMDN]];
    label.attributedText = attributesString3;
    
    
    CGSize max = CGSizeMake(label.frame.size.width, 500);
    CGSize expected = [label.text boundingRectWithSize:max options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: label.font} context:nil].size;
    currentFrame.size.height = expected.height;
    label.frame = currentFrame;
    [customView addSubview:label];
    
    
    self.createNewTextField = [[UITextField alloc] init];
    self.createNewTextField.borderStyle = UITextBorderStyleNone;
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5){
        self.createNewTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
        self.createNewTextField.frame = CGRectMake(20, label.frame.origin.y+label.frame.size.height+15, self.frame.size.width-40, 50);
    }else{
        self.createNewTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        self.createNewTextField.frame = CGRectMake(30, label.frame.origin.y+label.frame.size.height+15, self.frame.size.width-60, 50);
    }
    
    
    self.createNewTextField.borderStyle = UITextBorderStyleNone;
    self.createNewTextField.backgroundColor = [UIColor whiteColor];
    self.createNewTextField.placeholder = @"mPIN";
    self.createNewTextField.delegate = self;
    self.createNewTextField.secureTextEntry = YES;
    self.createNewTextField.keyboardType = UIKeyboardTypeNumberPad;
    [customView addSubview:self.createNewTextField];
    
    
    
    UIView *pinLeftView = [[UIView alloc] init];
    pinLeftView.frame = CGRectMake(0, 0, 20+20, self.createNewTextField.frame.size.height);
    UIImageView *pinLockImage = [[UIImageView alloc] init];
    pinLockImage.frame = CGRectMake(10, (self.createNewTextField.frame.size.height-25)/2, 20 , 25);
    pinLockImage.image = [UIImage imageNamed:@"mPin"];
    [pinLeftView addSubview:pinLockImage];
    
    self.createNewTextField.leftView = pinLeftView;
    self.createNewTextField.leftViewMode = UITextFieldViewModeAlways;

    self.createNewTextField.layer.cornerRadius = 5;
    
    self.createNewTextField.layer.masksToBounds = NO;
    self.createNewTextField.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.createNewTextField.layer.shadowOpacity = 0.5;
    self.createNewTextField.layer.shadowOffset = CGSizeMake(2, 2);
    self.createNewTextField.layer.shadowRadius = 0.5;
    
    
}


-(IBAction)backButtonClicked:(id)sender
{
    [self dismissPicker:^{
        
        if([self.delegate respondsToSelector:@selector(flashizPINViewDidClickCancleButton:)]){
            [self.delegate flashizPINViewDidClickCancleButton:self];
        }
        
    }];
}


- (void)dismissPicker:(FZDismissCompletionCallback)completion{
        
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    }completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
    } completion:^(BOOL finished) {
        if(finished){
            if(completion){
                completion();
            }
            [self removeFromSuperview];
        }
    }];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 6) {
        return NO;
    }
    if (newLength == 6) {
        
        [self dismissPicker:^{
            
            if([self.delegate respondsToSelector:@selector(flashizPINViewDidClickOKButton:withMPIN:)]){
                [self.delegate flashizPINViewDidClickOKButton:self withMPIN:[textField.text stringByReplacingCharactersInRange:range withString:string]];
            }
            
        }];
        return YES;
    }
    
    
    return YES;
}

@end
