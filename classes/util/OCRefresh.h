//
//  @author 4what
//

#import <UIKit/UIKit.h>

@protocol OCRefreshDelegate <NSObject>

- (void)reload;

@end


@interface OCRefresh : NSObject

@property (nonatomic, weak) id <OCRefreshDelegate> delegate;

@property (nonatomic) CGFloat diameter;

@property (nonatomic) UIColor *trackColor;
@property (nonatomic) UIColor *pointerColor;

@property (nonatomic, readonly) BOOL running;

- (void)complete;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@end
