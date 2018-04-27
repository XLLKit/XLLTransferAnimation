//
//  XLLSecondController.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/24.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLPopController.h"

@interface XLLPopController ()

@end

@implementation XLLPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.delegate = nil;
}

- (void)dealloc
{
    NSLog(@"我撤啦");
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

