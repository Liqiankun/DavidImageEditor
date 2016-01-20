//
//  DavidImageEidtorView.h
//  DavidImageEditorDemo
//
//  Created by DavidLee on 16/1/20.
//  Copyright © 2016年 DavidLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DavidImageEidtorView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *croppedImage;


/** 初始化方法 */
-(instancetype)initWithFrame:(CGRect)frame withImage:(UIImage*)image;
/** 完成编辑 */
- (void)finishEditing;
/** 旋转图片 */
-(void)rotateImage;

@end
