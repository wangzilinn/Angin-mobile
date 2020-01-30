# word_front_end

## Views

1. card_list.dart

   显示今日要背的所有卡片的界面

   对于每个条目:

   ​	单击开始背单词, 

   ​	向右划询问是否删除单词

   ​	向左滑查看单词

2. settings.dart

   设置界面

3. card_detail.dart

   单个卡片的显示界面

4. motify.dart

   修改卡片的界面

## Models

卡片数据

显示全部卡片简要信息

储存设置的内容

## Services

从网站获取restful消息的服务

本地储存



# 策略

## 总体

1. 每日第一次运行软件时从服务器下载所有今日到期卡片+新的要背的卡片
2. 对于卡片列表中的每一个卡片:
   1. 如果过期时间在当前时间之前,则根据记忆情况,更新过期时间
   2. 如果过期时间晚于当前时间,早于当日截止日期,则为灰色,不可点击
   3. 如果过期时间超过当日截止日期 , 则消去该卡片
3. 直到主页单词列表为空,则当日任务完成

## 点击列表后的逻辑

1. 点击列表中元素后, 向详情页面传入整个model by调用cardService.getModel(index), 这个函数中存入当前显示的index
2. 点击option按钮后, 更新整个页面 by:调用cardService.next()
3. cardService.next()实现:cardService时刻知道当先显示的卡片的序列号







