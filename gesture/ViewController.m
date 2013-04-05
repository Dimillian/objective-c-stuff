//
//  ViewController.m
//  gesture
//
//  Created by Thomas Ricouard on 4/5/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
{
    CGPoint _initialPoint;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _draggableView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 200, 50)];
    [self.draggableView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:self.draggableView];
    _gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.draggableView addGestureRecognizer:self.gesture];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

-(void)pan:(UIPanGestureRecognizer *)reconizer
{
    [self adjustAnchorPointForGestureRecognizer:reconizer];
    
    if (reconizer.state == UIGestureRecognizerStateBegan) {
        _initialPoint = self.draggableView.layer.position;
        [UIView animateWithDuration:0.2 animations:^{
            self.draggableView.transform = CGAffineTransformMakeScale(1.10, 1.10);
            self.draggableView.alpha = 0.8;
        }];
        
    }
    else if (reconizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [reconizer translationInView:[self.draggableView superview]];
        
        [self.draggableView setCenter:CGPointMake([self.draggableView center].x + translation.x, [self.draggableView center].y + translation.y)];
        [reconizer setTranslation:CGPointZero inView:[self.draggableView superview]];
        
    }
    else if (reconizer.state == UIGestureRecognizerStateEnded || reconizer.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:0.30 animations:^{
            self.draggableView.layer.position = _initialPoint;
            self.draggableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.draggableView.alpha = 1.0;
        }];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
