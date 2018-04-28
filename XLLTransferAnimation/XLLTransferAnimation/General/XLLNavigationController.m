//
//  XLLNavigationController.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/25.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLNavigationController.h"

@interface XLLNavigationController ()

@end

@implementation XLLNavigationController

+ (void)initialize
{
    // 本类navigationbar
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    //1.获取系统自带滑动手势的target对象
//    id target = self.interactivePopGestureRecognizer.delegate;
//    //2.创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    //3.设置手势代理，拦截手势触发
//    pan.delegate = self;
//    //4.给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
    //5.禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


#pragma mark -- UIGestureRecognizerDelegate
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.childViewControllers.count == 1)
    {
        return NO;
    }
    return YES;
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
