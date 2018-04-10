//
//  ViewController.m
//  SqlTest
//
//  Created by mac on 2018/4/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"

#import "SqlManager.h"

@interface ViewController ()
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *age;

@property (nonatomic,assign)NSString *icon;

//@property (nonatomic,assign)NSString *name;



@end

//static sqlite3 *_db=nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self insertSelfToDB];
    
    [self updateIcon];
    
//    [self allUserFromDB];
    
    
    
    [[SqlManager shareInstance] fetch];

}

-(BOOL)insertSelfToDB{
    //插入对象的SQL语句
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO 't_User' (name,age,icon) VALUES ('%@',%@,'%@');",self.name,self.age,self.icon];
    return [[SqlManager shareInstance] execSQL:insertSQL];
}

-(void)updateIcon{
    //更新对应的SQL语句
    NSString *SQL = [NSString stringWithFormat:@"UPDATE 't_User' SET icon='%@' WHERE name = '%@'",@"http://qiuxuewei.com/newIcon.png",@"name_6"];
    if ([[SqlManager shareInstance] execSQL:SQL]) {
        NSLog(@"对应数据修改成功");
    }
}

-(NSArray *)allUserFromDB{
    //查询表中所有数据的SQL语句
    NSString *SQL = @"SELECT name,age,icon FROM 't_User'";
    //取出数据库用户表中所有数据
    NSArray *allUserDictArr = [[SqlManager shareInstance] querySQL:SQL];
    NSLog(@"%@",allUserDictArr);
    //将字典数组转化为模型数组
//    NSMutableArray *modelArrM = [[NSMutableArray alloc] init];
//    for (NSDictionary *dict in allUserDictArr) {
//        [modelArrM addObject:[[User alloc] initWithDict:dict]];
//    }
    return allUserDictArr;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
