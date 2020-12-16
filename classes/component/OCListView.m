//
//  @author 4what
//

#import "OCListView.h"

@implementation OCListView {
	CGFloat _columns;
	CGFloat _numberOfItemsInColumn;
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
	return CGSizeMake(CGRectGetWidth(collectionView.bounds) / _columns, CGRectGetHeight(collectionView.bounds) / _numberOfItemsInColumn);
}

/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}
*/

#pragma mark

- (instancetype)initWithItems:(NSArray *)items columns:(CGFloat)columns numberOfItemsInColumn:(CGFloat)numberOfItemsInColumn viewController:(UIViewController *)viewController {
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

	self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
	if (self) {
		self.data = [items mutableCopy];

		_columns = columns;
		_numberOfItemsInColumn = numberOfItemsInColumn;

		_viewController = viewController;

		self.dataSource = self;
		self.delegate = self;

		self.backgroundColor = [UIColor whiteColor];
		self.pagingEnabled = YES;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;

		self.translatesAutoresizingMaskIntoConstraints = NO;
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_itemHeight * numberOfItemsInColumn]];
	}
	return self;
}

@end
