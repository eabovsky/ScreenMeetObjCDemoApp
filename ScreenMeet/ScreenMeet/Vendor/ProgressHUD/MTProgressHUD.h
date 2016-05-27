//
//  MTProgressHUD.h
//  ProZ.com
//
//  Created by Ross on 10/14/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTProgressHUD : NSObject

+ (MTProgressHUD *)sharedHUD;

- (void)updateLabelProgress:(float)progress;
- (void)showOnView:(UIView *)view percentage:(BOOL)percentage;
- (void)dismiss;

@end
