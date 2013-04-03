//
//  modalViewController.h
//  ocRef
//
//  Created by Thomas Ricouard on 4/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalViewController : UIViewController

- (id)initWithParentViewController:(UIViewController *)parentController
                  completionTarget:(id)target
                            action:(SEL)action;
@property (nonatomic, assign) UIViewController *fromViewController;
@property (nonatomic, strong, readonly) UIView *overlayView;
@property (nonatomic, assign) id completionTarget;
@property (nonatomic, assign) SEL completionAction;

- (void)presentViewControllercompletion:(void (^)(void))completion;
- (void)dismissViewControllercompletion:(void (^)(void))completion;
@end
