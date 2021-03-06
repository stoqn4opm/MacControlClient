//
//  MCSettingsViewController.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/15/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCSettingsViewController.h"
#import "AppManager.h"
#import "NSString+MCRegExp.h"

@interface MCSettingsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtHost;
@property (weak, nonatomic) IBOutlet UITextField *txtPort;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *btnConnection;
@property (weak, nonatomic) IBOutlet UILabel *btnSaveHost;
@property (weak, nonatomic) IBOutlet UILabel *btnInstructions;
@property (weak, nonatomic) IBOutlet UILabel *btnLoadHost;
@property (weak, nonatomic) IBOutlet UILabel *btnAutoConnect;

@end

@implementation MCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignRespondersForTextInput) name:@"ResignKB" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UI Prep methods
-(void)setupUserInteraction{
    [self setupAutoConnectButton];
    
    [self setupAddressInput];
    [self setupKeboardResignOnLostFocus];
    [self setupConnectButton];
}

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

-(void)setupKeboardResignOnLostFocus{
    [self.view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *loseFocusRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignRespondersForTextInput)];
    [loseFocusRecognizer setNumberOfTapsRequired:1];
    [loseFocusRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:loseFocusRecognizer];
}

#pragma mark States change Helpers
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


#pragma mark -
-(void)resignRespondersForTextInput{
    [self.txtHost resignFirstResponder];
    [self.txtPort resignFirstResponder];
}


#pragma mark - User Interactions
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
        NSLog(@"Not Implemented yet.");
    }];
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


#pragma mark - <UITextFieldDelegate> Methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.txtHost){
        if ([textField.text  matchesRegEx:IP_REGEX]) {
            return YES;
        }else if (![textField.text isEqualToString:@""]){
            [[AppManager sharedManager] showAlertWithType:MCALERT_TYPE_INVALID_IP_ENTERED];
            return YES;
        }
    }else if (textField == self.txtPort){
        if (textField.text.integerValue > 0 && textField.text.integerValue < 65536) {
            return YES;
        }else if (![textField.text isEqualToString:@""]){
            [[AppManager sharedManager] showAlertWithType:MCALERT_TYPE_INVALID_PORT_ENTERED];
            return YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
@end
