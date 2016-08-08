//
//  V_ShowShare.h
//  buttonShowAnimation
//
//  Created by 陈东芝 on 16/8/6.
//  Copyright © 2016年 ChenDongZhi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface V_ShowShare : UIView 

@property (nonatomic,copy) void(^shareBlock)();
///是否点击按钮
@property (nonatomic,assign) BOOL isClickButtonHidden;

@property (nonatomic, strong) UIView *viewButtonBG;

@property (nonatomic,strong) NSMutableArray *arrayBtns;

-(void)createButtonWithButtonImages:(NSArray *)arrayImage;

-(void)showShareView;

@end
