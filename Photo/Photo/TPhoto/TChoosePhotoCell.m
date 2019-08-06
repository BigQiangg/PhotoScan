//
//  TChoosePhotoCell.m
//  mytravel
//
//  Created by zhang on 16/4/13.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import "TChoosePhotoCell.h"
#import "ChoosePhotoViewController.h"
@implementation TChoosePhotoCell
{
    ImageModel * _model;
}

-(void)setInfo:(ImageModel *)model{
    _model = model;
    
    _imageView.image = model.thumbnail;
    UIImage * image = model.isSelect?[UIImage imageNamed:@"icon_payment_selected.png"]:[UIImage imageNamed:@"icon_payment_select.png"];
    _selectImageView.image = image;
}

-(IBAction) selectImageAction:(UIButton *) btn{
    _model.isSelect = !_model.isSelect;
    UIImage * image = _model.isSelect?[UIImage imageNamed:@"icon_payment_selected.png"]:[UIImage imageNamed:@"icon_payment_select.png"];
    _selectImageView.image = image;
}

@end
