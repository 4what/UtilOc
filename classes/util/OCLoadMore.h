//
//  @author 4what
//

#import <UIKit/UIKit.h>

@protocol OCLoadMoreDelegate <NSObject>

- (void)request:(void (^)())success failure:(void (^)())failure;

@end


@interface OCLoadMore : NSObject

@property (nonatomic, weak) id <OCLoadMoreDelegate> delegate;

@property (nonatomic) NSMutableArray *data;
@property (nonatomic) UIActivityIndicatorView *loading;

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (instancetype)initWithData:(NSMutableArray *)data view:(UIScrollView *)view;

@end
