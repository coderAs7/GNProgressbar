

#import "GNProgressBar.h"
#import "GNFrameToolKit.h"
#import "GNProgressView.h"


#define UIColorFromRGB(rgbValue,alphaValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:(float)(alphaValue)]

#define BAR_BLUE_COLOR      UIColorFromRGB(0x36bb2a, 1)
#define BAR_RED_COLOR       UIColorFromRGB(0xfa5a5a, 1)
#define BAR_BG_COLOR        UIColorFromRGB(0x454545, 1)
#define BAR_SELECT_COLOR    UIColorFromRGB(0x554c9a, 1)

#define BAR_H               7.5
#define BAR_MIN_W           75
#define INDICATOR_W         5
#define TIMER_INTERVAL      1.0f

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define GET_SCREEN_SCALE(scale) CGFloat scale = SCREEN_WIDTH /375.0f;

@interface GNProgressBar ()
@property (strong, nonatomic) UIView *barView;
@property (strong, nonatomic) NSTimer *shiningTimer;
// 进度条数组
@property (strong, nonatomic) NSMutableArray *progressViewArray;
// 闪光的光标
@property (strong, nonatomic) UIImageView *progressIndicator;

@end

@implementation GNProgressBar

#pragma mark - 初始化

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize
{
    GET_SCREEN_SCALE(scale);
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = BAR_BG_COLOR;
    self.progressViewArray = [[NSMutableArray alloc] init];
    
    //barView
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BAR_H)];
    _barView.backgroundColor = BAR_BG_COLOR;
    [self addSubview:_barView];
    
    //最短分割线,实际上就是限制最少录制多少的一个提示小黑条
    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(BAR_MIN_W*scale, 0, 1, BAR_H)];
    intervalView.backgroundColor = [UIColor blackColor];
    [_barView addSubview:intervalView];
    
    //indicator,就是那个闪光的光标一样的东西
    self.progressIndicator = [self getProgressIndicator];
    _progressIndicator.center = CGPointMake(0, BAR_H / 2);
    [self refreshIndicatorPosition];
    [self addSubview:_progressIndicator];
}


#pragma mark - method
- (void)startShining
{
    self.shiningTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)stopShining
{
    [_shiningTimer invalidate];
    self.shiningTimer = nil;
    _progressIndicator.alpha = 1;
}

- (void)addProgressView
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    CGFloat newProgressX = 0.0f;
    
    if (lastProgressView) {
        CGRect frame = lastProgressView.frame;
        frame.size.width -= 1;
        lastProgressView.frame = frame;
        
        newProgressX = frame.origin.x + frame.size.width + 1;
    }
    
    UIView *newProgressView = [self getProgressView];
    
    [GNFrameToolKit setView:newProgressView toOriginX:newProgressX];
    [_barView addSubview:newProgressView];
    
    [_progressViewArray addObject:newProgressView];
}

- (void)setLastProgressViewToWidth:(CGFloat)width;
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [GNFrameToolKit setView:lastProgressView toSizeWidth:width];
    [self refreshIndicatorPosition];
}

- (void)addProgressViewWithWidth:(CGFloat)width {

    // 取出所有进度条的最后一个
    UIView *lastProgressView = [_progressViewArray lastObject];
    CGFloat newProgressX = 0.0f;
    // 如果最后一个不存在的话
    if (!lastProgressView) {
        // 创建一个
        UIView *newProgressView = [self getProgressView];
        // 设置frame.origin.x = 0
        [GNFrameToolKit setView:newProgressView toOriginX:newProgressX];
        // 设置宽度
        [GNFrameToolKit setView:newProgressView toSizeWidth:width];
        // 进行添加显示
        [_barView addSubview:newProgressView];
        // 存到数组当中,进行保存
        [_progressViewArray addObject:newProgressView];
    }// 如果最后一个存在的话
    else {
        // 实际上是取出来最后一个,并且让最后一个的宽度进行了减一
        // 取出最后一个的frame...
        CGRect frame = lastProgressView.frame;
        // 让宽度-1
        frame.size.width -= 1;
        // 设置最后的一个的frame
        lastProgressView.frame = frame;
        
        // 计算新的一个progress的View的位置
        newProgressX = frame.origin.x + frame.size.width + 1;
        // 创建
        UIView *newProgressView = [self getProgressView];
        // 设置x
        [GNFrameToolKit setView:newProgressView toOriginX:newProgressX];
        // 设置width
        [GNFrameToolKit setView:newProgressView toSizeWidth:width];
        // 添加
        [_barView addSubview:newProgressView];
        // 并且记录保存
        [_progressViewArray addObject:newProgressView];
    }
    
    [self refreshIndicatorPosition];
}

- (void)setProgressViewAtIndex:(NSInteger)progressViewIndex ToStyle:(GNProgressBarProgressStyle)style {
    UIView * currentProgressView = [_progressViewArray objectAtIndex:progressViewIndex];
    if (!currentProgressView) {
        return;
    }
    
    switch (style) {
        case GNProgressBarProgressStyleSelect:
        {
            currentProgressView.backgroundColor = BAR_SELECT_COLOR;
        }
            break;
        case GNProgressBarProgressStyleNormal:
        {
            currentProgressView.backgroundColor = BAR_BLUE_COLOR;
        }
            break;
        default:
            break;
    }
}

- (void)setLastProgressViewToStyle:(GNProgressBarProgressStyle)style
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    switch (style) {
        case GNProgressBarProgressStyleDelete:
        {
            lastProgressView.backgroundColor = BAR_RED_COLOR;
            _progressIndicator.hidden = YES;
        }
            break;
        case GNProgressBarProgressStyleNormal:
        {
            lastProgressView.backgroundColor = BAR_BLUE_COLOR;
            _progressIndicator.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)deleteLastProgressView
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [lastProgressView removeFromSuperview];
    [_progressViewArray removeLastObject];
    
    _progressIndicator.hidden = NO;
    
    [self refreshIndicatorPosition];
}

- (void)removeAllProgressView{
    for (UIView * v in self.progressViewArray) {
        [v removeFromSuperview];
    }
    [self.progressViewArray removeAllObjects];
    [self refreshIndicatorPosition];
}

+ (GNProgressBar *)getInstance
{
    GNProgressBar *progressBar = [[GNProgressBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BAR_H)];
    return progressBar;
}
// 外界方法
- (void)setProgressViewAtIndex:(NSInteger)progressViewIndex toWidth:(CGFloat)width {
    // 防止越界
    if (progressViewIndex + 1 > self.progressViewArray.count) {
        return;
    }
    
    UIView *currentProgressView = self.progressViewArray[progressViewIndex];
    CGRect frame = currentProgressView.frame;
    frame.size.width = width - 1;
    currentProgressView.frame = frame;
    
    for (NSInteger i = progressViewIndex + 1; i < self.progressViewArray.count; i++) {
        UIView * foreProgressView = self.progressViewArray[i-1];
        CGRect foreViewFrame = foreProgressView.frame;
        
        UIView *currentProgressView = self.progressViewArray[i];
        CGRect frame = currentProgressView.frame;
        frame.origin.x = foreViewFrame.origin.x+foreViewFrame.size.width+1;
        
        currentProgressView.frame = frame;
    }
    [self refreshIndicatorPosition];
}



#pragma mark - private Method
// 内部方法
- (UIView *)getProgressView
{
    GNProgressView *progressView = [[GNProgressView alloc] initWithFrame:CGRectMake(0, 0, 1, BAR_H)];
    progressView.backgroundColor = BAR_BLUE_COLOR;
    progressView.autoresizesSubviews = YES;
    progressView.hiddenTriangleIndicatorImageView = !_progressViewArray.count;
    
    return progressView;
}

// 刷新光标位置 内部方法... 私有方法
- (void)refreshIndicatorPosition
{
    CGFloat centerY = BAR_H + _progressIndicator.frame.size.height * 0.5;
    
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        _progressIndicator.center = CGPointMake(0, centerY);
        return;
    }
    
    _progressIndicator.center = CGPointMake((lastProgressView.frame.origin.x + lastProgressView.frame.size.width), centerY);
}



// 内部方法....开启定时器
- (void)onTimer:(NSTimer *)timer
{
    [UIView animateWithDuration:TIMER_INTERVAL / 2 animations:^{
        _progressIndicator.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:TIMER_INTERVAL / 2 animations:^{
            _progressIndicator.alpha = 1;
        }];
    }];
}



- (void) setHiddenTriangleIndicatorImageViews:(BOOL)hiddenTriangleIndicatorImageViews{
    
    _hiddenTriangleIndicatorImageViews = hiddenTriangleIndicatorImageViews;
    NSInteger count = self.progressViewArray.count;
    for (NSInteger i = 1; i < count; i++) {
        GNProgressView *progressView = self.progressViewArray[i];
        progressView.hiddenTriangleIndicatorImageView = hiddenTriangleIndicatorImageViews;
    }
}

- (UIImageView *)getProgressIndicator{
    UIImage *image = [UIImage imageNamed:@"SV_Triangleindicator"];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    CGRect imageViewFrame = CGRectMake(0, 0,image.size.width,image.size.height);
    imageView.frame = imageViewFrame;
    return imageView;
}


@end



