//
//  EditAndShadowGroupedCell.m
//  ocRef
//
//  Created by Thomas Ricouard on 3/27/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "EditAndShadowGroupedCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation EditAndShadowGroupedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
  

    // Configure the view for the selected state
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
  //The owner tableview should put itself on edit mode by callcing
  //[self.tableView YES animated:YES]; in the controller
  
  if (((UITableView *)self.superview).isEditing) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  else{
    [self setNeedsLayout];
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
  }
}

-(void)setChecked:(BOOL)checked
{
  if (!checked) {
   
  }
  else{

  }
}


- (void)layoutSubviews
{
  [super layoutSubviews];
  
  //PERFORMANCE DOWN
  self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
  self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
  self.contentView.layer.shadowRadius = 1;
  
  //PERFORMANCE UP
  CGRect shadowFrame = self.contentView.layer.bounds;
  //You can modify the path of the shadow here
  shadowFrame.origin.x += 0.50;
  CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
  self.contentView.layer.shadowPath = shadowPath;
  
  //The parant table view
  UITableView *owner = (UITableView *)self.superview;
  
  [UIView animateWithDuration:0.30 animations:^{
    if (owner.isEditing)
    {
      //Modify the frame of what you need here, since you'll make your custom
      //editing view appear you should indent every view on your cell (title,
      //other labels etc...)
      //Modifying the frame x and width should do it
      //don't forget to make your Custom editing view appear too.
    }
    else
    {
      //Restore everything back to normal, frame x and with and make your
      //custom editing view disappear
    }
    
  }completion:^(BOOL finished) {
    if (finished && !owner.isEditing) {
      
    }
  }];
  
}




@end
