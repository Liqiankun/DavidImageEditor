//
//  DavidImageEditorViewController.m
//  DavidImageEditorDemo
//
//  Created by DavidLee on 16/1/20.
//  Copyright © 2016年 DavidLee. All rights reserved.
//

#import "DavidImageEditorViewController.h"
#import "DavidImageEidtorView.h"
#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f
#define ORIGINAL_MAX_WIDTH 640.0f


@interface DavidImageEditorViewController ()

@property(nonatomic,strong) UIButton *cancelButton;
@property(nonatomic,strong) UIButton *confirmBtn;
@property(nonatomic,strong) UIButton *rotateBtn;
@property(nonatomic,strong) DavidImageEidtorView *imageEditorView;
@property(nonatomic,weak) UIView *btnBackView;

@end

@implementation DavidImageEditorViewController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame
{
   return  [self initWithImage:originalImage cropFrame:cropFrame finishCallBack:nil cancelBlock:nil];
}

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame finishCallBack:(DavidImageEditorBlock)finishBlock cancelBlock:(DavidImageEditorBlock)cancelBlock
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f];
        
        self.imageEditorView = [[DavidImageEidtorView alloc] initWithFrame:cropFrame withImage:originalImage];
        
        self.imageEditorView.layer.borderWidth = 1.0;
        self.imageEditorView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        [self.view addSubview:self.imageEditorView];
        
        [self uiConfig];
        
        self.finishBlock = finishBlock;
        self.cancelBlock = cancelBlock;
        
    }
    return self;
}

-(void)uiConfig
{
    
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0,viewHeight - 50.0f, viewWidth, 50)];
    barView.backgroundColor = [UIColor colorWithRed:0.08f green:0.08f blue:0.08f alpha:1.00f];
    [self.view addSubview:barView];
    self.btnBackView = barView;
    
   
    self.cancelButton = [self setupButtonWithTitle:@"取消" andImage:nil andFrame:CGRectMake(0, 0, 50, 50) andAction:@selector(cancel:)];
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:self.cancelButton];
    
    self.confirmBtn = [self setupButtonWithTitle:@"确定" andImage:nil andFrame:CGRectMake(viewWidth - 50, 0, 50, 50) andAction:@selector(confirm:)];
    [barView addSubview:self.confirmBtn];
    
    self.rotateBtn = [self setupButtonWithTitle:nil andImage:[UIImage imageNamed:@"imagePicker_edit_rotate"] andFrame:CGRectMake(10, 10, 50, 50) andAction:@selector(rotateBtnAction:)];
    [self.view addSubview:self.rotateBtn];
    
 
}

-(UIButton*)setupButtonWithTitle:(NSString*)title andImage:(UIImage*)image andFrame:(CGRect)frame andAction:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = frame;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)cancel:(id)sender {
    //代理
    if ([self.delegate respondsToSelector:@selector(imageEditorDidCancel:)]) {
        [self.delegate imageEditorDidCancel:self];
    }
    
    //回调
    if (self.cancelBlock) {
        self.cancelBlock(nil,YES);
    }
}

- (void)confirm:(id)sender {
    
    [self.imageEditorView finishEditing];
    
    //代理
    if ([self.delegate respondsToSelector:@selector(imageEditor:didFinished:)]) {
        [self.delegate imageEditor:self didFinished:self.imageEditorView.croppedImage];
    }
    
    //回调
    if (self.finishBlock) {
        self.finishBlock(self.imageEditorView.croppedImage,NO);
    }
}

-(void)rotateBtnAction:(UIButton*)button
{
    [self.imageEditorView rotateImage];
}

-(void)setImage:(UIImage *)image
{
    [self.rotateBtn setImage:image forState:UIControlStateNormal];
}

-(void)setBackColor:(UIColor *)backColor
{
    self.view.backgroundColor = backColor;
}

-(void)setBtnBackColor:(UIColor *)btnBackColor
{
    self.btnBackView.backgroundColor = btnBackColor;
}

-(void)setClockwise:(BOOL)clockwise
{
    self.imageEditorView.clockwise = clockwise;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
