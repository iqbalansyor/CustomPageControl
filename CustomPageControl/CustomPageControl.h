//
//  CustomPageControl.h
//  CustomPageControl
//
//  Created by Iqbal.ansyori on 29/10/18.
//  Copyright © 2018 Iqbal.ansyori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Config : NSObject<NSCopying>
@end

@interface CustomPageControl : UIView
- (void)setProgress:(CGFloat)contentOffsetX pageWidth:(CGFloat)pageWidth;
- (void)setNumberOfPages:(NSInteger)numberOfPages;
@end
