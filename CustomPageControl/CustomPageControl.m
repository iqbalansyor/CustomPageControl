//
//  CustomPageControl.m
//  CustomPageControl
//
//  Created by Iqbal.ansyori on 29/10/18.
//  Copyright © 2018 Iqbal.ansyori. All rights reserved.
//

#import "CustomPageControl.h"

typedef NS_ENUM(NSInteger, ItemViewState) {
    ItemViewStateNone,
    ItemViewStateSmall,
    ItemViewStateMedium,
    ItemViewStateNormal
};

typedef NS_ENUM(NSInteger, Direction) {
    DirectionRight,
    DirectionLeft,
    DirectionStay
};

@interface ItemView : UIView
@property (nonatomic, assign) CGFloat itemSize;
@property (nonatomic, assign) CGFloat dotSize;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) ItemViewState state;
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UIColor *dotColor;
+ (CGFloat)mediumSizeRatio;
+ (CGFloat)smallSizeRatio;
@end

@implementation ItemView

+ (CGFloat)mediumSizeRatio {
    return 0.7f;
}

+ (CGFloat)smallSizeRatio {
    return 0.4f;
}

- (instancetype)initWithItemSize:(CGFloat)itemSize dotSize:(CGFloat)dotSize index:(NSInteger)index {
    CGFloat xPos = itemSize * index;
    CGRect frame = CGRectMake(xPos, 0, itemSize, itemSize);
    self = [self initWithFrame:frame];
    
    if (self) {
        self.itemSize = itemSize;
        self.dotSize = dotSize;
        self.index = index;
        self.state = ItemViewStateNormal;
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    UIView *dotView = [UIView new];
    CGRect dotViewFrame = dotView.frame;
    dotViewFrame.size.width = self.dotSize;
    dotViewFrame.size.height = self.dotSize;
    [dotView setFrame:dotViewFrame];
    dotView.center = CGPointMake(self.itemSize / 2.f, self.itemSize / 2.f);
    
    // todo : customize
    dotView.backgroundColor = [UIColor lightGrayColor];
    dotView.layer.cornerRadius = self.dotSize / 2.f;
    dotView.layer.masksToBounds = YES;
    
    self.dotView = dotView;
    [self addSubview:dotView];
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    self.dotView.backgroundColor = dotColor;
}

- (void)setState:(ItemViewState)state {
    _state = state;
    [self updateDotSize:state];
}

- (void)updateDotSize:(ItemViewState)state {
    CGSize size;
    
    switch (state) {
        case ItemViewStateNormal:
            size = CGSizeMake(self.dotSize, self.dotSize);
        case ItemViewStateMedium:
            size = CGSizeMake(self.dotSize * ItemView.mediumSizeRatio, self.dotSize * ItemView.mediumSizeRatio);
            break;
        case ItemViewStateSmall:
            size = CGSizeMake(self.dotSize * ItemView.smallSizeRatio, self.dotSize * ItemView.smallSizeRatio);
            break;
        case ItemViewStateNone:
            size = CGSizeZero;
            break;
    }
    
    self.dotView.layer.cornerRadius = size.height / 2.0;
    
//    UIView.animate(withDuration: animateDuration, animations: { [unowned self] in
//        self.dotView.layer.bounds.size = _size
//    }}
    
    NSTimeInterval animateDuration = 0.2;
    [UIView animateWithDuration:animateDuration animations:^{
        CGRect dotViewFrame =  self.dotView.frame;
        dotViewFrame.size = size;
        [self.dotView setBounds:dotViewFrame];
    }];
}

@end

@interface CustomPageControl () <UIScrollViewDelegate>

// Config

@property (nonatomic, assign) NSInteger displayCount;
@property (nonatomic, assign) CGFloat dotSize;
@property (nonatomic, assign) CGFloat dotSpace;
@property (nonatomic, assign) CGFloat smallDotSizeRatio;
@property (nonatomic, assign) CGFloat mediumDotSizeRatio;
@property (nonatomic, assign) CGFloat itemSize;

// End - config

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSTimeInterval animateDuration;
@property (nonatomic, strong) NSMutableArray<ItemView *> *itemViews;
@property (nonatomic, assign) NSInteger numOfPages;
@end

@implementation CustomPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
        [self initView];
    }
    return self;
}

- (void)initConfig {
    _displayCount = 7;
    _dotSize = 10.0f;
    _dotSpace = 4.0f;
    _itemSize = _dotSize + _dotSpace;
    _smallDotSizeRatio = 0.5f;
    _mediumDotSizeRatio = 0.7f;
}

- (void)initView {
    self.currentPage = 0;
    self.animateDuration = 0.2f;
    self.itemViews = [NSMutableArray new];
    [self addSubview:self.scrollView];
}

- (void)setProgress:(CGFloat)contentOffsetX pageWidth:(CGFloat)pageWidth {
    NSInteger currentPage = round(contentOffsetX / pageWidth);
    [self setCurrentPage:currentPage animated:YES];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    if (currentPage > self.numOfPages && self.currentPage < 0) {
        return;
    }
    
    if (currentPage == self.currentPage) {
        return;
    }
    
    [self.scrollView.layer removeAllAnimations];
    [self updateDotAtCurrentPage:currentPage animated:YES];
    _currentPage = currentPage;
}

- (void)setNumberOfPages:(NSInteger)numOfPages {
    _numOfPages = numOfPages;
    self.scrollView.hidden = numOfPages <= 1;
    [self updateCurrentPage:self.currentPage numOfPages:numOfPages];
}

- (void)updateCurrentPage:(NSInteger)currentPage numOfPages:(NSInteger)numOfPages {
    
    CGRect scrollViewFrame = CGRectMake(0, 0, self.itemSize * self.displayCount, self.itemSize);
    self.scrollView.frame = scrollViewFrame;
    self.scrollView.contentSize = CGSizeMake(self.itemSize * numOfPages, self.itemSize);
    
    for (NSInteger pageIndex = 0; pageIndex < numOfPages; pageIndex++) {
        ItemView *itemView = [[ItemView alloc] initWithItemSize:self.itemSize dotSize:self.dotSize index:pageIndex];
        [self.itemViews addObject:itemView];
        [self.scrollView addSubview:itemView];
    }
    
//    if (self.displayCount < numberOfPage) {
//        self.scrollView.contentInset = UIEdgeInsetsMake(0, [self getItemSize] * 2, 0, )
//    }
    
    [self updateDotAtCurrentPage:currentPage animated:NO];
    
}

- (void)updateDotAtCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    [self updateDotColor:currentPage];
    
    // add here
    if (self.numOfPages > self.displayCount) {
        [self updateDotPosition:currentPage animated:animated];
        [self updateDotSize:currentPage animated:animated];
    }
}

- (void)updateDotColor:(NSInteger)currentPage {
    for (NSInteger pageIndex = 0; pageIndex < self.itemViews.count; pageIndex++) {
        if (pageIndex == currentPage) {
            self.itemViews[pageIndex].dotColor = [UIColor blueColor];
        }
        else {
            self.itemViews[pageIndex].dotColor = [UIColor lightGrayColor];
        }
    }
}

- (void)updateDotPosition:(NSInteger)currentPage animated:(BOOL)animated {
    NSTimeInterval duration = 0;
    if (animated) {
        duration = self.animateDuration;
    }
    
    CGFloat targetXPos = currentPage * self.itemSize;
    CGFloat targetXPos2 = currentPage * self.itemSize + self.itemSize;
    CGFloat currentXPos = self.scrollView.contentOffset.x + self.itemSize;
    CGFloat currentXPos2 = self.scrollView.contentOffset.x + self.scrollView.bounds.size.width - self.itemSize;
    if (currentPage == 0) {
        CGFloat xPos = 0;
        //-self.scrollView.contentInset.left;
        [self moveScrollView:xPos animateDuration:duration];
    }
    else if (currentPage == self.numOfPages - 1) {
        CGFloat xPos = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
        //+ self.scrollView.contentInset.right;
        [self moveScrollView:xPos animateDuration:duration];
    }
    else if (currentPage * self.itemSize < self.scrollView.contentOffset.x + self.itemSize) {
        CGFloat xPos = self.scrollView.contentOffset.x - self.itemSize;
        [self moveScrollView:xPos animateDuration:duration];
    }
    else if (currentPage * self.itemSize + self.itemSize >
        self.scrollView.contentOffset.x + self.scrollView.bounds.size.width - self.itemSize) {
        CGFloat xPos = self.scrollView.contentOffset.x + self.itemSize;
        [self moveScrollView:xPos animateDuration:duration];
    }
    
    //NSLog(@"Item View Index %ld", itemIndex);
    //NSLog(@" %ld", itemView.state);
}

- (void)moveScrollView:(CGFloat)xPos animateDuration:(NSTimeInterval)animateDuration {
    Direction direction = [self behaviourDirection:xPos];
    
    // TODO: Reused view?
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.scrollView.contentOffset = CGPointMake(xPos, self.scrollView.contentOffset.y);
    }];
}

- (Direction)behaviourDirection:(CGFloat)targetXPos {
    
    if (targetXPos > self.scrollView.contentOffset.x) {
        return DirectionRight;
    }
    else if (targetXPos < self.scrollView.contentOffset.x) {
        return DirectionLeft;
    } else {
        return DirectionStay;
    }
}

- (void)updateDotSize:(NSInteger)currentPage animated:(BOOL)animated {
    NSTimeInterval duration = 0;
    if (animated) {
        duration = self.animateDuration;
    }
    
    for (NSInteger itemIndex = 0; itemIndex < self.itemViews.count; itemIndex++) {
        ItemView *itemView = self.itemViews[itemIndex];
        // TODO: Customize animation
        //itemView = duration
        
        if (itemIndex == currentPage) {
            itemView.state = ItemViewStateNormal;
        }
        
        // outside of left
        else if (itemIndex < 0) {
            itemView.state = ItemViewStateNone;
        }
        
        // outside of right
        else if (itemIndex > self.numOfPages - 1) {
            itemView.state = ItemViewStateNone;
        }
        
        // first dot from left
        else if (CGRectGetMinX(itemView.frame) <= self.scrollView.contentOffset.x) {
            itemView.state = ItemViewStateSmall;
        }
        // first dot from right
        else if (CGRectGetMaxX(itemView.frame) >= (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width)) {
            itemView.state = ItemViewStateSmall;
        }
        // second dot from left
        else if (CGRectGetMinX(itemView.frame) <= (self.scrollView.contentOffset.x + self.itemSize)) {
            itemView.state = ItemViewStateMedium;
        }
        // second dot from right
        else if (CGRectGetMaxX(itemView.frame) >= (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width - self.itemSize)) {
            itemView.state = ItemViewStateMedium;
        }
        else {
            itemView.state = ItemViewStateNormal;
        }
        
        //NSLog(@"Item View Index %ld", itemIndex);
        NSLog(@"Item View State %ld", itemView.state);
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.userInteractionEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView = scrollView;
    }
    return _scrollView;
}

@end
