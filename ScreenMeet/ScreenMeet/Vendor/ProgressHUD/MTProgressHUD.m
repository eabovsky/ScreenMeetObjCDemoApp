//
//  MTProgressHUD.m
//  ProZ.com
//
//  Created by Ross on 10/14/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "MTProgressHUD.h"
#import "IMGActivityIndicator.h"

@interface MTProgressHUD()
  @property (nonatomic, strong)IMGActivityIndicator *indicator;
@end

@implementation MTProgressHUD

+ (MTProgressHUD *)sharedHUD {
    static MTProgressHUD *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (void)showOnView:(UIView *)view percentage:(BOOL)percentage {
   
    if(self.indicator && self.indicator.superview) {
        
    }
    else {
        self.indicator = [[IMGActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, 100, 100) percentage:percentage];
        
        self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:self.indicator];
        
        // Center Vertically
        NSLayoutConstraint *centerYConstraint =
        [NSLayoutConstraint constraintWithItem:self.indicator
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:view
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0.0];
        [view addConstraint:centerYConstraint];
        
        // Center Horizontally
        NSLayoutConstraint *centerXConstraint =
        [NSLayoutConstraint constraintWithItem:self.indicator
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:view
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                      constant:0.0];
        [view addConstraint:centerXConstraint];
        
        NSLayoutConstraint *heightConstraint =
        [NSLayoutConstraint constraintWithItem:self.indicator
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:100.0];
        [self.indicator addConstraint:heightConstraint];
        
        NSLayoutConstraint *widthConstraint =
        [NSLayoutConstraint constraintWithItem:self.indicator
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:100.0];
        [self.indicator addConstraint:widthConstraint];
    }
}

- (void)updateLabelProgress:(float)progress {
    if(self.indicator) {
       [self.indicator updateLabelProgress:progress];
    }
}

- (void)dismiss {
    [self.indicator removeFromSuperview];
}

@end
