//
//  MainViewController.m
//  ScreenMeet
//
//  Created by RostyslavStepanyak on 5/30/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "MainViewController.h"
#import "MTProgressHUD.h"
#import <ScreenMeetSDK/ScreenMeetSDK-Swift.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface MainViewController ()
<UIWebViewDelegate> {
    UIView *sharedView;
}

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

- (IBAction)startBtnPressed:(UIButton *)sender;
- (IBAction)stopBtnPressed:(UIButton *)sender;
- (IBAction)pauseBtnPressed:(UIButton *)sender;
- (IBAction)shareBtnPressed:(UIButton *)sender;

- (IBAction)switchPressed:(UISwitch *)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBackButton];
    self.title = @"Screen Sharing";
    
    [self initWebView];
}

- (void)initWebView {
    self.webView.delegate = self;
    
    NSString *urlAddress = @"https://google.com";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
}

- (IBAction)startBtnPressed:(UIButton *)sender {
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:NO];
    // Start steaming.
    [[ScreenMeet sharedInstance] startStream:^(enum CallStatus status) {
        // Check callback status
        if (status == CallStatusSUCCESS) {
            [[MTProgressHUD sharedHUD] dismiss];
            [UIView transitionWithView:self.buttonsView
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromTop
                            animations:^{
                // Get streaming URL
                self.urlTextField.text  = [[ScreenMeet sharedInstance] getRoomUrl];
                self.startButton.hidden = YES;
                self.shareButton.hidden = NO;
            } completion:nil];
        } else {
            [[MTProgressHUD sharedHUD] dismiss];
            [self showDefaultError];
        }
    }];
}

- (IBAction)stopBtnPressed:(UIButton *)sender {
    // Stop streaming
    [[ScreenMeet sharedInstance] stopStream];
    [UIView transitionWithView:self.buttonsView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        // Reset states
                        self.urlTextField.text    = @"";
                        self.startButton.hidden   = NO;
                        self.shareButton.hidden   = YES;
                        self.pauseButton.selected = NO;
                    } completion:nil];
}

- (IBAction)pauseBtnPressed:(UIButton *)sender {
    // Check state of stream
    if ([[ScreenMeet sharedInstance] getStreamState] == StreamStateTypeACTIVE) {
        // Pause stream
        [[ScreenMeet sharedInstance] pauseStream];
        sender.selected = !sender.selected;
    } else {
        // Resume stream
        [[ScreenMeet sharedInstance] resumeStream];
        sender.selected = !sender.selected;
    }
}

- (IBAction)shareBtnPressed:(UIButton *)sender {
    NSLog(@"room URL : %@", self.urlTextField.text);
    // Show share dialog
    [[ScreenMeet sharedInstance] showInviteMeetingLinkDialog:self.shareButton.frame
                                                      inView:self.view
                                             arrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)switchPressed:(UISwitch *)sender {
    sharedView = sender.on ? nil : self.webView;
    // Pass view that you want to share.
    [[ScreenMeet sharedInstance] setStreamSource:sharedView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[MTProgressHUD sharedHUD] dismiss];
}

- (void)popBack {
    // Check streaming status
    if ([[ScreenMeet sharedInstance] getStreamState] != StreamStateTypeSTOPPED) {
        // Stop streaming
        [[ScreenMeet sharedInstance] stopStream];
    }
    
    // Logout user
    [[ScreenMeet sharedInstance] logoutUser];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
