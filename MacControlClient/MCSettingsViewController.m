//
//  MCSettingsViewController.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/15/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCSettingsViewController.h"
#import "MCIconTapHandler.h"
#import "AppManager.h"
#import "NSString+MCRegExp.h"

@interface MCSettingsViewController () <UITextFieldDelegate>{
    UITextField *_kbInvoker;
}
@property (weak, nonatomic) IBOutlet UIImageView *btnClose;
@property (weak, nonatomic) IBOutlet UIImageView *btnMinimize;
@property (weak, nonatomic) IBOutlet UIImageView *btnFullScreen;
@property (weak, nonatomic) IBOutlet UIImageView *btnKeyboard;
@property (weak, nonatomic) IBOutlet UIImageView *btnSettings;


@property (weak, nonatomic) IBOutlet UITextField *txtHost;
@property (weak, nonatomic) IBOutlet UITextField *txtPort;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *btnConnection;
@property (weak, nonatomic) IBOutlet UILabel *btnSaveHost;
@property (weak, nonatomic) IBOutlet UILabel *btnInstructions;
@property (weak, nonatomic) IBOutlet UILabel *btnLoadHost;
@property (weak, nonatomic) IBOutlet UILabel *btnAutoConnect;


@property (weak, nonatomic) IBOutlet UIView  *btnLeftClick;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftClick;
@property (weak, nonatomic) IBOutlet UIView  *btnRightClick;
@property (weak, nonatomic) IBOutlet UILabel *lblRightClick;

@end

@implementation MCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUserInteraction];
}

#pragma mark - UI Prep methods


-(void)setupUserInteraction{
    [self setupAutoConnectButton];
    [self setupCloseButton];
    [self setupFullScreenButton];
    [self setupLeftClickButton];
    [self setupMinimizeButton];
    [self setupRightClickButton];
    [self setupSetingsButton];
    [self setupKeyboardButton];
}

-(void) setupSetingsButton{
    [self.btnSettings setUserInteractionEnabled:YES];
    UITapGestureRecognizer *settingsTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsTappedAction)];
    [settingsTapped setNumberOfTapsRequired:1];
    [settingsTapped setNumberOfTouchesRequired:1];
    [self.btnSettings addGestureRecognizer:settingsTapped];
}

-(void)setupLeftClickButton{
    [self.btnLeftClick setUserInteractionEnabled:YES];
    UITapGestureRecognizer *leftClickTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftClickTappedAction)];
    [leftClickTapped setNumberOfTapsRequired:1];
    [leftClickTapped setNumberOfTouchesRequired:1];
    [self.btnLeftClick addGestureRecognizer:leftClickTapped];
}

-(void)setupRightClickButton{
    [self.btnRightClick setUserInteractionEnabled:YES];
    UITapGestureRecognizer *leftClickTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClickTappedAction)];
    [leftClickTapped setNumberOfTapsRequired:1];
    [leftClickTapped setNumberOfTouchesRequired:1];
    [self.btnRightClick addGestureRecognizer:leftClickTapped];
}

-(void)setupFullScreenButton{
    [self.btnFullScreen setUserInteractionEnabled:YES];
    UITapGestureRecognizer *fullscreenTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullscreenWindowTappedAction)];
    [fullscreenTapped setNumberOfTapsRequired:1];
    [fullscreenTapped setNumberOfTouchesRequired:1];
    [self.btnRightClick addGestureRecognizer:fullscreenTapped];
}

-(void)setupMinimizeButton{
    [self.btnMinimize setUserInteractionEnabled:YES];
    UITapGestureRecognizer *minimizeTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minimizeWindowTappedAction)];
    [minimizeTapped setNumberOfTapsRequired:1];
    [minimizeTapped setNumberOfTouchesRequired:1];
    [self.btnMinimize addGestureRecognizer:minimizeTapped];
}

-(void)setupCloseButton{
    [self.btnClose setUserInteractionEnabled:YES];
    UITapGestureRecognizer *closeTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindowTappedAction)];
    [closeTapped setNumberOfTapsRequired:1];
    [closeTapped setNumberOfTouchesRequired:1];
    [self.btnClose addGestureRecognizer:closeTapped];
}

-(void)setupAutoConnectButton{
    [self.btnAutoConnect setUserInteractionEnabled:YES];
    UITapGestureRecognizer *autoconnectTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoConnectTappedAction)];
    [autoconnectTapped setNumberOfTapsRequired:1];
    [autoconnectTapped setNumberOfTouchesRequired:1];
    [self.btnAutoConnect addGestureRecognizer:autoconnectTapped];
}

-(void)setupKeyboardButton{
    _kbInvoker = [UITextField new];
    _kbInvoker.delegate = self;
    [_kbInvoker setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.view addSubview:_kbInvoker];
    
    [self.btnKeyboard setUserInteractionEnabled:YES];
    UITapGestureRecognizer *keyboardInvoke =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardTappedAction)];
    [keyboardInvoke setNumberOfTapsRequired:1];
    [keyboardInvoke setNumberOfTouchesRequired:1];
    [self.btnKeyboard addGestureRecognizer:keyboardInvoke];
}

-(void)setupAddressInput{
    self.txtHost.delegate = self;
    self.txtPort.delegate = self;
    UITapGestureRecognizer *loseFocusRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignRespondersForTextInput)];
    [loseFocusRecognizer setNumberOfTapsRequired:1];
    [loseFocusRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:loseFocusRecognizer];
}

#pragma mark - User Interactions
-(void)settingsTappedAction{
    [self.btnSettings setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnSettings setAlpha:1];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)leftClickTappedAction{
    [self.lblLeftClick setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.lblLeftClick setAlpha:1];
    }completion:^(BOOL finished) {
        [[AppManager sharedManager] sendLeftClickMessage];
    }];
}

-(void)rightClickTappedAction{
    [self.lblRightClick setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.lblRightClick setAlpha:1];
    }completion:^(BOOL finished) {
        [[AppManager sharedManager] sendRightClickMessage];
    }];
}

-(void)fullscreenWindowTappedAction{
    [self.btnFullScreen setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnFullScreen setAlpha:1];
    }completion:^(BOOL finished) {
        [[AppManager sharedManager] sendFullscreenWindowMessage];
    }];
}

-(void)minimizeWindowTappedAction{
    [self.btnMinimize setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnMinimize setAlpha:1];
    }completion:^(BOOL finished) {
        [[AppManager sharedManager] sendMinimizeWindowMessage];
    }];
}

-(void)closeWindowTappedAction{
    [self.btnClose setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnClose setAlpha:1];
    }completion:^(BOOL finished) {
        [[AppManager sharedManager] sendCloseWindowMessage];
    }];
}

-(void)autoConnectTappedAction{
    [self.btnAutoConnect setAlpha:0];
    if ([self.btnAutoConnect.text isEqualToString:@"ON"]) {
        [self.btnAutoConnect setTextColor:[UIColor redColor]];
        [self.btnAutoConnect setText:@"OFF"];
    }else{
        [self.btnAutoConnect setTextColor:[UIColor greenColor]];
        [self.btnAutoConnect setText:@"ON"];
    }
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnAutoConnect setAlpha:1];
    }completion:^(BOOL finished) {
#warning implement autoconnect logic
    }];
}

-(void)keyboardTappedAction{
    [self.btnKeyboard setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnKeyboard setAlpha:1];
    }completion:^(BOOL finished) {
        if ([_kbInvoker isFirstResponder]) {
            [_kbInvoker resignFirstResponder];
            [self resignRespondersForTextInput];
        }else{
            [_kbInvoker becomeFirstResponder];
        }
    }];
}

-(void)resignRespondersForTextInput{
    [self.txtHost resignFirstResponder];
    [self.txtPort resignFirstResponder];
}

#pragma mark - <UITextFieldDelegate> Methods
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    if (textField == _kbInvoker) {
        [[AppManager sharedManager] sendKeyTyped:[string characterAtIndex:0]];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == _kbInvoker) {
        return YES;
    }else if (textField == self.txtHost){
        if ([textField.text  matchesRegEx:IP_REGEX]) {
            return YES;
        }else{
            
        }
    }

}
@end
