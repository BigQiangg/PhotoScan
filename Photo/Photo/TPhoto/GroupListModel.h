//
//  GroupListModel.h
//  mytravel
//
//  Created by zhang on 16/4/13.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GroupListModel : NSObject

@property(nonatomic,strong) NSString * groupName;
@property(nonatomic,strong) UIImage *  thumbnail;
@property(nonatomic,assign) NSInteger  photoCount;

@end
