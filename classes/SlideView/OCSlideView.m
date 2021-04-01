#import "OCSlideView.h"

#import "OCSlideViewCell.h"

@implementation OCSlideView

- (void)gotoItem:(NSInteger)index animated:(BOOL)animated {
	//[_collectionView setContentOffset:CGPointMake(CGRectGetWidth(_collectionView.bounds) * index, 0) animated:animated];

/*
	CGRect rect = _collectionView.bounds;
	rect.origin.x = CGRectGetWidth(rect) * index;
	rect.origin.y = 0;
	[_collectionView scrollRectToVisible:rect animated:animated];
*/

	[_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

- (void)gotoPage {
	[self gotoPage:YES];
}

- (void)gotoPage:(BOOL)animated {
	[self gotoItem:_loop ? _pageControl.currentPage + 1 : _pageControl.currentPage animated:animated];
}

- (void)reload {
	_pageControl.numberOfPages = self.data.count;
	
	[_collectionView reloadData];
}

- (void)timerFireMethod:(NSTimer *)timer {
	if (self.data.count <= 1) {
		return;
	}

	if (++_pageControl.currentPage == _pageControl.numberOfPages) {
		_pageControl.currentPage = 0;

		if (_loop) {
			[self gotoItem:_pageControl.numberOfPages + 1 animated:YES];

			return;
		}
	}

	[self gotoPage];
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
	OCSlideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellId forIndexPath:indexPath];

/*
	UIView *itemView = self.data[indexPath.item];
	[cell.contentView addSubview:itemView];

	itemView.translatesAutoresizingMaskIntoConstraints = NO;
	for (NSString *item in @[@"|[itemView]|", @"V:|[itemView]|"]) {
		[cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:item options:0 metrics:nil views:NSDictionaryOfVariableBindings(itemView)]];
	}
*/

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (_loop && self.data.count > 1) {
		id firstObject = self.data.firstObject;
		id lastObject = self.data.lastObject;
		[self.data addObject:firstObject];
		[self.data insertObject:lastObject atIndex:0];

		[_collectionView setContentOffset:CGPointMake(CGRectGetWidth(_collectionView.bounds), 0) animated:NO];
	}

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
	return CGSizeMake(CGRectGetWidth(collectionView.bounds), CGRectGetHeight(collectionView.bounds));
}

/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}
*/

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat width = CGRectGetWidth(scrollView.bounds);
	NSInteger page = floor((scrollView.contentOffset.x - width / 2.f) / width) + 1;
	
	if (_loop) {
		if (page == 0) {
			_pageControl.currentPage = _pageControl.numberOfPages - 1;

			[self gotoItem:_pageControl.numberOfPages animated:NO];
		} else if (page == _pageControl.numberOfPages + 1) {
			_pageControl.currentPage = 0;

			[self gotoItem:1 animated:NO];
		} else {
			_pageControl.currentPage = page - 1;
		}
	} else {
		_pageControl.currentPage = page;
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	if (_loop && _pageControl.currentPage == 0) {
		[self gotoItem:1 animated:NO];
	}
}

#pragma mark

- (instancetype)initWithItems:(NSArray *)items ratio:(CGFloat)ratio timer:(NSTimeInterval)seconds viewController:(UIViewController *)viewController {
	self = [super init];
	if (self) {
		self.data = [items mutableCopy];

		_scale = ratio;

		_viewController = viewController;

		_cellId = @"cell";

		self.translatesAutoresizingMaskIntoConstraints = NO;

		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
		[self addSubview:_collectionView];

		_collectionView.dataSource = self;
		_collectionView.delegate = self;

		_collectionView.backgroundColor = nil;
		_collectionView.pagingEnabled = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.showsVerticalScrollIndicator = NO;

		_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
		for (NSString *item in @[@"|[_collectionView]|"]) {
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:item options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
		}

		[_collectionView registerClass:[OCSlideViewCell class] forCellWithReuseIdentifier:_cellId];

		_pageControl = [[UIPageControl alloc] init];
		[self addSubview:_pageControl];

		_pageControl.hidesForSinglePage = YES;
		_pageControl.numberOfPages = self.data.count;

		_pageControl.translatesAutoresizingMaskIntoConstraints = NO;

		[_pageControl addTarget:self action:@selector(gotoPage) forControlEvents:UIControlEventValueChanged];

		if (seconds > 0) {
			[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
		}
	}
	return self;
}

@end
