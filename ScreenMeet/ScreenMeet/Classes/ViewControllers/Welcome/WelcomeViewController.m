//
//  ViewController.m
//  ScreenMeet
//
//  Created by RostyslavStepanyak on 5/27/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "LoginTokenViewController.h"
#import <ScreenMeetSDK/ScreenMeetSDK-Swift.h>

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginWithTokenButton;
@property (weak, nonatomic) IBOutlet UIView *containerImage;

- (IBAction)signUpBtnPressed:(UIButton *)sender;
- (IBAction)loginPsdBtnPressed:(UIButton *)sender;
- (IBAction)loginTokenBtnPressed:(UIButton *)sender;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Welcome";
    
    [ScreenMeet initSharedInstance:@"You" environment:EnvironmentTypeSANDBOX];
    
    self.registerButton.layer.cornerRadius = 7.f;
    
    self.loginButton.layer.borderWidth  = 2.0f;
    self.loginButton.layer.cornerRadius = 7.f;
    self.loginButton.layer.borderColor  = [UIColor colorWithRed:19./255. green:141./255. blue:213./255. alpha:1.0].CGColor;
    
    self.loginWithTokenButton.layer.borderWidth  = 2.0f;
    self.loginWithTokenButton.layer.cornerRadius = 7.f;
    self.loginWithTokenButton.layer.borderColor  = [UIColor colorWithRed:19./255. green:141./255. blue:213./255. alpha:1.0].CGColor;
}

- (IBAction)signUpBtnPressed:(UIButton *)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignupViewController *signUp = [storyBoard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signUp animated:YES];
}

- (IBAction)loginPsdBtnPressed:(UIButton *)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:login animated:YES];
}

- (IBAction)loginTokenBtnPressed:(UIButton *)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginTokenViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"LoginTokenViewController"];
    [self.navigationController pushViewController:login animated:YES];
}

@end
