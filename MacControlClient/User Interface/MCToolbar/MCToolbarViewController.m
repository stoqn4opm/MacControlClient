//
//  MCToolbarViewController.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/18/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCToolbarViewController.h"
#import "AppManager.h"
#import "MCMainViewController.h"
#import "MCSettingsViewController.h"

@interface MCToolbarViewController () <UITextFieldDelegate>{
    UITextField *_kbInvoker;
}
@property (weak, nonatomic) IBOutlet UIImageView *btnClose;
@property (weak, nonatomic) IBOutlet UIImageView *btnMinimize;
@property (weak, nonatomic) IBOutlet UIImageView *btnFullScreen;
@property (weak, nonatomic) IBOutlet UIImageView *btnKeyboard;
@property (weak, nonatomic) IBOutlet UIImageView *btnSettings;
@end

@implementation MCToolbarViewController


-(void)viewDidLoad{
    [self setupUserInteraction];
}

#pragma mark - Toolbar Actions
-(void)setupUserInteraction{

    [self setupCloseButton];
    [self setupFullScreenButton];
    [self setupMinimizeButton];
    [self setupSetingsButton];
    [self setupKeyboardButton];
    [self setupKeboardResignOnLostFocus];
}

#pragma mark Close Button
-(void)setupCloseButton{
    [self.btnClose setUserInteractionEnabled:YES];
    UITapGestureRecognizer *closeTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindowTappedAction)];
    [closeTapped setNumberOfTapsRequired:1];
    [closeTapped setNumberOfTouchesRequired:1];
    [self.btnClose addGestureRecognizer:closeTapped];
}

-(void)closeWindowTappedAction{
    [self.btnClose setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnClose setAlpha:1];
    }];
    [[AppManager sharedManager] sendCloseWindowMessage];
}

#pragma mark Fullscreen Button
-(void)setupFullScreenButton{
    [self.btnFullScreen setUserInteractionEnabled:YES];
    UITapGestureRecognizer *fullscreenTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullscreenWindowTappedAction)];
    [fullscreenTapped setNumberOfTapsRequired:1];
    [fullscreenTapped setNumberOfTouchesRequired:1];
    [self.btnFullScreen addGestureRecognizer:fullscreenTapped];
}

-(void)fullscreenWindowTappedAction{
    [self.btnFullScreen setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnFullScreen setAlpha:1];
    }];
    [[AppManager sharedManager] sendFullscreenWindowMessage];
}

#pragma mark Minimize Button
-(void)setupMinimizeButton{
    [self.btnMinimize setUserInteractionEnabled:YES];
    UITapGestureRecognizer *minimizeTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minimizeWindowTappedAction)];
    [minimizeTapped setNumberOfTapsRequired:1];
    [minimizeTapped setNumberOfTouchesRequired:1];
    [self.btnMinimize addGestureRecognizer:minimizeTapped];
}

-(void)minimizeWindowTappedAction{
    [self.btnMinimize setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnMinimize setAlpha:1];
    }];
    [[AppManager sharedManager] sendMinimizeWindowMessage];
}

#pragma mark Settings Button
-(void) setupSetingsButton{
    [self.btnSettings setUserInteractionEnabled:YES];
    UITapGestureRecognizer *settingsTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsTappedAction)];
    [settingsTapped setNumberOfTapsRequired:1];
    [settingsTapped setNumberOfTouchesRequired:1];
    [self.btnSettings addGestureRecognizer:settingsTapped];
}

-(void)settingsTappedAction{
    [self.btnSettings setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnSettings setAlpha:1];
    }];
    if ([self.parentViewController isKindOfClass:[MCMainViewController class]]) {
        MCMainViewController *parent = (MCMainViewController *)self.parentViewController;
        
        if (parent.settingsContainer.hidden) {
            [parent.settingsContainer setAlpha:0];
            [parent.settingsTop setConstant:8];
            [parent.settingsContainer setHidden:NO];
            [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
                
                [parent.settingsContainer setAlpha:1.0f];
                [parent.view layoutIfNeeded];
            }];
        }else {
            [parent.settingsTop setConstant:100];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignKB" object:self];
            [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
            
                [parent.settingsContainer setAlpha:0];
                [parent.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [parent.settingsContainer setHidden:YES];
            }];
        }
    }
}

#pragma mark Keyboard Button
-(void)setupKeyboardButton{
    _kbInvoker = [UITextField new];
    _kbInvoker.delegate = self;
    [_kbInvoker setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.view addSubview:_kbInvoker];
    [_kbInvoker setText:@"dsas	"];
    [_kbInvoker setHidden:YES];
    [self.btnKeyboard setUserInteractionEnabled:YES];
    UITapGestureRecognizer *keyboardInvoke =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardTappedAction)];
    [keyboardInvoke setNumberOfTapsRequired:1];
    [keyboardInvoke setNumberOfTouchesRequired:1];
    [self.btnKeyboard addGestureRecognizer:keyboardInvoke];
}

-(void)keyboardTappedAction{
    [self.btnKeyboard setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnKeyboard setAlpha:1];
    }];
    if ([_kbInvoker isFirstResponder]) {
        [_kbInvoker resignFirstResponder];
    }else{
        [_kbInvoker becomeFirstResponder];
    }
}


#pragma mark -
-(void)setupKeboardResignOnLostFocus{
    [self.parentViewController.view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *loseFocusRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:_kbInvoker action:@selector(resignFirstResponder)];
    [loseFocusRecognizer setNumberOfTapsRequired:1];
    [loseFocusRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:loseFocusRecognizer];
    
}


#pragma mark - <UITextFieldDelegete> Methods
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{

    if (string.length > 0) {
        [[AppManager sharedManager] sendKeyTyped:[string characterAtIndex:0]];
    }
    else{
        // perform stupid hack in order to be able to send clear when _kbInvoker text is empty
        // it will be fixed when i make my own custom keyboard which will directly send CGKeyCodes
        [textField setText:@"hack"];
        
        // 8 is ASCII key code for backspace
        [[AppManager sharedManager]sendKeyTyped:8];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _kbInvoker) {
        // 13 is ASCII keycode for Carridge return
        [[AppManager sharedManager] sendKeyTyped:13];
    }
    return YES;
}
@end
