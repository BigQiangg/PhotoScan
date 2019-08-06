//
//  ScanPhotoViewController.m
//  mytravel
//
//  Created by zhang on 16/4/12.
//  Copyright © 2016年 tuzuu. All rights reserved.
//

#import "ScanPhotoViewController.h"
#import "ImageModel.h"
#import "ChoosePhotoViewController.h"

@interface ScanPhotoViewController ()<UIScrollViewDelegate>

@end

@implementation ScanPhotoViewController
{
    NSMutableArray * imageViews;
    NSInteger currentIndex;
    UIScrollView * bigScrollerView;
    CGFloat lastPointX;
    UILabel * numberLabe;
    NSInteger imageCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
        imageViews = [NSMutableArray array];
    currentIndex = 0;
    imageCount = _imageModels.count;
        bigScrollerView = [[UIScrollView alloc] init];
    bigScrollerView.frame = self.view.bounds;
    bigScrollerView.pagingEnabled = YES;
    bigScrollerView.delegate = self;
    bigScrollerView.bounces = NO;
    bigScrollerView.showsVerticalScrollIndicator = NO;
    bigScrollerView.showsHorizontalScrollIndicator = NO;
    bigScrollerView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
    [self.view addSubview:bigScrollerView];
    
    for (int i = 0; i<3; i++) {
        ImageModel * model = [_imageModels objectAtIndex:(currentIndex + i - 1 + _imageModels.count)%_imageModels.count];
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = model.originImage;
        imageView.clipsToBounds = YES;
        [bigScrollerView addSubview:imageView];
        [imageViews addObject:imageView];
    }
    
    numberLabe = [[UILabel alloc] init];
    numberLabe.frame = CGRectMake(0, 20, self.view.frame.size.width, 30);
    numberLabe.textColor = [UIColor whiteColor];
    numberLabe.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:numberLabe];
    
    lastPointX = self.view.frame.size.width;
    bigScrollerView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    
    //添加点击手势
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    [bigScrollerView addGestureRecognizer:gesture];
}

-(void)sendActionClicked:(UIButton *) btn{
   
    [self dismissViewControllerAnimated:NO completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(sendImage:)]) {
            [_delegate sendImage:_imageModels];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self freshCurrentPage];//显示页数
    
    UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(self.view.frame.size.width - 60 - 15, self.view.frame.size.height - 30 - 8, 60, 30);
    [sendButton addTarget:self action:@selector(sendActionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendButton setTintColor:[UIColor whiteColor]];
#define COLLOR_SYSTEM_MAIN          [UIColor redColor]     //主色

    sendButton.backgroundColor = COLLOR_SYSTEM_MAIN;
    [self.view addSubview:sendButton];
    //修圆角 v 指定修圆角的对象  r圆角半径  b圆角边框宽度  color圆角边框颜色UIColor
#define  ROUND(v,r,b,color)  v.layer.cornerRadius=r;\
v.clipsToBounds = YES;\
v.layer.borderWidth = b;\
v.layer.borderColor = color.CGColor;
    ROUND(sendButton, 4, 1, [UIColor clearColor]);
}

-(void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point =  scrollView.contentOffset;
    CGFloat page = point.x/self.view.frame.size.width;
    NSLog(@"current page = %.0f",page);
    [self resetScrollerAtPage:(int)page];
}

-(void)resetScrollerAtPage:(NSInteger) page{
    if ((int)page == 2) {
        [self toNextImage];//图片切换到下一张
    }
    else if(page == 0){
        [self toBeforeImage];//图片切换到上一张
    }
    bigScrollerView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}

-(void)toNextImage{
    currentIndex += 1;
    currentIndex = currentIndex % imageCount;

    [self freshCurrentPage];
    ImageModel * model = [_imageModels objectAtIndex:(currentIndex + 1 + _imageModels.count)%_imageModels.count];
    UIImageView * firstImageView = imageViews.firstObject;
    firstImageView.image = model.originImage;
    [imageViews removeObjectAtIndex:0];
    [imageViews addObject:firstImageView];
    for (int i = 0; i<3; i++) {
        UIImageView * imageView = [imageViews objectAtIndex:i];
        imageView.frame = CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

-(void)toBeforeImage{
    currentIndex -= 1;
    currentIndex = currentIndex % imageCount;

    [self freshCurrentPage];
    ImageModel * model = [_imageModels objectAtIndex:(currentIndex  - 1 + _imageModels.count)%_imageModels.count];
    UIImageView * lastImageView = imageViews.lastObject;
    lastImageView.image = model.originImage;
    [imageViews removeObjectAtIndex:imageViews.count - 1];
    [imageViews insertObject:lastImageView atIndex:0];
    
    for (int i = 0; i<3; i++) {
        UIImageView * imageView = [imageViews objectAtIndex:i];
        imageView.frame = CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

-(void)freshCurrentPage{
    NSInteger currentPage = (currentIndex + 1 + imageCount)%imageCount;
    currentPage = (currentPage == 0 ? imageCount:currentPage);
    numberLabe.text = [NSString stringWithFormat:@"%d/%ld",(int)imageCount,(long)currentPage];
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
