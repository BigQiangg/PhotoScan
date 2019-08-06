//
//  GroupListViewController.m
//  mytravel
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import "GroupListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define VIEWCONTROLLE_PHOTO(controller)   [[UIStoryboard storyboardWithName:@"TPhotoStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:controller]

@interface GroupListViewController ()

@property(nonatomic,strong) NSMutableArray * asetGroups;

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    _asetGroups = [[NSMutableArray alloc]init];//存放media的数组
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
        
        if (group) {
            NSString * groupTitle = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            NSInteger imageCount = [group numberOfAssets];
            UIImage * thumbnail = [UIImage imageWithCGImage:[group posterImage]];
            
            GroupListModel * model = [[GroupListModel alloc] init];
            model.thumbnail = thumbnail;
            model.photoCount = imageCount;
            model.groupName = groupTitle;
            
            [_asetGroups addObject:model];
            [_tableView reloadData];
            
        }
     
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
      
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _asetGroups.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupListModel * group = [_asetGroups objectAtIndex:indexPath.row];
    TGroupListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TGroupListCell"];
    [cell setInfo:group];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupListModel * model = [_asetGroups objectAtIndex:indexPath.row];
    ChoosePhotoViewController * choosePhotoViewControlller = VIEWCONTROLLE_PHOTO(@"ChoosePhotoViewController");
    choosePhotoViewControlller.delegate = self.delegate;
    choosePhotoViewControlller.groupModel = model;
    [self.navigationController pushViewController:choosePhotoViewControlller animated:YES];
}


-(void)back{
    [_delegate choosePhotoViewControllerDidCancel:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
