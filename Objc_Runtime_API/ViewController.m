//
//  ViewController.m
//  Objc_Runtime_API
//
//  Created by 张昭 on 16/5/16.
//  Copyright © 2016年 张昭. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Working with Classes
    // 1、 获取类名
    // const char * class_getName(Class cls)
    NSLog(@"本类：%s", class_getName(NSClassFromString(@"ViewController")));
    // 本类：ViewController
    
    // 2、 获取父类
    // Class class_getSuperclass(Class cls)
    NSLog(@"父类：%@", class_getSuperclass(NSClassFromString(@"ViewController")));
    // 父类：UIViewController
    
    // 3、 设置父类
    // Class class_setSuperclass(Class cls, Class newSuper)
    // You should not use this function.
    
    // 4、 判断元类
    // BOOL class_isMetaClass(Class cls)
    NSLog(@"元类：%d", class_isMetaClass(NSClassFromString(@"NSObject")));
    // 元类：0
    
    // 5、 实例大小
    // size_t class_getInstanceSize(Class cls)
    NSLog(@"大小：%ld", class_getInstanceSize(NSClassFromString(@"NSString")));
    // 大小：8
    
    // 6、 成员变量
    // Ivar class_getInstanceVariable(Class cls, const char* name)
    NSLog(@"地址：%p", class_getInstanceVariable([Person class], "name"));
    // 地址：0x10ce45e30
    
    // 7、 类变量(不解，带指导)
    // Ivar class_getClassVariable(Class cls, const char* name)
    NSLog(@"%p", class_getClassVariable([Person class], "age"));
    
    // 8、 创建类，添加属性、方法
    // objc_allocateClassPair
    // class_addIvar
    // objc_registerClassPair
    [self createClass];
    
    // 8、 类的所有变量（成员变量和属性）
    // Ivar * class_copyIvarList(Class cls, unsigned int *outCount)
    unsigned int count = 0;
    Ivar *copyIvar = class_copyIvarList([Person class], &count);
    for (int i = 0; i < count; i++) {
        NSLog(@"变量名：%@", [NSString stringWithUTF8String:ivar_getName(copyIvar[i])]);
    }
    
    // 9、 Ivar layout
    // const char *class_getIvarLayout(Class cls)
    // void class_setIvarLayout(Class cls, const char *layout)
    // const char *class_getWeakIvarLayout(Class cls)
    // void class_setWeakIvarLayout(Class cls, const char *layout)
    
    NSLog(@"%s", class_getIvarLayout([NSObject class]));
    
    // 10、 class_addIvar
    // BOOL class_addIvar(Class cls, const char *name, size_t size, uint8_t alignment, const char *types)
    
    // 11、 objc_property_t
    // objc_property_t class_getProperty(Class cls, const char *name)
    NSLog(@"属性地址：%p", class_getProperty([Person class], "age"));
    
    // 12、 类的属性列表
    // objc_property_t * class_copyPropertyList(Class cls, unsigned int *outCount)
    NSLog(@"属性列表：%p", class_copyPropertyList([Person class], &count));
    NSArray *arr = @[@"23", @"33", @"99"];
    char *buf1 = @encode(void);     // buf1 = V
    char *buf2 = @encode(float);    // buf2 = f
    char *buf3 = @encode(NSArray);  // buf3 = {NSArray=#}
    NSLog(@"%s", buf3);
}

- (void)createClass {
    // http://blog.sunnyxx.com/2015/09/13/class-ivar-layout/
    // 1、创建一个新类和元类
    Class MyClass = objc_allocateClassPair([NSObject class], "myclass", 0);
    // 2.1 添加成员变量
    // class_addIvar必须放在objc_allocateClassPair之后，且objc_registerClassPair之前。而且不能用在对元类的操作上；对任意指针类型使用log2(sizeof(pointer_type))。
    class_addIvar(MyClass, "_gayFriend", sizeof(id), log2(sizeof(id)), @encode(id));
    // 2.2 为新类添加方法
    // class_addMethod: 添加了一个覆盖父类的实现，但不会取代该类中已有的实现；如果要改变当前的实现，可以使用method_setImplementation。
    class_addMethod(MyClass, @selector(myclasstest:), (IMP)myclasstest, "v@:");
    // 3、注册新类
    objc_registerClassPair(MyClass);
    
    id myobj = [[MyClass alloc] init];
    NSString *str = @"zhangsan";
    [myobj setValue:str forKey:@"_gayFriend"];
    [myobj myclasstest:10];
}

//这个方法实际上没有被调用,但是必须实现否则不会调用下面的方法
- (void)myclasstest:(int)a
{
    NSLog(@"这个方法实际上没有被调用");
}
//调用的是这个方法
static void myclasstest(id self, SEL _cmd, int a) //self和_cmd是必须的，在之后可以随意添加其他参数
{
    
    Ivar v = class_getInstanceVariable([self class], "_gayFriend");
    //返回名为itest的ivar的变量的值
    id o = object_getIvar(self, v);
    //成功打印出结果
    NSLog(@"_gayFriend:   %@", o);
    NSLog(@"参数：     %d", a);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
