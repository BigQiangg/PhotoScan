//
//  ChoosePhotoViewController.h
//  mytravel
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupListModel.h"
//#import "BaseViewController.h"
@protocol TChoosePhotoDelegate;

@interface ChoosePhotoViewController : UIViewController

@property(nonatomic,strong) IBOutlet UICollectionView * collectionView;

@property(nonatomic,strong) GroupListModel * groupModel;

@property(nonatomic,weak) __weak id <TChoosePhotoDelegate> delegate;

-(void)sendImage:(NSArray *) imageArray;

@property(nonatomic, assign)NSInteger selectCount;

@end


@protocol TChoosePhotoDelegate <NSObject>

/*选取了一组图片*/
-(void)choosePhotoViewController:(UIViewController *) controller didFinishPickerWithImages:(NSArray *) pickerImages;

/*取消了图片选取*/
-(void)choosePhotoViewControllerDidCancel:(UIViewController *) controller;

@end
