#import <UIKit/UIKit.h>

@interface OCListView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSMutableArray *data;

@property (nonatomic) CGFloat itemHeight;

@property (nonatomic) UIViewController *viewController;

- (instancetype)initWithItems:(NSArray *)items columns:(CGFloat)columns numberOfItemsInColumn:(CGFloat)numberOfItemsInColumn viewController:(UIViewController *)viewController;

@end
