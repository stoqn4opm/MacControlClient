//
//  MCMainViewController.m
//  MacControlClient
//
//  Created by Stoqn Stoqnov on 7/8/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMainViewController.h"
#import "AppManager.h"

@interface MCMainViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>{
    UITextField *_kbInvoker;
}
@property (weak, nonatomic) IBOutlet UIView *btnLeftClick;
@property (weak, nonatomic) IBOutlet UIView *btnRightClick;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftClick;
@property (weak, nonatomic) IBOutlet UILabel *lblRightClick;
@property (weak, nonatomic) IBOutlet UIImageView *btnFullScreen;
@property (weak, nonatomic) IBOutlet UIImageView *btnMinimize;
@property (weak, nonatomic) IBOutlet UIImageView *btnClose;
@property (weak, nonatomic) IBOutlet UIImageView *btnKeyboard;
@property (weak, nonatomic) IBOutlet UIImageView *btnSettings;

@property (weak, nonatomic) IBOutlet UIImageView *swipeField;
@end

@implementation MCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
    UIGestureRecognizer *mouseGestureRecognizer = [UIGestureRecognizer new];
    mouseGestureRecognizer.delegate = self;
    [self.swipeField addGestureRecognizer:mouseGestureRecognizer];
}

-(void)prepareUI{
    [self setupUserInteraction];
}


#pragma mark - UI Prep methods
-(void)setupUserInteraction{

    [self setupCloseButton];
    [self setupFullScreenButton];
    [self setupLeftClickButton];
    [self setupMinimizeButton];
    [self setupRightClickButton];
    [self setupSetingsButton];
    [self setupKeyboardButton];
    [self setupKeboardResignOnLostFocus];
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
    [self.btnFullScreen addGestureRecognizer:fullscreenTapped];
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

-(void)setupKeboardResignOnLostFocus{
    [self.view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *loseFocusRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:_kbInvoker action:@selector(resignFirstResponder)];
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
        [self performSegueWithIdentifier:@"SettingsSegue" sender:nil];
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

-(void)keyboardTappedAction{
    [self.btnKeyboard setAlpha:0];
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.btnKeyboard setAlpha:1];
    }completion:^(BOOL finished) {
        if ([_kbInvoker isFirstResponder]) {
            [_kbInvoker resignFirstResponder];
        }else{
            [_kbInvoker becomeFirstResponder];
        }
    }];
}


#pragma mark - Touch Handling
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint previousLocation = [self calculateMeanPreviousLocationFromTouches:touches];
    CGPoint currentLocation  = [self calculateMeanLocationFromTouches:touches];
    
    if (currentLocation.x > previousLocation.x) {
        // move x of the cursor one unit forward
        [[AppManager sharedManager] sendMoveRightMessages:SENSITIVITY];
       }else if (currentLocation.x < previousLocation.x){
        // move x of the cursor one unit backward
           [[AppManager sharedManager] sendMoveLeftMessages:SENSITIVITY];
    }
    
    if (currentLocation.y > previousLocation.y) {
        // move y of the cursor one unit forward
        [[AppManager sharedManager] sendMoveDownMessages:SENSITIVITY];
    }else if (currentLocation.y < previousLocation.y){
        // move y of the cursor one unit backward
        [[AppManager sharedManager] sendMoveUpMessages:SENSITIVITY];
    }
}


#pragma mark - <UITextFieldDelegate> Methods
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    if (string.length > 0) {
        [[AppManager sharedManager] sendKeyTyped:[string characterAtIndex:0]];
        
    }else{
        [[AppManager sharedManager] sendKeyTyped:8];
    }
    return YES;
}

#pragma mark - Touch Handling Helper functions
-(CGPoint) calculateMeanPreviousLocationFromTouches:(NSSet *)touches{
    CGFloat __block prevX = 0;
    CGFloat __block prevY = 0;
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        prevX += [obj previousLocationInView:self.swipeField].x;
        prevY += [obj previousLocationInView:self.swipeField].y;
    }];
    prevX /= touches.count;
    prevY /= touches.count;
    return CGPointMake(prevX, prevY);
}

-(CGPoint) calculateMeanLocationFromTouches:(NSSet *)touches{
    CGFloat __block x = 0;
    CGFloat __block y = 0;
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        x += [obj locationInView:self.swipeField].x;
        y += [obj locationInView:self.swipeField].y;
    }];
    x /= touches.count;
    y /= touches.count;
    return CGPointMake(x, y);
}
@end
