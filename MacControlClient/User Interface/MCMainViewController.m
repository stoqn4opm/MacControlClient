//
//  MCMainViewController.m
//  MacControlClient
//
//  Created by Stoqn Stoqnov on 7/8/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMainViewController.h"
#import "AppManager.h"

@interface MCMainViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *swipeField;
@end

@implementation MCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIGestureRecognizer *mouseGestureRecognizer = [UIGestureRecognizer new];
//    mouseGestureRecognizer.delegate = self;
//    [self.swipeField addGestureRecognizer:mouseGestureRecognizer];
    
}

#pragma mark - Touch Handling
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint previousLocation = [self calculateMeanPreviousLocationFromTouches:touches];
    CGPoint currentLocation  = [self calculateMeanLocationFromTouches:touches];
    
    if (currentLocation.x > previousLocation.x) {
        // move x of the cursor one unit forward
        [[AppManager sharedManager] sendMoveRightMessage];
       }else if (currentLocation.x < previousLocation.x){
        // move x of the cursor one unit backward
           [[AppManager sharedManager] sendMoveLeftMessage];
    }
    
    if (currentLocation.y > previousLocation.y) {
        // move y of the cursor one unit forward
        [[AppManager sharedManager] sendMoveDownMessage];
    }else if (currentLocation.y < previousLocation.y){
        // move y of the cursor one unit backward
        [[AppManager sharedManager] sendMoveUpMessage];
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
