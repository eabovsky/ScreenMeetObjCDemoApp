//
//  BaseViewController.m
//  Steven Koposov 
//
//  Created by Steven Koposov on 05/6/16.
//  Copyright (c) 2015 Steven Koposov . All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)setupBackButton {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 20, 44, 44)];
    //    [backButton setBackgroundColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.370]];
    backButton.tintColor = [UIColor colorWithRed:19./255. green:141./255. blue:213./255. alpha:1.0];
    UIImage *backImage = [UIImage imageNamed:@"arrow-back-blue"];
    [backButton setImage:backImage  forState:UIControlStateNormal];
    UIEdgeInsets dateImageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton setImageEdgeInsets:dateImageEdgeInsets];
    
    [backButton addTarget:self
                   action:@selector(popBack)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    //    self.navigationItem.leftBarButtonItem.ise = UIEdgeInsetsMake(0, -20, 10, 0);
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackButtonBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil]
     setBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil]
     setBackButtonBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
}

- (void)showDefaultError {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:@"Oops something went wrong"
                                                delegate:self
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)popBack {
    
}

- (void)dealloc {
    NSLog(@"dealloc: %@",NSStringFromClass(self.class));
}


@end
