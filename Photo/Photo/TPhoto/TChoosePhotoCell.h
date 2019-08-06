//
//  TChoosePhotoCell.h
//  mytravel
//
//  Created by zhang on 16/4/13.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"

@interface TChoosePhotoCell : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UIImageView * imageView;
@property(nonatomic,strong) IBOutlet UIImageView * selectImageView;


-(void)setInfo:(ImageModel *) model;

@end
