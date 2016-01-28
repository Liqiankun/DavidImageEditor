//
//  DavidImageEditorViewController.h
//  DavidImageEditorDemo
//
//  Created by DavidLee on 16/1/20.
//  Copyright © 2016年 DavidLee. All rights reserved.
//

#import <UIKit/UIKit.h>



@class DavidImageEditorViewController;

@protocol DavidImageEditorViewControllerDelegate <NSObject>
/**
 *  图片编辑完成点击确定按钮调用
 *
 *  @param editedImage               编辑完成后的图片
 */
- (void)imageEditor:(DavidImageEditorViewController *)imageEditorViewController didFinished:(UIImage *)editedImage;
/**
 *  放弃编辑点击取消按纽是调用
 */
- (void)imageEditorDidCancel:(DavidImageEditorViewController *)imageEditorViewController;

@end

typedef void(^DavidImageEditorBlock)(UIImage *image, BOOL canceled);

@interface DavidImageEditorViewController : UIViewController

@property(nonatomic,assign) id<DavidImageEditorViewControllerDelegate> delegate;
/** 完成编辑的Block */
@property(nonatomic,copy) DavidImageEditorBlock finishBlock;
/** 取消编辑的Block */
@property(nonatomic,copy) DavidImageEditorBlock cancelBlock;
/** 旋转按钮的图片 */
@property(nonatomic,strong)UIImage *image;
/** 背景颜色 */
@property(nonatomic,strong) UIColor *backColor;
/** 按钮背景颜色 */
@property(nonatomic,strong) UIColor *btnBackColor;
/** 是否顺时针旋转图片 */
@property(nonatomic,assign) BOOL clockwise;
/**
 *  图片编辑初始化方法
 *
 *  @param originalImage 要编辑的图片
 *  @param cropFrame     编辑框的大小和位置
 */
- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame;

/**
 * 图片编辑初始化方法
 *
 *  @param originalImage 要编辑的图片
 *  @param cropFrame     编辑框的大小和位置
 *  @param finishBlock   图片编辑完成之后Block
 *  @param cancelBlock   放弃编辑的Block
 */
- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame finishCallBack:(DavidImageEditorBlock)finishBlock cancelBlock:(DavidImageEditorBlock)cancelBlock;

@end
