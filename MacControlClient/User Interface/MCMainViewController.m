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

    UIPanGestureRecognizer *panRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [panRecognizer setDelegate:self];
    [self.swipeField setUserInteractionEnabled:YES];
    [self.swipeField addGestureRecognizer:panRecognizer];
}


#pragma mark - Touch Handling
-(void) panHandler:(UIPanGestureRecognizer *) pan {
    CGPoint velocity = [pan velocityInView:self.swipeField];
    if (velocity.x > 0) {
        [[AppManager sharedManager]sendMoveRightMessage];
    }else if (velocity.x < 0){
        [[AppManager sharedManager]sendMoveLeftMessage];
    }
    if (velocity.y > 0) {
        [[AppManager sharedManager]sendMoveDownMessage];
    }else if (velocity.y < 0){
        [[AppManager sharedManager]sendMoveUpMessage];
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
