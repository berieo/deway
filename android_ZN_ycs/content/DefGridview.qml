import QtQuick 2.0

FocusScope {
    id: root;
    clip: true;
    width: icon_main.width;
    height: icon_main.height;

    signal sendMsg(var imgIndex);

    GridView{
        id: meterGridView;
        anchors.fill: parent;
        // cell表示单个仪表的尺寸
        cellWidth: width/4;
        cellHeight: height/4.2;
        model: meterGridViewModel.createObject(meterGridView);
        delegate: meterGridViewDelegate;
        currentIndex: -1;
    }
    // 元素列表
    Component{
        id: meterGridViewModel;
        ListModel{
            id: gridViewModel;
            ListElement{
                imgIndex: "1";
                imgSource: "image(1).png";
            }
            ListElement{
                imgIndex: "2";
                imgSource: "image(2).png";
            }
            ListElement{
                imgIndex: "3";
                imgSource: "image(3).png";
            }
            ListElement{
                imgIndex: "4";
                imgSource: "image(4).png";
            }
            ListElement{
                imgIndex: "5";
                imgSource: "image(5).png";
            }
            ListElement{
                imgIndex: "6";
                imgSource: "image(6).png";
            }
            ListElement{
                imgIndex: "7";
                imgSource: "image(7).png";
            }
            ListElement{
                imgIndex: "8";
                imgSource: "image(8).png";
            }
            ListElement{
                imgIndex: "9";
                imgSource: "image(9).png";
            }
            ListElement{
                imgIndex: "10";
                imgSource: "image(10).png";
            }
            ListElement{
                imgIndex: "11";
                imgSource: "image(11).png";
            }
            ListElement{
                imgIndex: "12";
                imgSource: "image(12).png";
            }
            ListElement{
                imgIndex: "13";
                imgSource: "image(13).png";
            }
            ListElement{
                imgIndex: "14";
                imgSource: "image(14).png";
            }
            ListElement{
                imgIndex: "15";
                imgSource: "image(15).png";
            }
            ListElement{
                imgIndex: "16";
                imgSource: "image(16).png";
            }
            ListElement{
                imgIndex: "17";
                imgSource: "image(17).png";
            }
            ListElement{
                imgIndex: "18";
                imgSource: "image(18).png";
            }
            ListElement{
                imgIndex: "19";
                imgSource: "image(19).png";
            }
            ListElement{
                imgIndex: "20";
                imgSource: "image(20).png";
            }
            ListElement{
                imgIndex: "21";
                imgSource: "image(21).png";
            }
            ListElement{
                imgIndex: "22";
                imgSource: "image(22).png";
            }
            ListElement{
                imgIndex: "23";
                imgSource: "image(23).png";
            }
            ListElement{
                imgIndex: "24";
                imgSource: "image(24).png";
            }
            ListElement{
                imgIndex: "25";
                imgSource: "image(25).png";
            }
            ListElement{
                imgIndex: "26";
                imgSource: "image(26).png";
            }
            ListElement{
                imgIndex: "27";
                imgSource: "image(27).png";
            }
            ListElement{
                imgIndex: "28";
                imgSource: "image(28).png";
            }
            ListElement{
                imgIndex: "29";
                imgSource: "image(29).png";
            }
            ListElement{
                imgIndex: "30";
                imgSource: "image(30).png";
            }
            ListElement{
                imgIndex: "31";
                imgSource: "image(31).png";
            }
            ListElement{
                imgIndex: "32";
                imgSource: "image(32).png";
            }
            ListElement{
                imgIndex: "33";
                imgSource: "image(33).png";
            }
            ListElement{
                imgIndex: "34";
                imgSource: "image(34).png";
            }
            ListElement{
                imgIndex: "35";
                imgSource: "image(35).png";
            }
            ListElement{
                imgIndex: "36";
                imgSource: "image(36).png";
            }
            ListElement{
                imgIndex: "37";
                imgSource: "image(37).png";
            }
            ListElement{
                imgIndex: "38";
                imgSource: "image(38).png";
            }
            ListElement{
                imgIndex: "39";
                imgSource: "image(39).png";
            }
            ListElement{
                imgIndex: "40";
                imgSource: "image(40).png";
            }
            ListElement{
                imgIndex: "41";
                imgSource: "image(41).png";
            }
            ListElement{
                imgIndex: "42";
                imgSource: "image(42).png";
            }
            ListElement{
                imgIndex: "43";
                imgSource: "image(43).png";
            }
            ListElement{
                imgIndex: "44";
                imgSource: "image(44).png";
            }
        }
    }
    // 组件风格
    Component{
        id: meterGridViewDelegate;
        Item {
            id: meterGridViewItem;
            width: meterGridView.cellWidth;
            height: meterGridView.cellHeight;
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
