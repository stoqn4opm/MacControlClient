//
//  MCMainViewController.m
//  MacControlClient
//
//  Created by Stoqn Stoqnov on 7/8/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMainViewController.h"
#import "AppManager.h"
#import "MCIconTapHandler.h"

@interface MCMainViewController () <UIGestureRecognizerDelegate, MCIconTapHandlerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *swipeField;
@property (weak, nonatomic) IBOutlet UIImageView *btnCloseWindow;
@property (weak, nonatomic) IBOutlet UIImageView *btnMinimizeWindow;
@property (weak, nonatomic) IBOutlet UIImageView *btnFullScreenWindow;
@property (weak, nonatomic) IBOutlet UIImageView *btnKeyboard;
@property (weak, nonatomic) IBOutlet UIImageView *btnSettings;
@property (strong , nonatomic) MCIconTapHandler  *tapHandler;
@end

@implementation MCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _prepareUI];

    UIGestureRecognizer *mouseGestureRecognizer = [UIGestureRecognizer new];
    mouseGestureRecognizer.delegate = self;
    [self.swipeField addGestureRecognizer:mouseGestureRecognizer];
}

-(void)_prepareUI{
    
    [self.btnSettings           setUserInteractionEnabled:YES];
    [self.btnMinimizeWindow     setUserInteractionEnabled:YES];
    [self.btnKeyboard           setUserInteractionEnabled:YES];
    [self.btnFullScreenWindow   setUserInteractionEnabled:YES];
    [self.btnCloseWindow        setUserInteractionEnabled:YES];
    
    [self _setupToolbarIcons];
    
    
}

-(void)_setupToolbarIcons{
    UITapGestureRecognizer *settingsTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self.tapHandler action:@selector(settingsTapped)];
    [settingsTapped setNumberOfTapsRequired:1];
    [settingsTapped setNumberOfTouchesRequired:1];
    [self.btnSettings addGestureRecognizer:settingsTapped];
    
    UITapGestureRecognizer *closeWindowTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self.tapHandler action:@selector(closeWindowTapped)];
    [settingsTapped setNumberOfTapsRequired:1];
    [settingsTapped setNumberOfTouchesRequired:1];
    [self.btnCloseWindow addGestureRecognizer:closeWindowTapped];
    
    UITapGestureRecognizer *minimizeWindowTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self.tapHandler action:@selector(minimizeWindowTapped)];
    [settingsTapped setNumberOfTapsRequired:1];
    [settingsTapped setNumberOfTouchesRequired:1];
    [self.btnMinimizeWindow addGestureRecognizer:minimizeWindowTapped];
    
    UITapGestureRecognizer *fullscreenWindowTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self.tapHandler action:@selector(fullscreenWindowTapped)];
    [settingsTapped setNumberOfTapsRequired:1];
    [settingsTapped setNumberOfTouchesRequired:1];
    [self.btnFullScreenWindow addGestureRecognizer:fullscreenWindowTapped];
    
    UITapGestureRecognizer *keyboardTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self.tapHandler action:@selector(keyboardTapped)];
    [settingsTapped setNumberOfTapsRequired:1];
    [settingsTapped setNumberOfTouchesRequired:1];
    [self.btnKeyboard addGestureRecognizer:keyboardTapped];
}

-(MCIconTapHandler *)tapHandler{
    if (_tapHandler) {
        return _tapHandler;
    }
    _tapHandler = [MCIconTapHandler new];
    _tapHandler.delegate = self;
    return _tapHandler;
}

#pragma mark - Touch Handling
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint previousLocation = [self _calculateMeanPreviousLocationFromTouches:touches];
    CGPoint currentLocation  = [self _calculateMeanLocationFromTouches:touches];
    
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


#pragma mark - Touch Handling Helper functions
-(CGPoint) _calculateMeanPreviousLocationFromTouches:(NSSet *)touches{
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

-(CGPoint) _calculateMeanLocationFromTouches:(NSSet *)touches{
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


#pragma mark - <MCIconTapHandlerDelegate> Methods
-(void)presentSettings{
    [self performSegueWithIdentifier:@"SettingsSegue" sender:nil];
}
@end
