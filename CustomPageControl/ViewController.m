//
//  ViewController.m
//  CustomPageControl
//
//  Created by Iqbal.ansyori on 29/10/18.
//  Copyright © 2018 Iqbal.ansyori. All rights reserved.
//

#import "ViewController.h"
#import "CustomPageControl.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) CustomPageControl *customPageControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addingImageView];
    [self addPageControl];
}

- (void)addingImageView {
	
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 400.f;
    NSInteger imageCount = 20;
    self.scrollView.contentSize = CGSizeMake((imageCount) * screenWidth, height);
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.delegate = self;
    for (NSInteger i = 0; i < imageCount; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"image1"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i * screenWidth, 0, screenWidth, height);
        [self.scrollView addSubview:imageView];
    }
}

- (void)addPageControl {
    CustomPageControl *customPageControl = [[CustomPageControl alloc] initWithNumOfPages:20 displayDotCount:4 dotSize:10 currentPageDotColor:[UIColor blueColor] pageDotColor:[UIColor lightGrayColor]];
    customPageControl.center = CGPointMake(self.scrollView.center.x, CGRectGetMaxY(self.scrollView.frame) + 16);
    //[customPageControl setNumberOfPages:3];
    self.customPageControl = customPageControl;
    [self.view addSubview:customPageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.customPageControl setProgress:scrollView.contentOffset.x pageWidth:scrollView.bounds.size.width];
}

@end
