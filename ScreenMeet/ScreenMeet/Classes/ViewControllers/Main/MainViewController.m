//
//  MainViewController.m
//  ScreenMeet
//
//  Created by RostyslavStepanyak on 5/30/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "MainViewController.h"
#import <ScreenMeetSDK/ScreenMeetSDK-Swift.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface MainViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)startBtnPressed:(UIButton *)sender;
- (IBAction)stopBtnPressed:(UIButton *)sender;
- (IBAction)pauseBtnPressed:(UIButton *)sender;
- (IBAction)shareBtnPressed:(UIButton *)sender;

- (IBAction)valueChanged:(UISegmentedControl *)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBackButton];
    self.title = @"Screen Sharing";
    
    [self initWebView];
}

- (void)initWebView {
    NSString *urlAddress = @"https://google.com";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
}

- (IBAction)startBtnPressed:(UIButton *)sender {
    // Start steaming. Pass view that you want to share.
    [[ScreenMeet sharedInstance] startStream:[[[UIApplication sharedApplication] delegate] window]
                                    callback:^(enum CallStatus status) {
        // Check callback status
        if (status == CallStatusSUCCESS) {
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
            [self showDefaultError];
        }
    }];
}

- (IBAction)stopBtnPressed:(UIButton *)sender {
    // Stop streaming
    [[ScreenMeet sharedInstance] stopStream];
    [self.navigationController popViewControllerAnimated:YES];
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
}

- (IBAction)valueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 1) {
//        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
//        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imgPicker.delegate = self;
//        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}

- (void)popBack {
    // Check streaming status
    if ([[ScreenMeet sharedInstance] getStreamState] != StreamStateTypeSTOPPED) {
        // Stop streaming
        [[ScreenMeet sharedInstance] stopStream];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
