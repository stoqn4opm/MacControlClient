//
//  MCMainViewController.m
//  MacControlClient
//
//  Created by Stoqn Stoqnov on 7/8/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMainViewController.h"
#import "SWRevealViewController.h"
#import "AppManager.h"

@interface MCMainViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *keyboardButton;
@property (weak, nonatomic) IBOutlet UIImageView *swipeField;
@end

@implementation MCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _prepareUI];
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    UIGestureRecognizer *mouseGestureRecognizer = [[UIGestureRecognizer alloc] init];
    mouseGestureRecognizer.delegate = self;
    [self.swipeField addGestureRecognizer:mouseGestureRecognizer];
}

-(void)_prepareUI{
    [self.keyboardButton.layer setCornerRadius:5];
    [self.keyboardButton setClipsToBounds:YES];
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
@end
