
#import <UIKit/UIKit.h>

// 设置状态...实际上是根据这些状态选择了不同的颜色而已
typedef NS_ENUM(NSUInteger, GNProgressBarProgressStyle) {
    GNProgressBarProgressStyleNormal,
    GNProgressBarProgressStyleDelete,
    GNProgressBarProgressStyleSelect,
};

@interface GNProgressBar : UIView



// 创建
+ (GNProgressBar *)getInstance;

// 是否隐藏所有的三角箭头
@property (assign, nonatomic) BOOL hiddenTriangleIndicatorImageViews;

// 设置最后一个进度条的风格(实际上是根据风格选择了不同的颜色)
- (void)setLastProgressViewToStyle:(GNProgressBarProgressStyle)style;
// 设置最后一个progress的宽度
- (void)setLastProgressViewToWidth:(CGFloat)width;
// 删除最后一个进度
- (void)deleteLastProgressView;
// 添加一个进度
- (void)addProgressView;
// 停止闪光
- (void)stopShining;
// 开始闪光
- (void)startShining;

// 添加一个progress,并且设置这个progress的宽度... 用来快速的根据一个视频数组,来创建一个progressBar
- (void)addProgressViewWithWidth:(CGFloat)width;

// 移除所有的prpgressView
- (void)removeAllProgressView;

// 改变其中一个的style
- (void)setProgressViewAtIndex:(NSInteger)progressViewIndex ToStyle:(GNProgressBarProgressStyle)style;

// 改变其中一个progressView的宽度
- (void)setProgressViewAtIndex:(NSInteger)progressViewIndex toWidth:(CGFloat)width;

@end
