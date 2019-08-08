import QtQuick 2.0

FocusScope {
    id: root;
    clip: true;
    width: icon_main.width;
    height: icon_main.height;

    signal sendMsg(var imgIndex);

    GridView{
        id: meterGridView2;
        anchors.fill: parent;
        // cell表示单个仪表的尺寸
        cellWidth: width/4;
        cellHeight: height/4.2;
        model: meterGridViewModel.createObject(meterGridView2);
        delegate: meterGridViewDelegate;
        currentIndex: -1;
    }
    // 元素列表
    Component{
        id: meterGridViewModel;
        ListModel{
            id: gridViewModel;
            ListElement{
                imgIndex: "88";
                imgSource: "image(88).png";
            }
            ListElement{
                imgIndex: "89";
                imgSource: "image(89).png";
            }
            ListElement{
                imgIndex: "90";
                imgSource: "image(90).png";
            }
            ListElement{
                imgIndex: "91";
                imgSource: "image(91).png";
            }
            ListElement{
                imgIndex: "92";
                imgSource: "image(92).png";
            }
            ListElement{
                imgIndex: "93";
                imgSource: "image(93).png";
            }
            ListElement{
                imgIndex: "94";
                imgSource: "image(94).png";
            }
            ListElement{
                imgIndex: "95";
                imgSource: "image(95).png";
            }
            ListElement{
                imgIndex: "96";
                imgSource: "image(96).png";
            }
            ListElement{
                imgIndex: "97"
                imgSource: "image(97).png";
            }
            ListElement{
                imgIndex: "98";
                imgSource: "image(98).png";
            }
            ListElement{
                imgIndex: "99";
                imgSource: "image(99).png";
            }
            ListElement{
                imgIndex: "100";
                imgSource: "image(100).png";
            }
        }
    }
    // 组件风格
    Component{
        id: meterGridViewDelegate;
        Item{
            id: meterGridViewItem;
            width: meterGridView2.cellWidth;
            height: meterGridView2.cellHeight;
            Image {
                id: meterLayout;
                width: meterGridViewItem.width/1.5;
                height: meterGridViewItem.width/1.5;
                anchors.left: parent.left;
                anchors.leftMargin: 20/screenRate;
                source: imgSource;
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        root.sendMsg(imgIndex);
                    }
                }

                // index
                Text{
                    text: imgIndex;
                    height: Text.Wrap;
                    anchors.top: parent.bottom;
                    anchors.topMargin: 1/screenRate;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    font.pointSize: 15;
                }
            }
        }
    }
}
