//
//  IMGActivityIndicator.m
//  IMGActivityIndicator
//
//  Created by Maijid Moujaled on 11/12/14.
//  Copyright (c) 2014 Maijid Moujaled. All rights reserved.
//

#import "IMGActivityIndicator.h"

static const CGFloat IMGCircleLineWidth = 1.65;
static const CGFloat IMGDuration = 1.4; // Duration for every stroke cycle

// Helper Function to get center of CGRect
CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

@interface IMGActivityIndicator ()

@property (nonatomic, strong) NSMutableArray *shapeLayers;
@property (nonatomic, strong) NSArray *strokeTimings;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic) BOOL percentage;
@property (nonatomic, strong) UILabel *percentageLabel;
@end

@implementation IMGActivityIndicator

- (id)initWithFrame:(CGRect)frame percentage:(BOOL)percentage
{
    self = [super initWithFrame:frame];
    if (self) {
        self.percentage = percentage;
        _strokeColor = [UIColor whiteColor];
        [self createLayers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _strokeColor = [UIColor whiteColor];
        [self createLayers];
    }
    return self;
}

- (void)createLayers
{
    CGRect theFrame = CGRectMake(0, 0 ,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    UIView *backgroundView = [[UIView alloc] initWithFrame: theFrame];
    
    //backgroundView.layer.borderColor = [UIColor colorWithRed:168./255. green:0.0 blue:0.0 alpha:1].CGColor;
    backgroundView.backgroundColor = [UIColor colorWithRed:14./255. green:141./255. blue:213./255 alpha:1.0];
    self.shapeLayers = [NSMutableArray new];
    
    // Draw the middle dot.
    UIBezierPath *dot =[UIBezierPath bezierPathWithArcCenter:CGRectGetCenter(backgroundView.frame)
                                                      radius:IMGCircleLineWidth
                                                  startAngle:-0.5 * M_PI
                                                    endAngle:1.5 * M_PI
                                                   clockwise:YES];
    
    CAShapeLayer *dotLayer = [CAShapeLayer layer];
    dotLayer.path = dot.CGPath;
    dotLayer.fillColor = [UIColor clearColor].CGColor;
    [backgroundView.layer addSublayer:dotLayer];
    
    self.strokeTimings = @[@0.35, @0.50, @0.65, @0.80, @0.95];
    NSArray *radii = @[@16, @13, @10, @7, @4];
    
    // Draw our looping stroke lines
    for (int i = 0; i < 5; i++) {
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        CGFloat radius = [radii[i] floatValue];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGRectGetCenter(backgroundView.frame)
                                                            radius:radius
                                                        startAngle:-0.5 * M_PI
                                                          endAngle:1.5 * M_PI
                                                         clockwise:YES];
        
        circleLayer.path = path.CGPath;
        circleLayer.strokeColor = self.strokeColor.CGColor;
        circleLayer.lineWidth = IMGCircleLineWidth;
        circleLayer.fillColor = nil;
        circleLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.shapeLayers addObject:circleLayer];
        [backgroundView.layer addSublayer:circleLayer];
    }
    
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    [self addSubview:backgroundView];
    
    /*
    if(self.percentage) {
        self.percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.frame), 16)];
        self.percentageLabel.backgroundColor = [UIColor clearColor];
        self.percentageLabel.textColor = [UIColor whiteColor];
        self.percentageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
        self.percentageLabel.text = @" 0%";
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.percentageLabel];
        [self bringSubviewToFront:self.percentageLabel];
    }*/
    
    [self loopAnimations];

    // Use a CADisplayLink timer to fire every time we need to reloop both stroke start and end animation.
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(loopAnimations)];
    self.timer.frameInterval = 60 * 2 * IMGDuration;
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)updateLabelProgress:(float)progress {
    self.percentageLabel.text = [NSString stringWithFormat:@"  %d%%", (int)(progress * 100)];
}

/*
 *For every loop (in 3.33s) we add both our strokeStart and strokeEnd animations for the next looping cycle.
 */
- (void)loopAnimations
{
    for (int i = 0; i < 5; i++) {
        
        CAShapeLayer *circleLayer = self.shapeLayers[i];
        CGFloat timeDuration =  [self.strokeTimings[i] floatValue];
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0;
        strokeStartAnimation.toValue = @1.08;
        strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        strokeStartAnimation.beginTime = CACurrentMediaTime() + timeDuration;
        strokeStartAnimation.duration = IMGDuration;
        [circleLayer addAnimation:strokeStartAnimation forKey:nil];
        
        CABasicAnimation *strokEndAnimation  = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokEndAnimation.fromValue = @0;
        strokEndAnimation.toValue = @1.08;
        strokEndAnimation.duration = IMGDuration;
        strokEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        strokEndAnimation.beginTime = CACurrentMediaTime() + timeDuration + IMGDuration;
        [circleLayer addAnimation:strokEndAnimation forKey:nil];
    }
}

@end
