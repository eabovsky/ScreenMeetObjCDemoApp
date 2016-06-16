//
//  LoginViewController.m
//  ScreenMeet
//
//  Created by RostyslavStepanyak on 5/27/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "LoginViewController.h"

#import "MTProgressHUD.h"
#import "SignupViewController.h"
#import "MainViewController.h"
#import <ScreenMeetSDK/ScreenMeetSDK-Swift.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIView *registerInfoContainer;
@property (weak, nonatomic) IBOutlet UIView *infoContainer;

- (IBAction)loginUpPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackButton];
    self.title = @"Login";
    self.facebookButton.layer.cornerRadius = 7.f;
    self.loginButton.layer.cornerRadius = 7.f;
    
    self.emailTextField.text    = @"iulian.yeremenko@sethq.com";
    self.passwordTextField.text = @"1qa2ws3ed";
    
    [self autoLogin];
}

- (void)autoLogin {
    NSString *token = [[ScreenMeet sharedInstance] getBearerToken];
    [[ScreenMeet sharedInstance] authenticate:token
                                     callback:^(enum CallStatus status) {
        if(status == CallStatusSUCCESS) {
            [self goToMainScreen];
        } else {
//            [self showDefaultError];
        }
    }];
}

- (IBAction)loginUpPressed:(id)sender {
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:NO];
   
    [[ScreenMeet sharedInstance] authenticate:self.emailTextField.text
                                     password:self.passwordTextField.text
                                     callback:^(enum CallStatus status) {
        NSLog(@"Status: %ld", (long)status);
        
        [[MTProgressHUD sharedHUD] dismiss];
        
        if(status == CallStatusSUCCESS) {
            [self goToMainScreen];
        } else {
            [self showDefaultError];
        }
    }];
}

- (IBAction)showSignUp:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignupViewController *signUp =
    [storyBoard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signUp animated:YES];
}

- (void)goToMainScreen {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainViewController =
    [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
