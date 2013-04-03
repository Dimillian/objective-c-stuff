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
  [UIView animateWithDuration:kAnimationDurationZPosition animations:^{
    if (!_overlayView){
      CGRect oFrame = CGRectMake(0, 0, primaryView.frame.size.width,
                                 primaryView.frame.size.height);
      _overlayView = [[UIView alloc]initWithFrame:oFrame];
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
  } completion:^(BOOL finished) {
    if (finished) {
      //Keep current context so our zPosition layer will still be there when
      //dimissing modal
      //By doing this we lost the modal animation. So let's recode it...
      self.fromViewController.modalPresentationStyle
      = UIModalPresentationCurrentContext;
      [self.fromViewController
       presentViewController:self animated:NO completion:^{
         CGRect originalFrame = self.view.frame;
         //We putting the view at the bottom so when putting the original
         //frame back we will have the modal like transition
         self.view.frame = CGRectMake(0,
                                      primaryView.frame.size.height + 120,
                                      primaryView.frame.size.width,
                                      primaryView.frame.size.height);
         
         //At the same time we are scaling our old view for a nice animation
         [UIView animateWithDuration:kAnimationDurationScaling
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:^{
                            primaryView.transform = CGAffineTransformMakeScale(kDeep, kDeep);
                            
                          } completion:^(BOOL finished) {
                            
                          }];
         
         //Modal like transition animation start
         [UIView animateWithDuration:kAnimationDurationShowingView
                               delay:0.15
                             options:UIViewAnimationOptionCurveEaseOut
                          animations:^{
                            // Set the original frame back
                            self.view.frame = originalFrame;
                          }
                          completion:^(BOOL finished) {
                            //At this point all our animations are complete.
                            completion();
                          }];
         
       }];
    }
  }];

}

- (void)dismissViewControllercompletion:(void (^)(void))completion
{
  UIView *primaryView = self.fromViewController.view;

  //Dismiss Modal
  [UIView animateWithDuration:kAnimationDurationShowingView
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     self.view.frame = CGRectMake(0,
                                                  primaryView.frame.size.height
                                                  + 120,
                                                  self.view.frame.size.width,
                                                  primaryView.frame.size.height);
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       [self.fromViewController
                        dismissViewControllerAnimated:NO completion:^{
                          self.fromViewController.modalPresentationStyle =
                          UIModalPresentationFullScreen;
                        }];
                     }
                   }];
  //Modify Angle
  [UIView animateWithDuration:kAnimationDurationZPosition
                        delay:0.05
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
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
                   } completion:^(BOOL finished) {
                     //restore scaling
                     [UIView animateWithDuration:kAnimationDurationScaling animations:^{
                       primaryView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     } completion:^(BOOL finished) {
                       if (finished)
                         [self.overlayView removeFromSuperview];
                       completion();
                     }];
                   }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
