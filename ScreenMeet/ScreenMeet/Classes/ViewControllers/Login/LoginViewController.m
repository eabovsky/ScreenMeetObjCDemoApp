//
//  LoginViewController.m
//  ScreenMeet
//
//  Created by RostyslavStepanyak on 5/27/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "LoginViewController.h"
#import "ScreenMeetSDK/ScreenMeetSDK-Swift.h"
#import "MTProgressHUD.h"

@interface LoginViewController ()
@property (nonatomic, strong) ScreenMeet *screenEngine;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIView *registerInfoContainer;
@property (weak, nonatomic) IBOutlet UIView *infoContainer;

- (IBAction)facebookLoginPressed:(id)sender;
- (IBAction)loginUpPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackButton];
    self.title = @"Login";
    self.facebookButton.layer.cornerRadius = 7.f;
    self.loginButton.layer.cornerRadius = 7.f;
    
    self.screenEngine = [[ScreenMeet alloc] initWithApiKey:@"sfsdfsdf" environment:EnvironmentTypeSANDBOX];
}

- (IBAction)facebookLoginPressed:(id)sender {
    
}

- (IBAction)loginUpPressed:(id)sender {
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:NO];
    [self.screenEngine authenticate:@"ivanatprojector@gmail.com" password:@"qqqqqq" callback:^(enum CallStatus status) {
        NSLog(@"Status: %ld", (long)status);
        [[MTProgressHUD sharedHUD] dismiss];
    }];
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
