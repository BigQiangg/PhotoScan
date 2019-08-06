//
//  ViewController.m
//  Photo
//
//  Created by zhang on 16/9/21.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import "ViewController.h"

#import "GroupListViewController.h"
#import "ImageModel.h"

#define VIEWCONTROLLE_PHOTO(controller)   [[UIStoryboard storyboardWithName:@"TPhotoStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:controller]


@interface ViewController ()<TChoosePhotoDelegate>

@property (nonatomic,strong) IBOutlet UIImageView * imageView;

@end

@implementation ViewController{
    GroupListViewController * groupViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"相册DEMO";
    // Do any additional setup after loading the view, typically from a nib.
    groupViewController = VIEWCONTROLLE_PHOTO(@"GroupListViewController");
    groupViewController.delegate = self;
}

-(IBAction)selectImageSelected:(id)sender{
    [self.navigationController pushViewController:groupViewController animated:YES];
}

-(IBAction)selectImage2Selected:(id)sender{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:groupViewController];
    [self presentViewController:nav animated:YES completion:nil];
    //    [self.navigationController pushViewController:groupViewController animated:YES];
}


//点击取消按钮后退出相册
-(void)choosePhotoViewControllerDidCancel:(UIViewController *)controller{
//    [controller dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToViewController:self animated:YES];
    if (controller.navigationController && [controller.navigationController isEqual:self.navigationController]) {
        [self.navigationController popToViewController:self animated:YES];
    }else{
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

//选择图片点击确认后退出相册
-(void)choosePhotoViewController:(UIViewController *)controller didFinishPickerWithImages:(NSArray *)pickerImages{
    if (controller.navigationController && [controller.navigationController isEqual:self.navigationController]) {
        [self.navigationController popToViewController:self animated:YES];
    }else{
        [controller dismissViewControllerAnimated:YES completion:nil];
    }

    //需要先返回到页面再给ImageView赋值
    _imageView.image = ((ImageModel *)pickerImages.firstObject).originImage;
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
