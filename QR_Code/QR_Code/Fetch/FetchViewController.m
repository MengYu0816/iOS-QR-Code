//
//  FetchViewController.m
//  QR_Code
//
//  Created by Kenny on 16/9/19.
//  Copyright © 2016年 MengYu. All rights reserved.
//

#import "FetchViewController.h"
#import "Fetch_QR_code.h"
#include "GlobalDefine.h"

@interface FetchViewController ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic) NSString *fetchString;
@end

@implementation FetchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[Fetch_QR_code shareInstance] initCaptureInView:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFetchString:)
                                                 name:NOTIFICATION_FETCH_STRING
                                               object:nil];
    [[Fetch_QR_code shareInstance] startCaptureSession];

}

- (void)showFetchString:(NSNotification *)notify
{
    self.fetchString = [notify object];
    NSLog(@"%s:%d,%@", __FUNCTION__, __LINE__, self.fetchString);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_FETCH_STRING
                                                  object:nil];
    [[Fetch_QR_code shareInstance] stopCaptureSession];
}

- (void)addBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(24, 24, 50, 25);
    backBtn.layer.backgroundColor = [UIColor blueColor].CGColor;
    [backBtn setTitle:@"BACK"
             forState:UIControlStateNormal];
    [backBtn addTarget:self
                action:@selector(backToPreview:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backToPreview:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
/*
#pragma mark - Navigation
 .
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
