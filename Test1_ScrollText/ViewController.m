//
//  ViewController.m
//  Test1_ScrollText
//
//  Created by Dim on 04.01.16.
//  Copyright © 2016 TagsFor. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (weak, nonatomic) UITextView *textView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startAnimation];
}


#pragma mark - Private

- (void)setupTextView {
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.frame];
    
    textView.text = [self generateText];
    textView.font = [UIFont systemFontOfSize:22.0];
    textView.editable = NO;
    textView.selectable = NO;
    
    textView.frame = CGRectMake(0.0, 0.0, textView.contentSize.width, textView.contentSize.height);
        
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    [textView addGestureRecognizer:panGesture];
    
    [self.view addSubview:textView];
    
    self.textView = textView;
}

- (NSString *)generateText {

    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < 400; i++) {
        [string appendFormat:@"%d ", i];
    }
    
    return string;
}

- (void)startAnimation {
    
    static CGFloat speed = 30.0;
    
    CGFloat endValue = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.textView.frame);
    
    CGFloat distance = CGRectGetMinY(self.textView.frame) - endValue;
    
    CGFloat duration = distance / speed;
    
    CGRect destinationFrame = CGRectMake(CGRectGetMinX(self.textView.frame), endValue, CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame));
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         self.textView.frame = destinationFrame;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)stopAnimation {
    
    CALayer *presentationLayer = (CALayer *)self.textView.layer.presentationLayer;
    
    self.textView.frame = presentationLayer.frame;
    
    [self.textView.layer removeAllAnimations];
}


#pragma mark - Actions

- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint translationInView = [panGesture translationInView:self.textView];
    
    CGRect currentFrame = self.textView.frame;
    
    switch (panGesture.state) {
            
        case UIGestureRecognizerStateBegan:
            [self stopAnimation];
            break;
            
        case UIGestureRecognizerStateChanged:
            self.textView.frame = CGRectMake(CGRectGetMinX(currentFrame), CGRectGetMinY(currentFrame) + translationInView.y, CGRectGetWidth(currentFrame), CGRectGetHeight(currentFrame));
            [panGesture setTranslation:CGPointZero inView:self.textView];
            break;
     
        case UIGestureRecognizerStateEnded:
            [self startAnimation];
            break;
            
        default:
            break;
    }
}

@end
