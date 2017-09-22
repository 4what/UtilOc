//
//  @author 4what
//

#import "OCGridView.h"

@implementation OCGridView

- (void)gotoItem:(UIScrollView *)scrollView {
	CGFloat width = CGRectGetWidth(scrollView.bounds) / _numberOfItemsInRow;
	CGFloat current = floor((scrollView.contentOffset.x - width / 2.f) / width) + 1;
	CGRect rect = scrollView.bounds;
	rect.origin.x = width * current;
	rect.origin.y = 0;
	[scrollView scrollRectToVisible:rect animated:YES];
}

#pragma mark - getter & setter

- (NSMutableArray *)data {
	if (!_data) {
		_data = [NSMutableArray array];
	}
	return _data;
};

#pragma mark <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.data.count;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

/*
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsZero;
}
*/

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat width = CGRectGetWidth(collectionView.bounds) / _numberOfItemsInRow;
	return CGSizeMake(width, _itemHeight ? _itemHeight : (width + _delta));
}

/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}
*/

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self gotoItem:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		[self gotoItem:scrollView];
	}
}

#pragma mark

- (instancetype)initWithItems:(NSArray *)items numberOfItemsInRow:(CGFloat)numberOfItemsInRow rows:(CGFloat)rows viewController:(UIViewController *)viewController {
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	if (rows == 1) {
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	}

	self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
	if (self) {
		self.data = [items mutableCopy];

		_numberOfItemsInRow = numberOfItemsInRow;

		if (rows == 0) {
			rows = ceil(self.data.count / numberOfItemsInRow);
		}
		_rows = rows;

		_viewController = viewController;

		self.dataSource = self;
		self.delegate = self;

		self.backgroundColor = nil;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;

		self.translatesAutoresizingMaskIntoConstraints = NO;
		if (_itemHeight) {
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_itemHeight * rows]];
		} else {
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 / numberOfItemsInRow * rows constant:_delta * rows]];
		}
	}
	return self;
}

@end
