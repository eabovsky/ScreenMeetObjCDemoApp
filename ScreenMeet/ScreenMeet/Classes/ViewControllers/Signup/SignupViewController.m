//
//  SignupViewController.m
//  ScreenMeet
//
//  Created by RostyslavStepanyak on 5/27/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "SignupViewController.h"
#import "ScreenMeetSDK/ScreenMeetSDK-Swift.h"
#import "MainViewController.h"
#import "LoginViewController.h"

@interface SignupViewController ()

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

- (IBAction)logInBtnPressed:(UIButton *)sender;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackButton];
    self.title = @"Signup";
}

- (IBAction)signup:(id)sender {
    // Create user with entered credentials
    [[ScreenMeet sharedInstance] createUser:self.emailTextField.text
                                   username:self.nameTextField.text
                                   password:self.passwordTextField.text
                                   callback:^(enum CallStatus status) {
        // Check callback status
        if(status == CallStatusSUCCESS) {
            [self goToMainScreen];
        } else {
            [self showDefaultError];
        }
    }];
}

- (void)goToMainScreen {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainViewController =
    [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:mainViewController animated:YES];
}


- (IBAction)logInBtnPressed:(UIButton *)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *mainViewController =
    [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
