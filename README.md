#THLinkageTable_MultiLevel
##多级联动选择省市表视图,实现了一个可以按照树形层级关系无限向下读取信息的model,并可以向UIView那样按照继承链从下向上或从上向下查找节点

##多级模型的组织结构
####THAddressViewModel 
- 负责从plist文件中加载并解析出address模型,并构建树形数据结构(其中节点填充的都是THAddressModel)
- 维护一个记载了所有被选择省市模型的数组
####THAddressModel
- 记载省市名称及以及用户拼音简写搜索的拼音简写名称
- 提供一个标记当前模型是否被选择标识位
- 具有指向父模型的指针以及维护一个保存子模型的数组
- 提供两个实例方法,分别可以从本节点向上或向下遍历,并提供一个block传入接口,让外界可以在遍历过程中对每个符合条件的节点进行操作

##显示模块
####显示模块用tableview来做, 实现多级下拉效果,具体思路就是非叶子节点用sectionHeaderView展示,点击sectionHeaderView取出本section的子节点数据, 用一个新的tableview加载子节点数组,叶子节点的model用cell展示

##只要按照address.plist文件的的层级格式命名 , 可以无限写下去, THAddressViewModel会自动加载并建立准确的对应的树形层级结构供tableview展示

##具体使用方法
在控制器中引入两个头文件
import "THAddressViewModel.h"
import "THLinkageTableBasicView.h"

添加THLinkageTableBasicView为子视图
```objectivec
- (void)addAddressTab
{
THLinkageTableBasicView *addressTab = [[THLinkageTableBasicView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 )];
[addressTab changeModel:YES];
addressTab.shouldShowSearchBar = YES ;
_addressTab = addressTab ;

[self.view addSubview:addressTab];

}
```
在address.plist文件中按原来格式及key值填写自己想要展示的信息

注册一个改变选择模型的通知 , 可以在这个通知回调中做刷新UI的操作
```objectivec
__weak typeof(self) weakSelf = self ;
_observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"changeText" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
weakSelf.titleLbl.text = note.object ;
}];
```

本项目还只是一个demo 没有做完善的封装, 接口不友好, 需改善的地方较多,只做技术交流使用