//
//  TGroupListCell.m
//  mytravel
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import "TGroupListCell.h"

@implementation TGroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfo:(GroupListModel *)model{
    
    _titleLabel.text = model.groupName;
    
    _titleWidth.constant = [_titleLabel sizeThatFits:CGSizeMake(200, _titleLabel.frame.size.height)].width;
    //[Common rectWithFont:_titleLabel.font size:CGSizeMake(200, _titleLabel.frame.size.height) text:model.groupName].size.width;
    _imageToBottom.constant = 0.5;
    _lineHeight.constant = 0.5;
    self.headImageView.image = model.thumbnail;
//    self.titleLabel.text = model.groupName;
    self.numberLabel.text = [NSString stringWithFormat:@"(%d)",(int)model.photoCount];
}

@end
