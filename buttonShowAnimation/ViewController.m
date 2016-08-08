//
//  ViewController.m
//  buttonShowAnimation
//
//  Created by 陈东芝 on 16/8/6.
//  Copyright © 2016年 ChenDongZhi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){

    V_ShowShare *share;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BTN_Show:(id)sender {
    
    if( !share ){
    
        share = [[V_ShowShare alloc ] init];
        share.shareBlock = ^(){
            
            NSLog(@"share");
            
        };
        
        [share createButtonWithButtonImages:@[@"1",@"2",@"3",@"4",@"5",@"6"]];
        
    }
   
    [self.view addSubview:share];
    
    [share showShareView];
    
}
@end
