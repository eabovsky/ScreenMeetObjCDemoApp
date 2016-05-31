//
//  MainViewController.m
//  ScreenMeet
//
//  Created by RostyslavStepanyak on 5/30/16.
//  Copyright © 2016 RostyslavStepanyak. All rights reserved.
//

#import "MainViewController.h"
#import <ScreenMeetSDK/ScreenMeetSDK-Swift.h>

@interface MainViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self share];
}

- (void) share {
    self.navigationController.navigationBar.hidden = YES;
    StreamConfig *config = [[StreamConfig alloc] initWithPassword:nil askForName:NO];
    [[ScreenMeet sharedInstance] startStream:self.view config:config callback:^(enum CallStatus status) {
        
    }];
}
@end
