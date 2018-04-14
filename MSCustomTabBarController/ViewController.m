//
//  ViewController.m
//  MSCustomTabBarController
//
//  Created by Jep Xia on 2018/4/14.
//  Copyright © 2018年 MrSong. All rights reserved.
//

#import "ViewController.h"
#import "MyKVO.h"

@interface ViewController ()
@property (nonatomic,retain) MyKVO *myKVO;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myKVO = [[MyKVO alloc] init];
    [self.myKVO addObserver:self forKeyPath:@"num" options:NSKeyValueObservingOptionOld |NSKeyValueObservingOptionNew context:nil];
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.label = [[UILabel alloc ] initWithFrame:CGRectMake(width/2, height/2, width, 20)];
    [self.label setText:@"label"];
    [self.view addSubview:self.label];
    
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(width/2, height/2 + 40, 100, 20)];


    [self.button setTitle:@"button" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];

}
/* 2.只要object的keyPath属性发生变化，就会调用此回调方法，进行相应的处理：UI更新：*/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    
    // 判断是否为self.myKVO的属性“num”:
    if([keyPath isEqualToString:@"num"] && object == self.myKVO) {
        // 响应变化处理：UI更新（label文本改变）
        self.label.text = [NSString stringWithFormat:@"当前的num值为：%@",
                           [change valueForKey:@"new"]];
        
        //change的使用：上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
        NSLog(@"\\noldnum:%@ newnum:%@",[change valueForKey:@"old"],
              [change valueForKey:@"new"]);
    }
}

/*KVO以及通知的注销，一般是在-(void)dealloc中编写。
 至于很多小伙伴问为什么要在didReceiveMemoryWarning？因为这个例子是在书本上看到的，所以试着使用它的例子。
 但小编还是推荐把注销行为放在-(void)dealloc中。(严肃脸😳)
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    /* 3.移除KVO */
    [self.myKVO removeObserver:self forKeyPath:@"num" context:nil];
}

//按钮事件
- (void)changeNum:(UIButton *)sender {
    //按一次，使num的值+1
    self.myKVO.num = self.myKVO.num + 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
