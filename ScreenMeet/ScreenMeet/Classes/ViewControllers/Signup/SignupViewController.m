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

@interface SignupViewController ()
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)signup:(id)sender {
    [[ScreenMeet sharedInstance] createUser:self.emailTextField.text username:self.nameTextField.text password:self.passwordTextField.text callback:^(enum CallStatus status) {
        if(status == CallStatusSUCCESS) {
            [self goToMainScreen];
        }
    }];
}

- (void)goToMainScreen {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainViewController =
    [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:mainViewController animated:YES];
}


@end
