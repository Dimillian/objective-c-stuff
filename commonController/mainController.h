//
//  mainController.h
//  ocRef
//
//  Created by Thomas Ricouard on 4/5/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface MainController : NSObject

+(MainController *)sharedController;

@property (nonatomic, readonly, strong) ViewController *firstViewController;
-(void)executeCommonCommand:(id)sender;
-(ViewController *)primaryViewController;
@end
