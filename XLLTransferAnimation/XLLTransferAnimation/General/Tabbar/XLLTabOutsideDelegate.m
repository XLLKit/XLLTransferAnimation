//
//  XLLTabOutsideDelegate.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/28.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLTabOutsideDelegate.h"

@implementation XLLTabOutsideDelegate

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 2)
    {
        NSLog(@"hahahaha");
    }
}

@end
