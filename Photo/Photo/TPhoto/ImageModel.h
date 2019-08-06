//
//  ImageModel.h
//  mytravel
//
//  Created by zhang on 16/4/13.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageModel : NSObject

@property(nonatomic,strong) UIImage * thumbnail;//缩略图
@property(nonatomic,strong) UIImage * originImage;//缩略图
@property(nonatomic,assign) BOOL isSelect;//是否选中

@end
