//
//  ViewController.m
//  QR_Code
//
//  Created by Kenny on 16/8/30.
//  Copyright © 2016年 MengYu. All rights reserved.
//

#import "ViewController.h"
#import "Generate/Generate_QR_Code.h"

@interface ViewController ()

@property (nonatomic) Generate_QR_Code *generate;
@property (nonatomic) UIAlertController *alterViewController;

@property (nonatomic) UIButton *btnGenerateQR;
@property (nonatomic) UIButton *btnFetchQR;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGSize size = CGSizeMake(240, 240);
    UIImage *image = [self.generate generateString:@"Hello World!" size:size interpolate:YES];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Generate_QR_Code *)generate
{
    if (!_generate) {
        _generate = [[Generate_QR_Code alloc] init];
    }
    return _generate;
}
@end
