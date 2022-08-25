#import <UIKit/UIKit.h>

@interface OCSlideView : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSMutableArray *data;

@property (nonatomic) NSString *cellId;

@property (nonatomic) BOOL loop;

@property (nonatomic) CGFloat scale;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) UIViewController *viewController;

- (void)gotoPage:(BOOL)animated;

- (void)reload;

- (instancetype)initWithItems:(NSArray *)items ratio:(CGFloat)ratio timer:(NSTimeInterval)seconds viewController:(UIViewController *)viewController;

@end
