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

- (void)imageEditor:(DavidImageEditorViewController *)imageEditorViewController didFinished:(UIImage *)editedImage;
- (void)imageEditorDidCancel:(DavidImageEditorViewController *)imageEditorViewController;

@end



typedef void(^DavidImageEditorBlock)(UIImage *image, BOOL canceled);

@interface DavidImageEditorViewController : UIViewController

@property(nonatomic,assign) id<DavidImageEditorViewControllerDelegate> delegate;
@property(nonatomic,copy) DavidImageEditorBlock finishBlock;
@property(nonatomic,copy) DavidImageEditorBlock cancelBlock;


- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame;
- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame finishCallBack:(DavidImageEditorBlock)finishBlock cancelBlock:(DavidImageEditorBlock)cancelBlock;

@end
