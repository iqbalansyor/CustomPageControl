//
//  CustomPageControl.h
//  CustomPageControl
//
//  Created by Iqbal.ansyori on 29/10/18.
//  Copyright © 2018 Iqbal.ansyori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPageControl : UIView
- (instancetype)initWithNumOfPages:(NSInteger)numOfPages
                   displayDotCount:(NSInteger)displayDotCount
                           dotSize:(CGFloat)dotSize
               currentPageDotColor:(UIColor *)currentPageDotColor
                      pageDotColor:(UIColor *)pageDotColor;

- (void)setProgress:(CGFloat)contentOffsetX pageWidth:(CGFloat)pageWidth;
@end
