//
//  modalViewController.m
//  ocRef
//
//  Created by Thomas Ricouard on 4/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ModalViewController.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kAnimationDurationZPosition = 0.4;
const CGFloat kAnimationDurationScaling = 0.3;
const CGFloat kAnimationDurationShowingView = 0.3;
const CGFloat KZposition = -4000;
const CGFloat kDeep = 0.80;

@interface ModalViewController ()

@property (nonatomic, strong, readwrite) UIView *overlayView;
@end

@implementation ModalViewController
@synthesize overlayView = _overlayView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (id)initWithParentViewController:(UIViewController *)parentController
                  completionTarget:(id)target
                            action:(SEL)action
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _fromViewController = parentController;
    _completionTarget = target;
    _completionAction = action;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor blackColor]];
  UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             self.view.frame.size.width,
                                                                             50)];
  UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self.completionTarget
                                                                 action:self.completionAction];
  UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Title"];
  item.rightBarButtonItem = rightButton;
  item.hidesBackButton = YES;
  [navBar pushNavigationItem:item animated:NO];
  [self.view addSubview:navBar];
}


- (void)presentViewControllercompletion:(void (^)(void))completion
{
  
  UIView *primaryView = self.fromViewController.view;
  
  //Modify orientation angle
  void (^modifyAngle) (void) = ^{
    if (!_overlayView){
      CGRect oFrame = CGRectMake(0, 0, primaryView.frame.size.width,
                                 primaryView.frame.size.height);
      self.overlayView = [[UIView alloc]initWithFrame:oFrame];
    }
    [self.overlayView setBackgroundColor:[UIColor blackColor]];
    [self.overlayView setAlpha:0.0];
    CALayer *layer = primaryView.layer;
    layer.zPosition = KZposition;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -300;
    layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform,
                                          2.0f * M_PI / 180.0f,
                                          1.0f,
                                          0.0f,
                                          0.0f);
    [primaryView addSubview:self.overlayView];
    [self.overlayView setAlpha:0.2];
  };
  
  //Modify view scale
  void (^scaleView) (void) = ^{
    primaryView.transform = CGAffineTransformMakeScale(kDeep, kDeep);
  };
  
  primaryView.window.backgroundColor = [UIColor blackColor];
  //Begin chained animation
  //The first thing is to modify the angle of the view
  [UIView animateWithDuration:kAnimationDurationZPosition
                   animations:modifyAngle
                   completion:^(BOOL finished) {
                     if (finished) {
                       //Once done we scale the view have a nice effect.
                       [UIView animateWithDuration:kAnimationDurationScaling
                                             delay:0.0
                                           options:UIViewAnimationOptionCurveEaseIn
                                        animations:scaleView
                                        completion:NULL];
                       //At the same time we present the modal view
                       
                       //Modal block
                       void (^modalBlock) (void) = ^{
                         [self.fromViewController
                          presentViewController:self animated:YES completion:^{
                            completion();
                          }];
                       };
                       
                       //Show the modal after a slight delay, look better.
                       dispatch_time_t modalDelay =
                       dispatch_time(DISPATCH_TIME_NOW, 10000000);
                       dispatch_after(modalDelay, dispatch_get_main_queue(), modalBlock);
                       
                     }
                   }];
  
}

- (void)dismissViewControllercompletion:(void (^)(void))completion
{
  UIView *primaryView = self.fromViewController.view;
  //Modify orentation angle
  void (^modifyAngle) (void) = ^{
    CALayer *layer = primaryView.layer;
    layer.zPosition = KZposition;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / 300;
    layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform,
                                          -3.0f * M_PI / 180.0f,
                                          1.0f,
                                          0.0f,
                                          0.0f);
    [self.overlayView setAlpha:0.0];
    
  };
  
  //Modify view scale
  void (^scaleView) (void) = ^{
    primaryView.transform = CGAffineTransformMakeScale(1.0, 1.0);
  };
  
  //Modal block
  void (^animationBlock) (void) = ^{
    
    
    [UIView animateWithDuration:kAnimationDurationZPosition
                          delay:0.05
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:modifyAngle
                     completion:^(BOOL finished) {
                       //restore scale to 1.0
                       [UIView animateWithDuration:kAnimationDurationScaling
                                        animations:scaleView
                                        completion:^(BOOL finished) {
                                          if (finished)
                                            [self.overlayView removeFromSuperview];
                                          completion();
                                        }];
                     }];
    
  };
  
  //Dismiss modal
  [self.fromViewController
   dismissViewControllerAnimated:YES completion:^{
     
   }];
  
  //Restore the scale as we lost the context
  //Without animation
  //SOOOOOO fake
  primaryView.transform = CGAffineTransformMakeScale(kDeep, kDeep);
  
  //Slight delay before view animation
  dispatch_time_t modalDelay =
  dispatch_time(DISPATCH_TIME_NOW, 20000000);
  dispatch_after(modalDelay, dispatch_get_main_queue(), animationBlock);
  
  
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
