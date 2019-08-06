//
//  ChoosePhotoViewController.m
//  mytravel
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import "ChoosePhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageModel.h"
#import "TChoosePhotoCell.h"
#import "ChoosePhotoViewLayout.h"
#import "ScanPhotoViewController.h"
//#import "SVProgressHUD.h"
#import "GroupListViewController.h"

#define SPACE 5
#define MAX_COUNT 5

@interface ChoosePhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ScanPhotoViewControllerDelegate>

@property(nonatomic,strong) NSMutableArray * imageArray;

@end

@implementation ChoosePhotoViewController
{
    NSMutableArray * selectArray;//选中的图片数组
    NSMutableIndexSet * _indexSet;//记录选中的图片
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = _groupModel.groupName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(quit)];
    
    _indexSet = [[NSMutableIndexSet alloc] init];
    _imageArray = [NSMutableArray array];
    _collectionView.collectionViewLayout = [ChoosePhotoViewLayout new];
    
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [self performSelectorInBackground:@selector(loadPictures) withObject:nil];
}

-(void)loadPictures{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
        if (group != nil) {
            NSString * groupTitle = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            if (_groupModel == nil) {
                _groupModel = [[GroupListModel alloc] init];
                _groupModel.groupName = groupTitle;
            }
            if ([groupTitle isEqualToString:_groupModel.groupName] && group.numberOfAssets == _groupModel.photoCount) {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
                    
                    CGImageRef  ref = [result thumbnail];
                    if (ref) {
                        ImageModel * model = [[ImageModel  alloc] init];
                        model.isSelect = NO;
                        model.thumbnail = [UIImage imageWithCGImage:ref];
                        [_imageArray addObject:model];
                        
                        if (index == _groupModel.photoCount - 1) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [_collectionView reloadData];
//                                [SVProgressHUD dismiss];
                            });
                        }
                    }
                }];
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)quit{
    [_delegate choosePhotoViewControllerDidCancel:self];
//    UIViewController * rootViewController = self.navigationController.viewControllers.firstObject;
//    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageModel * model = [_imageArray objectAtIndex:indexPath.row];
    TChoosePhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TChoosePhotoCell" forIndexPath:indexPath];
    [cell setInfo:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageModel * model = [_imageArray objectAtIndex:indexPath.row];
    
    if (!model.isSelect) {//选中这张图片
        if (_indexSet.count == MAX_COUNT) {
            NSString * message = [NSString stringWithFormat:@"图片数量不能多于%d张" , MAX_COUNT];
            [[[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//            SHOW_MESSAGE(nil, message);
            return;
        }
        [_indexSet addIndex:indexPath.row];
    }
    else{//取消选中
        [_indexSet removeIndex:indexPath.row];
    }
    
    //最后修改图片状态 刷新视图
    model.isSelect = !model.isSelect;
    [_collectionView reloadData];
}

-(IBAction)scanActionTouched:(UIButton *) btn{
    [self loadFullScreenImage:^(NSArray *imageArray) {
        [self pushToScanViewControllerWithImages:imageArray];
    }];
}

-(void)pushToScanViewControllerWithImages:(NSArray *) imageArray{
    
    if (imageArray.count == 0) {
         [[[UIAlertView alloc] initWithTitle:@"请先选择图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//        SHOW_MESSAGE(nil,@"请先选择图片");
        return;
    }
    else if(imageArray.count > MAX_COUNT){
        NSString * message = [NSString stringWithFormat:@"图片数量不能多于%d张" , MAX_COUNT];
         [[[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//        SHOW_MESSAGE(nil, message);
        return;
    }
    
    ScanPhotoViewController * scanViewController = [[ScanPhotoViewController alloc] init];
    scanViewController.imageModels = imageArray;
    scanViewController.delegate = self;
    scanViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

-(IBAction)sendActionTouched:(UIButton *) btn{
    [self loadFullScreenImage:^(NSArray * imageArray) {
        [self sendImage:imageArray];
    }];
}

-(void)sendImage:(NSArray *) imageArray{
    
    if (_delegate && [_delegate respondsToSelector:@selector(choosePhotoViewController: didFinishPickerWithImages:)]) {
        UIViewController * rootViewController = [self.navigationController.viewControllers firstObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate choosePhotoViewController:rootViewController didFinishPickerWithImages:imageArray];
        });
    }
}

-(void)loadFullScreenImage:(void(^)(NSArray * imageArray)) finishBlock{
    if (!selectArray) {
        selectArray = [NSMutableArray array];
    }
    
    if (_indexSet.count == 0) {
//        SHOW_MESSAGE(nil, @"请选择图片");
         [[[UIAlertView alloc] initWithTitle:@"请选择图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        return;
    }
    
    [selectArray removeAllObjects];
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
        if (group != nil) {
            NSString * groupTitle = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            if ([groupTitle isEqualToString:_groupModel.groupName] && group.numberOfAssets == _groupModel.photoCount) {
                //                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
                [group enumerateAssetsAtIndexes:_indexSet options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    CGImageRef  ref = [[result defaultRepresentation] fullScreenImage];
                    if (ref) {
                        ImageModel * model = [[ImageModel alloc] init];
                        model.isSelect = YES;
                        model.originImage = [UIImage imageWithCGImage:ref];
                        [selectArray addObject:model];
                        if (selectArray.count == _indexSet.count ) {
                            finishBlock(selectArray);
                        }
                    }
                }];
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
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

