//
//  GroupListViewController.h
//  mytravel
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePhotoViewController.h"
#import "TGroupListCell.h"
#import "GroupListModel.h"
//#import "BaseViewController.h"

@protocol TChoosePhotoDelegate;

@interface GroupListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) IBOutlet UITableView * tableView;
@property(nonatomic,weak) __weak id <TChoosePhotoDelegate> delegate;

@end


