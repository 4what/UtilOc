//
//  @author 4what
//

#import "OCLoadMore.h"

@implementation OCLoadMore {
	UIScrollView *_view;

	CGFloat _footerHeight;
}

static NSString *footerId = @"footer";

static CGFloat padding = 16;
static CGFloat scale = 0.8;

- (void)load {
	CGFloat bottom = _view.contentInset.bottom;
	CGFloat height = CGRectGetHeight(_view.bounds);
	if (_view.contentSize.height > height && (((_view.contentOffset.y + height - bottom) / _view.contentSize.height) > scale)) {
		if (_loading.isAnimating) {
			return;
		}
		[_loading startAnimating];
		NSInteger start = _data.count;
		[_delegate request:^{
			NSInteger count = _data.count;
			if (count > start) {
/*
				NSMutableArray *items = [NSMutableArray array];
				for (int i = start; i < count; i++) {
					[items addObject:[NSIndexPath indexPathForRow:i inSection:0]];
				}
*/
				if ([_view isKindOfClass:[UITableView class]]) {
					//[(UITableView *) _view insertRowsAtIndexPaths:items withRowAnimation:UITableViewRowAnimationAutomatic];

					NSArray<NSIndexPath *> *indexPathsForSelectedRows = ((UITableView *) _view).indexPathsForSelectedRows;

					[(UITableView *) _view reloadData];

					for (NSIndexPath *item in indexPathsForSelectedRows) {
						[(UITableView *) _view selectRowAtIndexPath:item animated:NO scrollPosition:UITableViewScrollPositionNone];
					}
				} else if ([_view isKindOfClass:[UICollectionView class]]) {
					//[(UICollectionView *) _view insertItemsAtIndexPaths:items];

					NSArray<NSIndexPath *> *indexPathsForSelectedItems = [(UICollectionView *) _view indexPathsForSelectedItems];

					[(UICollectionView *) _view reloadData];

					for (NSIndexPath *item in indexPathsForSelectedItems) {
						[(UICollectionView *) _view selectItemAtIndexPath:item animated:NO scrollPosition:UICollectionViewScrollPositionNone];
					}
				}
			}
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1), dispatch_get_main_queue(), ^{
				if (!(ceil(_view.contentOffset.y + height - bottom) < floor(_view.contentSize.height))) {
					[_view setContentOffset:CGPointMake(_view.contentOffset.x, _view.contentOffset.y - _footerHeight) animated:YES];
				}
				[_loading stopAnimating];
			});
		} failure:^{
			[_loading stopAnimating];
		}];
	}
}

#pragma mark <UICollectionViewDataSource>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	UICollectionReusableView *view;
	if (kind == UICollectionElementKindSectionFooter) {
		view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];

		[view addSubview:_loading];

		[view addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
		[view addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	}
	return view;
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self load];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		[self load];
	}
}

#pragma mark

- (instancetype)initWithScrollView:(UIScrollView *)scrollView data:(NSMutableArray *)data {
	self = [super init];
	if (self) {
		_view = scrollView;

		_data = data;

		_loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_loading.translatesAutoresizingMaskIntoConstraints = NO;

		if ([_view isKindOfClass:[UITableView class]]) {
			((UITableView *) _view).tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, padding + CGRectGetHeight(_loading.bounds) + padding)];
			[((UITableView *) _view).tableFooterView addSubview:_loading];

			[(UITableView *) _view addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:((UITableView *) _view).tableFooterView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
			[(UITableView *) _view addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:((UITableView *) _view).tableFooterView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

			_footerHeight = CGRectGetHeight(((UITableView *) _view).tableFooterView.bounds);
		} else if ([_view isKindOfClass:[UICollectionView class]]) {
			[(UICollectionView *) _view registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];

			_footerHeight = padding + CGRectGetHeight(_loading.bounds) + padding;
			((UICollectionViewFlowLayout *) ((UICollectionView *) _view).collectionViewLayout).footerReferenceSize = CGSizeMake(0, _footerHeight);
		}
	}
	return self;
}

@end
