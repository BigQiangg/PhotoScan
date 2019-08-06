//
//  TGroupListCell.h
//  mytravel
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupListModel.h"

@interface TGroupListCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UIImageView * headImageView;
@property(nonatomic,strong) IBOutlet UILabel * titleLabel;
@property(nonatomic,strong) IBOutlet UILabel * numberLabel;

@property(nonatomic,strong) IBOutlet NSLayoutConstraint * titleWidth;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint * imageToBottom;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint * lineHeight;



-(void)setInfo:(GroupListModel *) model;

@end
