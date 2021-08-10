//
// @author 4what
//

#import <UIKit/UIKit.h>

@interface OCSlideView2 : UIView <UIScrollViewDelegate>

@property (nonatomic) CGFloat scale;

@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) UIScrollView *scrollView;

- (void)gotoPage:(BOOL)animated;

- (instancetype)initWithItems:(NSArray *)items ratio:(CGFloat)ratio timer:(NSTimeInterval)seconds;

@end
