//
//  EditAndShadowGroupedCell.h
//  ocRef
//
//  Created by Thomas Ricouard on 3/27/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <UIKit/UIKit.h>

//This is an example UITableViewCell subclass that could support custom editing
//view
//In this example we have in mind that you place a custom editing view on your
//cell but you hide it until the cell enter edit mode

//This class is not ready to use, it just show the basic behavior your cell
//could have to support custom editing mode

//I also show you how to draw some nice shadows around your cell for grouped
//tableview
@interface EditAndShadowGroupedCell : UITableViewCell


//Your table view controller should call this method when the cell is selected
//or deselected when you are in edit mode in cellForRowAtIndexPath
//If you have a custom editing view it is here where you should display or hide
//the selected image/view
-(void)setChecked:(BOOL)checked;
@end
