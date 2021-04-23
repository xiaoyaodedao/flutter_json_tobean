import 'package:first_flutter/beans/bean.dart';
import 'package:flutter/material.dart';

class HomeListItem extends StatelessWidget {

  final HomeItemDatas _itemData;

  const HomeListItem(this._itemData);

  @override
  Widget build(BuildContext context) {
    ///时间与作者
    Row author = Row(
      children: [
        //expanded 相当于 LinearLayout的weight权重
        Expanded(child: Text.rich(TextSpan(
            children: [
              TextSpan(text: "作者: "),
              TextSpan(
                  text: _itemData.author,
                  style: TextStyle(color: Theme
                      .of(context)
                      .primaryColor)
              )
            ]
        )))
      ],
    );

    ///标题
    Text title = Text(
        _itemData.title, style: TextStyle(fontSize: 16, color: Colors.black),
        textAlign: TextAlign.left
    );

    ///章节名
    Text chapterName = Text(_itemData.chapterName,
    style: TextStyle(color: Theme.of(context).primaryColor),);

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,//子控件左对齐
      children: [
        Padding(padding: EdgeInsets.all(10),
        child: author,),
        Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: title,),
        Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: chapterName,)
      ],
    );

    return Card(
      elevation: 4,
      child: column,
    );
  }
}
