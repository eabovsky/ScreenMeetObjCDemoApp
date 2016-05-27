//
//  LoginViewController.m
//  ScreenMeet
//
//  Created by RostyslavStepanyak on 5/27/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "LoginViewController.h"
#import "ScreenMeetSDK/ScreenMeetSDK-Swift.h"

@interface LoginViewController ()
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
    
    ScreenMeet *engine = [[ScreenMeet alloc] init];
    [engine login]

}

- (IBAction)facebookLoginPressed:(id)sender {
    
}

- (IBAction)loginUpPressed:(id)sender {
    
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
