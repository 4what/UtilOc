#import <UIKit/UIKit.h>

@interface OCGridView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSMutableArray *data;

@property (nonatomic, readonly) CGFloat numberOfItemsInRow;
@property (nonatomic, readonly) CGFloat rows;

@property (nonatomic) CGFloat offset;

@property (nonatomic) CGFloat delta;
@property (nonatomic) CGFloat itemHeight;

@property (nonatomic) UIViewController *viewController;

- (instancetype)initWithItems:(NSArray *)items numberOfItemsInRow:(CGFloat)numberOfItemsInRow rows:(CGFloat)rows viewController:(UIViewController *)viewController;

@end
