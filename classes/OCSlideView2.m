#import "OCSlideView2.h"

@implementation OCSlideView2

- (void)gotoPage {
	[self gotoPage:YES];
}

- (void)gotoPage:(BOOL)animated {
/*
	CGRect rect = _scrollView.bounds;
	rect.origin.x = CGRectGetWidth(rect) * _pageControl.currentPage;
	rect.origin.y = 0;
	[_scrollView scrollRectToVisible:rect animated:animated];
*/
	
	[_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.bounds) * _pageControl.currentPage, 0) animated:animated];
}

- (void)timerFireMethod:(NSTimer *)timer {
	if (++_pageControl.currentPage == _pageControl.numberOfPages) {
		_pageControl.currentPage = 0;
	}
	[self gotoPage];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat width = CGRectGetWidth(scrollView.bounds);
	_pageControl.currentPage = floor((scrollView.contentOffset.x - width / 2.f) / width) + 1;
}

#pragma mark

- (instancetype)initWithItems:(NSArray *)items ratio:(CGFloat)ratio timer:(NSTimeInterval)seconds {
	self = [super init];
	if (self) {
		_scale = ratio;

		self.translatesAutoresizingMaskIntoConstraints = NO;

		_scrollView = [[UIScrollView alloc] init];
		[self addSubview:_scrollView];

		_scrollView.delegate = self;

		_scrollView.pagingEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;

		_scrollView.translatesAutoresizingMaskIntoConstraints = NO;
		for (NSString *item in @[@"|[_scrollView]|"]) {
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:item options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
		}

		NSUInteger count = items.count;

		for (int i = 0; i < count; i++) {
			UIView *itemView = items[i];
			[_scrollView addSubview:itemView];

			itemView.translatesAutoresizingMaskIntoConstraints = NO;
			[self addConstraint:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
			if (i == 0) {
				[self addConstraint:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
			} else {
				[self addConstraint:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeCenterX multiplier:2 * i constant:0]];
			}
			if (i == count - 1) {
				[self addConstraint:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
			}
		}

		_pageControl = [[UIPageControl alloc] init];
		[self addSubview:_pageControl];

		_pageControl.hidesForSinglePage = YES;
		_pageControl.numberOfPages = count;

		_pageControl.translatesAutoresizingMaskIntoConstraints = NO;

		[_pageControl addTarget:self action:@selector(gotoPage) forControlEvents:UIControlEventValueChanged];

		if (seconds > 0) {
			[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
		}
	}
	return self;
}

@end
