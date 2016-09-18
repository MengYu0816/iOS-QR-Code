//
//  ViewController.m
//  QR_Code
//
//  Created by Kenny on 16/8/30.
//  Copyright © 2016年 MengYu. All rights reserved.
//

#import "ViewController.h"
#import "GlobalDefine.h"
#import "Generate/Generate_QR_Code.h"
#import "CustomIOSAlertView.h"

@interface ViewController ()<UIAlertViewDelegate, CustomIOSAlertViewDelegate>

@property (nonatomic) Generate_QR_Code *generate;
@property (nonatomic) UIAlertController *alterViewController;

@property (nonatomic) UIButton *btnGenerateQR;
@property (nonatomic) UIButton *btnFetchQR;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initButton
{
    CGSize size = CGSizeMake(200, 200);
    
    for (int index=0; index<2; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        [button setFrame:CGRectMake((SCREEN_WIDTH-size.width)/2, (SCREEN_HEIGHT/2-size.height)/2 + SCREEN_HEIGHT*index/2, size.width, size.height)];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];
        
        button.tag = 100+index;
        button.backgroundColor = LRRGBAColor(0, 0, 1, 0.8);
        
        if (100 == button.tag) {
            [button setTitle:@"Generate Code"
                    forState:UIControlStateNormal];
        } else {
            [button setTitle:@"Fetch Code"
                    forState:UIControlStateNormal];
        }
        [button addTarget:self
                   action:@selector(btnAction:)
         forControlEvents:UIControlEventTouchUpInside];
//        NSLog(@"%s:%d, button tag:%ld", __FUNCTION__, __LINE__, (long)button.tag);
        [self.view addSubview:button];
    }
}

- (void)btnAction:(UIButton *)btn
{
    if (100 == btn.tag) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Generate Code"
                                                                       message:@"Please input string"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField setPlaceholder:@"Please input string:"];
            [textField becomeFirstResponder];
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"Confirm"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    UITextField *textField = alert.textFields.firstObject;
                                                    NSLog(@"%@", textField.text);
                                                    [self showGenerateImage:textField.text];
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    
                                                }]];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fetch Code"
                                                                       message:@" "
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    
                                                }]];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
}

- (void)showGenerateImage:(NSString *)str
{
    CGSize size = CGSizeMake(240, 240);
    UIImage *image = [self.generate generateString:str
                                               size:size
                                        interpolate:YES];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerView:imageView];
    [alertView setButtonTitles:[NSArray arrayWithObjects:@"OK", nil]];
    [alertView setDelegate:self];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    [alertView setUseMotionEffects:YES];
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

- (UIAlertController *)alterViewController
{
    if (!_alterViewController) {
        _alterViewController = [[UIAlertController alloc] init];
    }
    return _alterViewController;
}

- (Generate_QR_Code *)generate
{
    if (!_generate) {
        _generate = [[Generate_QR_Code alloc] init];
    }
    return _generate;
}

@end
