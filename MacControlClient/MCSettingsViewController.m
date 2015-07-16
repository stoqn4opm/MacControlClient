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

-(void)viewWillAppear:(BOOL)animated{
    
    if ([[[AppManager sharedManager]clientSocket]isConnected]) {
        [self goIntoConnectedState];
    }else{
        [self goIntoDisconnectedState];
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(goIntoConnectedState:) name:@"Connected" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(goIntoDisconnectedState) name:@"Disconnected" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self setupAddressInput];
    [self setupKeboardResignOnLostFocus];
    [self setupConnectButton];
}

// Mouse clicks ************************************************************************************
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
// End Mouse clicks ********************************************************************************

// Toolbar Clicks **********************************************************************************
-(void) setupSetingsButton{
    [self.btnSettings setUserInteractionEnabled:YES];
    UITapGestureRecognizer *settingsTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsTappedAction)];
    [settingsTapped setNumberOfTapsRequired:1];
    [settingsTapped setNumberOfTouchesRequired:1];
    [self.btnSettings addGestureRecognizer:settingsTapped];
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
// End Toolbar Clicks ******************************************************************************

// Settings Body Clicks ****************************************************************************
-(void)setupAutoConnectButton{
    [self.btnAutoConnect setUserInteractionEnabled:YES];
    UITapGestureRecognizer *autoconnectTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoConnectTappedAction)];
    [autoconnectTapped setNumberOfTapsRequired:1];
    [autoconnectTapped setNumberOfTouchesRequired:1];
    [self.btnAutoConnect addGestureRecognizer:autoconnectTapped];
}

-(void)setupAddressInput{
    self.txtHost.delegate = self;
    self.txtPort.delegate = self;
}

-(void)setupConnectButton{
    [self.btnConnection setUserInteractionEnabled:YES];
    UITapGestureRecognizer *connectionTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(connectionTappedAction)];
    [connectionTapped setNumberOfTapsRequired:1];
    [connectionTapped setNumberOfTouchesRequired:1];
    [self.btnConnection addGestureRecognizer:connectionTapped];
}
// End Settings Body Clicks ************************************************************************


-(void)setupKeboardResignOnLostFocus{
    [self.view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *loseFocusRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllRespondersForTextInput)];
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

        if ([self.txtHost isFirstResponder] || [self.txtPort isFirstResponder]) {
            [self resignRespondersForTextInput];
            return;
        }
        if ([_kbInvoker isFirstResponder]) {
            [_kbInvoker resignFirstResponder];
        }else{
            [_kbInvoker becomeFirstResponder];
        }

    }];
}

-(void)resignRespondersForTextInput{
    [self.txtHost resignFirstResponder];
    [self.txtPort resignFirstResponder];
}

-(void)resignAllRespondersForTextInput{
    [self resignRespondersForTextInput];
    [_kbInvoker resignFirstResponder];
}

-(void)connectionTappedAction{
    [self.btnConnection setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnConnection setAlpha:1];
    }completion:^(BOOL finished) {
        
        if ([[[AppManager sharedManager]clientSocket] isConnected]) {
            [[AppManager sharedManager] disconnect];
        }else{
            [[AppManager sharedManager] connectToHost:self.txtHost.text port:self.txtPort.text.integerValue];
            [self.lblStatus setTextColor:[UIColor yellowColor]];
            [self.lblStatus setText:@"CONNECTING..."];
        }
    }];
}

-(void)goIntoConnectedState:(NSNotification *)notification {
    
    NSDictionary *notifInfo = notification.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.lblStatus setTextColor:[UIColor greenColor]];
        [self.lblStatus setText:@"CONNECTED"];
        [self.btnConnection setText:@"DISCONNECT"];
        [self.txtHost setUserInteractionEnabled:NO];
        [self.txtHost setText:[notifInfo valueForKey:@"Host"]];
        [self.txtHost setTextColor:[UIColor grayColor]];
        [self.txtPort setUserInteractionEnabled:NO];
        [self.txtPort setText:[notifInfo valueForKey:@"Port"]];
        [self.txtPort setTextColor:[UIColor grayColor]];
    });
}

-(void)goIntoConnectedState {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.lblStatus setTextColor:[UIColor greenColor]];
        [self.lblStatus setText:@"CONNECTED"];
        [self.btnConnection setText:@"DISCONNECT"];
        [self.txtHost setUserInteractionEnabled:NO];
        [self.txtHost setText:[[[AppManager sharedManager] clientSocket]connectedHost]];
        [self.txtHost setTextColor:[UIColor grayColor]];
        [self.txtPort setUserInteractionEnabled:NO];
        [self.txtPort setText:[NSString stringWithFormat:@"%d",[[[AppManager sharedManager] clientSocket]connectedPort]]];
        [self.txtPort setTextColor:[UIColor grayColor]];
    });
}

-(void)goIntoDisconnectedState{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [self.lblStatus setTextColor:[UIColor redColor]];
    [self.lblStatus setText:@"NOT CONNECTED"];
    [self.btnConnection setText:@"CONNECT"];
    [self.txtHost setUserInteractionEnabled:YES];
    [self.txtHost setTextColor:[UIColor whiteColor]];

    [self.txtPort setUserInteractionEnabled:YES];
    [self.txtPort setTextColor:[UIColor whiteColor]];

    });
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
    if (textField == self.txtHost){
        if ([textField.text  matchesRegEx:IP_REGEX]) {
            return YES;
        }else{
            [[AppManager sharedManager] showAlertWithType:MCALERT_TYPE_INVALID_IP_ENTERED];
            return YES;
        }
    }else if (textField == self.txtPort){
        if (textField.text.integerValue > 0 && textField.text.integerValue < 65536) {
            return YES;
        }else{
            [[AppManager sharedManager] showAlertWithType:MCALERT_TYPE_INVALID_PORT_ENTERED];
            return YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.txtHost || textField == self.txtPort) {
        [textField resignFirstResponder];
    }
    return YES;
}
@end
