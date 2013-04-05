//
//  ViewController.h
//  gesture
//
//  Created by Thomas Ricouard on 4/5/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) UIView *draggableView;
@property (nonatomic, strong) UIPanGestureRecognizer *gesture;
@end
