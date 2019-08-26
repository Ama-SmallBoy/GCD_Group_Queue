//
//  ViewController.m
//  GCD_Group_Queue
//
//  Created by a on 2019/8/26.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建一个线程组：
    dispatch_group_t group = dispatch_group_create();
    //创建一个并发队列：
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.xiaomeng.jun",DISPATCH_QUEUE_CONCURRENT);
    #warning mark-------注意：dispatch_group_enter(group)与dispatch_group_leave(group)应该成对存在。
    //进入线程组中
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据1");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据2");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据3");
        dispatch_group_leave(group);
    });
    
    //统一处理结果：比如：网络请求的数据，统一处理问题，此处队列，视情况而定
    dispatch_group_notify(group, concurrentQueue, ^{
        NSLog(@"====数据统一处理");
    });
}


@end
