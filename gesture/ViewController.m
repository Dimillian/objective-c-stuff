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
  _draggableView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
  [self.draggableView setBackgroundColor:[UIColor greenColor]];
  [self.view addSubview:self.draggableView];
  _gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
  [self.draggableView addGestureRecognizer:self.gesture];
  
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)pan:(UIPanGestureRecognizer *)reconizer
{
  CGPoint currentTouchPoint     = [reconizer locationInView:self.view];
  
  if (reconizer.state == UIGestureRecognizerStateBegan) {
    _initialPoint = self.draggableView.layer.position;
  }
  else if (reconizer.state == UIGestureRecognizerStateChanged){
    CGPoint point = CGPointMake(currentTouchPoint.x, self.draggableView.center.y);
    self.draggableView.layer.position = point;
    
  }
  else if (reconizer.state == UIGestureRecognizerStateEnded || reconizer.state == UIGestureRecognizerStateCancelled){
    [UIView animateWithDuration:0.30 animations:^{
      self.draggableView.layer.position = _initialPoint;
    }];
  
  }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
