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

@interface FetchViewController ()<UIWebViewDelegate, UITextViewDelegate>

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
    [self addBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)showFetchString:(NSNotification *)notify
{
    NSString *fetchString = [notify object];
//    NSLog(@"%s:%d,%@", __FUNCTION__, __LINE__, fetchString);
    if (fetchString != nil) {
        [[Fetch_QR_code shareInstance] stopCaptureSession];
    } else {
        return;
    }
    [[Fetch_QR_code shareInstance] removePreviewLayerFromSuperview];

    if ([self isValidUrlString:fetchString]) {
        [self showWebView:[self convertStringToValidUrl:fetchString]];
    } else {
        [self showString:fetchString];
    }
}

- (NSURL *)convertStringToValidUrl:(NSString *)string
{
    NSString *urlStr;

    if (string.length > 4 && [[string substringToIndex:4] isEqualToString:@"www."]) {
        urlStr = [NSString stringWithFormat:@"https://%@", string];
    } else {
        urlStr = string;
    }

    return [NSURL URLWithString:urlStr];
}

-(BOOL)isValidUrlString:(NSString *)string
{
    NSString *url;

    if (string.length > 4 && [[string substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"https://%@", string];
    } else {
        url = string;
    }

    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];

    return [urlPredicate evaluateWithObject:url];
}

- (void)showString:(NSString *)string
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view setBackgroundColor:[UIColor whiteColor]];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 80, view.bounds.size.width - 50*2, view.bounds.size.height - 80*2)];
    [textView setDelegate:self];
    [textView setEditable:NO];
    [textView setText:string];
    [textView setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:textView];

    [self.view insertSubview:view
                     atIndex:0];
}

- (void)showWebView:(NSURL *)url
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [webView setDelegate:self];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];

    [self.view insertSubview:webView
                     atIndex:0];
//    [self.view addSubview:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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
    backBtn.frame = CGRectMake(5, 5, 30, 15);
    backBtn.layer.backgroundColor = [UIColor colorWithRed:0 green:0.3 blue:1 alpha:0.4].CGColor;
    [backBtn setTitleColor:[UIColor colorWithRed:1 green:0.8 blue:0.8 alpha:0.8] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:8]];
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
