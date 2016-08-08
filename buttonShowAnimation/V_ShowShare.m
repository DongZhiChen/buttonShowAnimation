//
//  V_ShowShare.m
//  buttonShowAnimation
//
//  Created by 陈东芝 on 16/8/6.
//  Copyright © 2016年 ChenDongZhi. All rights reserved.
//

#import "V_ShowShare.h"

#define V_BTN_BG_H  300
#define BTN_W_H  80

#define verticalitySpeace 20
#define  horizontalSpeace  ([UIScreen mainScreen].bounds.size.width -  (BTN_W_H * BTN_Row_Count)) / (BTN_Row_Count+1)

#define BTN_Top  20
#define BTN_Row_Count 4

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define showAnimationID @"showAnimation"
#define hiddenAnimationID @"hiddenAnimation"
#define hiddenLastAnimationID @"hiddenLastAnimation"


@implementation V_ShowShare

-(id)init{


    if(self = [super init]){
    
        self.frame = [UIScreen mainScreen].bounds;
        self.arrayBtns = [NSMutableArray new];
        
        [self createView];

    }
    
    
    return self;
}




-(void)createView{

    
    self.viewButtonBG = [[UIView alloc] initWithFrame:CGRectMake(0,self.bounds.size.height  , self.bounds.size.width, V_BTN_BG_H)];
    self.viewButtonBG.layer.masksToBounds = YES;
    [self addSubview:self.viewButtonBG];
    
    ///模糊图层
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.viewButtonBG.bounds;
    effectView.layer.opacity = 1;
    [self.viewButtonBG addSubview:effectView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TGRHiddenShareView:)];
    [self addGestureRecognizer:tap];
    
}



-(void)createButtonWithButtonImages:(NSArray *)arrayImage{

    for(int i = 0; i < arrayImage.count; i++){
    
        UIButton *BTN_Share = [UIButton buttonWithType:UIButtonTypeCustom];
        
        float x = (horizontalSpeace + BTN_W_H) * (i % BTN_Row_Count) + horizontalSpeace;
        float y = (BTN_W_H + verticalitySpeace)  *( i /BTN_Row_Count)  + verticalitySpeace + V_BTN_BG_H +BTN_Top;
        
        BTN_Share.frame =  CGRectMake(x, y, BTN_W_H, BTN_W_H);

        [BTN_Share setImage:[UIImage imageNamed:arrayImage[i]] forState:0];
        
        BTN_Share.layer.cornerRadius = BTN_W_H/2.0;
     
        [BTN_Share addTarget:self action:@selector(BTN_Share:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.viewButtonBG addSubview:BTN_Share];
        
        [self.arrayBtns addObject:BTN_Share];
        
    }
    
}

#pragma mark - UIGestureRecognizer -

-(void)TGRHiddenShareView:(UIGestureRecognizer *)GR{
    
    self.isClickButtonHidden = NO;
    [self hiddenShareButtonAnimation];
    
}

#pragma mark - 显示按钮动画 -

-(void)showShareButtonAnimation{
    
    for(int i = 0; i < self.arrayBtns.count; i++){
        
        UIButton *btn = (UIButton *) self.arrayBtns[i];
        ///显示btn延迟时间
        float begainTime = [btn.layer convertTime:CACurrentMediaTime() fromLayer:nil] +  i*0.1-i/BTN_Row_Count*0.3;
        CGPoint point = btn.layer.position;
        
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
        spring.delegate =  self;
        spring.mass = 1;
        spring.damping =7;
        spring.stiffness = 45;
        spring.initialVelocity = 0;
        spring.fromValue = @(point.y);
        spring.toValue = @(point.y - V_BTN_BG_H);
        spring.beginTime =  begainTime;
        spring.duration = 1.5;
        [spring setValue:[NSNumber numberWithInt:i] forKey:showAnimationID];
        [btn.layer addAnimation:spring forKey:nil];
        
    }
}

-(void)hiddenShareButtonAnimation{
    
    for(int i = 0; i < self.arrayBtns.count; i++){
        
        UIButton *btn = (UIButton *) self.arrayBtns[i];
        ///显示btn延迟时间
        float begainTime = [btn.layer convertTime:CACurrentMediaTime() fromLayer:nil] +  i*0.1-i/BTN_Row_Count*0.3;
        CGPoint point = btn.layer.position;
        
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
        spring.delegate =  self;
        spring.mass = 1;
        spring.damping =7;
        spring.stiffness = 45;
        spring.initialVelocity = 0;
        spring.fromValue = @(point.y);
        spring.toValue = @(point.y + V_BTN_BG_H);
        spring.beginTime =  begainTime;
        spring.duration =0.3;
        if(i == self.arrayBtns.count - 1){
            [spring setValue:[NSNumber numberWithInt:i] forKey:hiddenLastAnimationID];

        
        }else{
            [spring setValue:[NSNumber numberWithInt:i] forKey:hiddenAnimationID];

        }
        [btn.layer addAnimation:spring forKey:nil];
        
    }
}


#pragma mark  - CAAnimationDelegate -

-(void)animationDidStart:(CAAnimation *)anim{

    if([anim valueForKey:showAnimationID]){
    
        NSInteger index = [[anim valueForKey:showAnimationID] integerValue];
        
       UIView *view = self.arrayBtns [index];
        CGRect frame =  view.layer.frame;
        
        frame.origin.y -= V_BTN_BG_H;
        view.layer.frame = frame;
        
        
    }else if([anim valueForKey:hiddenAnimationID] || [anim valueForKey:hiddenLastAnimationID]  ){
    
        
        id IDValue = [anim valueForKey:hiddenAnimationID] ? [anim valueForKey:hiddenAnimationID] :[anim valueForKey:hiddenLastAnimationID];
        
        NSInteger index = [IDValue integerValue];
        
        UIView *view = self.arrayBtns [index];
        CGRect frame = view.layer.frame;
        frame.origin.y += V_BTN_BG_H;
        
        view.layer.frame = frame;
        
    }
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if(flag){
    
        if([anim valueForKey:hiddenLastAnimationID]){
            
            if(self.isClickButtonHidden){
            
                [self hiddenShareViewWithBlock:self.shareBlock];
                
            }else{
            
                [self hiddenShareViewWithBlock:nil];
                
            }
            
          
        }
    }
    
}


#pragma mark - 显示隐藏 -

-(void)showShareView{
    
   
    CGRect frame = self.viewButtonBG.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - V_BTN_BG_H;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.viewButtonBG.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self showShareButtonAnimation];
        
    }];
    
}


-(void)hiddenShareViewWithBlock:(void (^)() )shareBlock{

    
    CGRect frame = self.viewButtonBG.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height ;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.viewButtonBG.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        if(shareBlock){
            
        shareBlock();
            
        }
    }];
}


#pragma mark - UIButtonEventClick - 

-(void)BTN_Share:(UIButton *)sender{

    self.isClickButtonHidden =YES;
    
    [self hiddenShareButtonAnimation];
   
    
}

@end
