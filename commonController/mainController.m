//
//  mainController.m
//  ocRef
//
//  Created by Thomas Ricouard on 4/5/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "mainController.h"

@interface MainController ()

@property (nonatomic, readwrite, strong) ViewController *firstViewController;
@end

@implementation MainController
static MainController *sharedController = nil;

+(MainController *)sharedController {
  if (sharedController == nil) {
    sharedController = [[[self class] alloc] init];
    [sharedController initializeHierarchy];
  }
  return sharedController;
}

-(void)initializeHierarchy
{
  _firstViewController = [[ViewController alloc]initWithNibName:@"ViewController_iPhone"
                                                         bundle:nil];
}

-(ViewController *)primaryViewController
{
  return _firstViewController;
}

-(void)executeCommonCommand:(id)sender
{
  NSInteger tag = [sender tag];
}
@end
