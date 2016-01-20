//
//  CustomActionSheet.m
//  wash
//
//  Created by weixikeji on 15/5/11.
//
//

#import "CustomActionSheet.h"

// 每个按钮的高度
#define BtnHeight 46
// 取消按钮上面的间隔高度
#define Margin 8

#define CustomColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
// 背景色
#define GlobelBgColor [UIColor clearColor]
// 分割线颜色
#define GlobelSeparatorColor CustomColor(226, 226, 226)
// 普通状态下的图片
#define normalImage [self createImageWithColor:CustomColor(255, 255, 255)]
// 高亮状态下的图片
#define highImage [self createImageWithColor:CustomColor(242, 242, 242)]

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
// 字体
#define HeitiLight(f) [UIFont fontWithName:@"STHeitiSC-Light" size:f]

@interface CustomActionSheet ()
{
    int _tag;
    int _count;
}

@property (nonatomic, weak) CustomActionSheet *actionSheet;
@property (nonatomic, weak) UIView *sheetView;

@end

@implementation CustomActionSheet

- (instancetype)initWithDelegate:(id<CustomActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle ButtonCount:(int)count OtherTitles:(NSString *)otherTitles, ...
{
    CustomActionSheet *actionSheet = [self init];
    self.actionSheet = actionSheet;
    _count = count;
    actionSheet.delegate = delegate;
    
    // 黑色遮盖
    actionSheet.frame = [UIScreen mainScreen].bounds;
    actionSheet.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
    actionSheet.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverClick)];
    [actionSheet addGestureRecognizer:tap];
    
    // sheet
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    sheetView.backgroundColor = GlobelBgColor;
    sheetView.alpha = 0.9;
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    sheetView.hidden = YES;
    
    _tag = 1;
    
    NSString* curStr;
    va_list list;

    if(otherTitles)
    {
        [self setupBtnWithTitle:otherTitles];
        
        va_start(list, otherTitles);
        while ((curStr = va_arg(list, NSString*))) {
            [self setupBtnWithTitle:curStr];
            
        }
        va_end(list);
    }
    
    CGRect sheetViewF = sheetView.frame;
    sheetViewF.size.height = BtnHeight * _tag + Margin;
    sheetView.frame = sheetViewF;
    
    // 取消按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, sheetView.frame.size.height - BtnHeight - 5, ScreenWidth - 20, BtnHeight)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setTitle:cancelTitle forState:UIControlStateNormal];
    btn.titleLabel.font = HeitiLight(17);
    btn.tag = 0;
    [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btn.bounds;
    maskLayer.path = maskPath.CGPath;
    btn.layer.mask = maskLayer;
    
    [self.sheetView addSubview:btn];
    
    return actionSheet;
}

- (void)show{
    self.sheetView.hidden = NO;

    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = ScreenHeight;
    self.sheetView.frame = sheetViewF;
    
    CGRect newSheetViewF = self.sheetView.frame;
    newSheetViewF.origin.y = ScreenHeight - self.sheetView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{

        self.sheetView.frame = newSheetViewF;
        
        self.actionSheet.alpha = 0.3;
    }];
}

- (void)setupBtnWithTitle:(NSString *)title{
    // 创建按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, BtnHeight * (_tag - 1)-5 , ScreenWidth -20, BtnHeight)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = HeitiLight(17);
    btn.tag = _tag;
    [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:btn];
    
    if (_count == 1) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = btn.bounds;
        maskLayer.path = maskPath.CGPath;
        btn.layer.mask = maskLayer;
    }else {
        if (_tag == 1) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = btn.bounds;
            maskLayer.path = maskPath.CGPath;
            btn.layer.mask = maskLayer;
        }else if (_tag == _count) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = btn.bounds;
            maskLayer.path = maskPath.CGPath;
            btn.layer.mask = maskLayer;
        }
    }
    
    // 最上面画分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    line.backgroundColor = GlobelSeparatorColor;
    [btn addSubview:line];
    
    _tag ++;
}

- (void)coverClick{
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = ScreenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sheetView.frame = sheetViewF;
        self.actionSheet.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.actionSheet removeFromSuperview];
        [self.sheetView removeFromSuperview];
    }];
}

- (void)sheetBtnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        [self coverClick];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self.actionSheet clickedButtonAtIndex:btn.tag];
        [self coverClick];
    }
}

- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
