//
//  CustomActionSheet.h
//  wash
//
//  Created by weixikeji on 15/5/11.
//
//

#import <UIKit/UIKit.h>

@class CustomActionSheet;

@protocol CustomActionSheetDelegate <NSObject>

@optional

/**
 *  点击按钮
 */
- (void)actionSheet:(CustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomActionSheet : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id <CustomActionSheetDelegate> delegate;

/**
 *  创建对象方法
 */
- (instancetype)initWithDelegate:(id<CustomActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle ButtonCount:(int)count OtherTitles:(NSString *)otherTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@end
