//
//  XLLTabbarController.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/28.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLTabbarController.h"
#import "XLLTabOutsideDelegate.h"
#import "UITabBarController+XLLTransfer.h"

@interface XLLTabbarController ()

@property (nonatomic, strong) XLLTabOutsideDelegate *outDelegate;

@end

@implementation XLLTabbarController

#pragma mark - lazy loading
- (XLLTabOutsideDelegate *)outDelegate
{
    if (_outDelegate == nil)
    {
        _outDelegate = [[XLLTabOutsideDelegate alloc] init];
    }
    return _outDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.translucent = NO;
    self.delegate = self.outDelegate;
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
