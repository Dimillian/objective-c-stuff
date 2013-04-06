//
//  ViewController.m
//  customAnimatedModal
//
//  Created by Thomas Ricouard on 4/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize modalViewController = _modalViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(self.view.center.x - 150/2, 100, 150, 100)];
    [button setTitle:@"Present modal" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showModal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _modalViewController = [[ModalViewController alloc]initWithParentViewController:self
                                                                   completionTarget:self
                                                                             action:@selector(dismissModal)];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showModal
{
    [self.modalViewController presentViewControllercompletion:^{
        
    }];
}

- (void)dismissModal
{
    [self.modalViewController dismissViewControllercompletion:^{
        
    }];
}

- (BOOL)shouldAutorotate
{
    return NO;
}
@end
