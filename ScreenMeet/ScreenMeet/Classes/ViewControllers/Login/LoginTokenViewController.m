//
//  LoginTokenViewController.m
//  ScreenMeet
//
//  Created by Iulian Yeremenko on 6/16/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "LoginTokenViewController.h"
#import "MTProgressHUD.h"
#import "MainViewController.h"
#import "SignupViewController.h"

#import <ScreenMeetSDK/ScreenMeetSDK-Swift.h>

@interface LoginTokenViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextView *tokenTextView;

- (IBAction)setTokenBtnPressed:(UIButton *)sender;
- (IBAction)loginBtnPressed:(UIButton *)sender;
- (IBAction)createBtnPressed:(UIButton *)sender;

@end

@implementation LoginTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBackButton];
    
    self.title = @"Login with token";

    self.loginButton.layer.cornerRadius = 7.f;
    self.tokenTextView.layer.cornerRadius = 7.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setTokenBtnPressed:(UIButton *)sender {
    self.tokenTextView.text = @"2483:$2a$10$ZpnQhiQcsLiCSyvh.D7WxehEvGdLQXOeOVPZdpVODnstgrYv2f2Bq";
}

- (IBAction)loginBtnPressed:(id)sender {
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:NO];
    
    [[ScreenMeet sharedInstance] authenticate:self.tokenTextView.text
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

- (IBAction)createBtnPressed:(UIButton *)sender {
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
