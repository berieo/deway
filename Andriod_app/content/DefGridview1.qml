import QtQuick 2.0

FocusScope {
    id: root;
    clip: true;
    width: icon_main.width;
    height: icon_main.height;

    signal sendMsg(var imgIndex);

    GridView{
        id: meterGridView1;
        anchors.fill: parent;
        // cell表示单个仪表的尺寸
        cellWidth: width/4;
        cellHeight: height/4.2;
        model: meterGridViewModel.createObject(meterGridView1);
        delegate: meterGridViewDelegate;
        currentIndex: -1;
    }
    // 元素列表
    Component{
        id: meterGridViewModel;
        ListModel{
            id: gridViewModel;
            ListElement{
                imgIndex: "45";
                imgSource: "image(45).png";
            }
            ListElement{
                imgIndex: "46";
                imgSource: "image(46).png";
            }
            ListElement{
                imgIndex: "47";
                imgSource: "image(47).png";
            }
            ListElement{
                imgIndex: "48";
                imgSource: "image(48).png";
            }
            ListElement{
                imgIndex: "49";
                imgSource: "image(49).png";
            }
            ListElement{
                imgIndex: "50";
                imgSource: "image(50).png";
            }
            ListElement{
                imgIndex: "51";
                imgSource: "image(51).png";
            }
            ListElement{
                imgIndex: "52";
                imgSource: "image(52).png";
            }
            ListElement{
                imgIndex: "53";
                imgSource: "image(53).png";
            }
            ListElement{
                imgIndex: "54";
                imgSource: "image(54).png";
            }
            ListElement{
                imgIndex: "55";
                imgSource: "image(55).png";
            }
            ListElement{
                imgIndex: "56";
                imgSource: "image(56).png";
            }
            ListElement{
                imgIndex: "57"
                imgSource: "image(57).png";
            }
            ListElement{
                imgIndex: "58";
                imgSource: "image(58).png";
            }
            ListElement{
                imgIndex: "59";
                imgSource: "image(59).png";
            }
            ListElement{
                imgIndex: "60";
                imgSource: "image(60).png";
            }
            ListElement{
                imgIndex: "61";
                imgSource: "image(61).png";
            }
            ListElement{
                imgIndex: "62";
                imgSource: "image(62).png";
            }
            ListElement{
                imgIndex: "63";
                imgSource: "image(63).png";
            }
            ListElement{
                imgIndex: "64";
                imgSource: "image(64).png";
            }
            ListElement{
                imgIndex: "65";
                imgSource: "image(65).png";
            }
            ListElement{
                imgIndex: "66";
                imgSource: "image(66).png";
            }
            ListElement{
                imgIndex: "67";
                imgSource: "image(67).png";
            }
            ListElement{
                imgIndex: "68";
                imgSource: "image(68).png";
            }
            ListElement{
                imgIndex: "69";
                imgSource: "image(69).png";
            }
            ListElement{
                imgIndex: "70";
                imgSource: "image(70).png";
            }
            ListElement{
                imgIndex: "71";
                imgSource: "image(71).png";
            }
            ListElement{
                imgIndex: "72";
                imgSource: "image(72).png";
            }
            ListElement{
                imgIndex: "73";
                imgSource: "image(73).png";
            }
            ListElement{
                imgIndex: "74";
                imgSource: "image(74).png";
            }
            ListElement{
                imgIndex: "75";
                imgSource: "image(75).png";
            }
            ListElement{
                imgIndex: "76";
                imgSource: "image(76).png";
            }
            ListElement{
                imgIndex: "77"
                imgSource: "image(77).png";
            }
            ListElement{
                imgIndex: "78";
                imgSource: "image(78).png";
            }
            ListElement{
                imgIndex: "79";
                imgSource: "image(79).png";
            }
            ListElement{
                imgIndex: "80";
                imgSource: "image(80).png";
            }
            ListElement{
                imgIndex: "81";
                imgSource: "image(81).png";
            }
            ListElement{
                imgIndex: "82";
                imgSource: "image(82).png";
            }
            ListElement{
                imgIndex: "83";
                imgSource: "image(83).png";
            }
            ListElement{
                imgIndex: "84";
                imgSource: "image(84).png";
            }
            ListElement{
                imgIndex: "85";
                imgSource: "image(85).png";
            }
            ListElement{
                imgIndex: "86";
                imgSource: "image(86).png";
            }
            ListElement{
                imgIndex: "87";
                imgSource: "image(87).png";
            }
        }
    }
    // 组件风格
    Component{
        id: meterGridViewDelegate;
        Item{
            id: meterGridViewItem;
            width: meterGridView1.cellWidth;
            height: meterGridView1.cellHeight;
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
