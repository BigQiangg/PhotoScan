//
//  ScanPhotoViewController.h
//  mytravel
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"

@protocol ScanPhotoViewControllerDelegate;

@interface ScanPhotoViewController : UIViewController

@property(nonatomic,strong) NSArray * imageModels;

@property(nonatomic,weak) __weak id <ScanPhotoViewControllerDelegate> delegate;

@end


@protocol ScanPhotoViewControllerDelegate <NSObject>

-(void)sendImage:(NSArray *) imageArray;

@end
