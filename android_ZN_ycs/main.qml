import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
//import QtQuick.Controls.Styles 1.3
//import QtQuick.Dialogs 1.3
//import dw.NTCIP  1.0
//import QtQuick.Layouts 1.1
//import QtGraphicalEffects 1.0
import "content"
import QtCharts 2.0
import dw.TcpClient 1.0

Window {
    id: win
    visible: true
    //width: Screen.desktopAvailableWidth;
    //height: Screen.desktopAvailableHeight;
    width: 360
    height: 640

    property var stsColorArr: ["#A9A9A9", "#FFC125", "#EEEE00", "#43CD80", "#EE3B3B"]    // 对应设备的离线、待机、怠速、运行、报警5个状态

    property int indexPage: 0;    // 故障代码生成器的页面状态值，确定当前所在的页面
    property int mcPage: 0;
    property string tabSel: "content/tab_selected.png"
    property string tabSeless: "content/tab.png"

    //开机比
    property var rate1: 1
    property var rate2: 2

    //设备状态图
    property int value1: 4     //运行
    property int value2: 2   //待机
    property int value3: 3   //怠速
    property int value4: 2   //离线
    property int value5: 1   //报警

    // 屏幕适配标志位
    property real screenRate: (1080/win.width).toFixed(3);
    property var faultPageSts: 0
    property bool flag: false;

    //TCP连接
    property string target_ip: "127.0.0.1"
    property int target_port: 8080


    Timer {
        interval: 500;
        running: true;
        repeat: true;
        onTriggered: time.text = Qt.formatDateTime(new Date(), "yyyy年MM月dd日 hh:mm dddd")
        // 星期 年份 月份 号 大月份
    }
    property string date1: "2019-07-01"
    property string date2: Qt.formatDateTime(new Date(),"yyyy-MM-dd")
    property int idays : 0
    //    Timer{
    //        id : diffday;
    //        repeat:false;
    //        onTriggered: {
    //            diffday.stop();
    //            dateDiff(sDate1,sDate2);
    //        }
    //    }

    //        Timer
    //        {
    //            id: timer
    //            onTriggered:
    //            {
    //                image2.x = image2.x + 1
    //                //timer.start(200)
    //            }
    //        }

    TcpClient
    {
        id: tcpclient
        onDataComing: {
            //            var rate
            //            //text1.text += " \nip: " + ip + " \nport: " + port + " \ndata: " + data
            //            rate  =  data.split(",")
            //            rate1 = rate[0]
            rate1 = data[0]
            rate2 = data[1]
            value1 = data[5]
            value2 = data[3]
            value3 = data[4]
            value4 = data[2]
            value5 = data[6]
        }
        onStatusReport: {
            //text1.text += "\nStatusReport:" + msg;
        }
    }
    Component.onCompleted: {
        tcpclient.connectToHost(target_ip, target_port, 0);
    }

    // 设置title
    Rectangle {
        id: rect1_bgImg;
        width:win.width;
        height: 104/screenRate;
        anchors.margins: 10/screenRate;
        color: "#000080"
        Text {
            anchors.fill: parent;
            text:"模具工厂后台信息";
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            font.pointSize: 14/screenRate;
            color: "white";
        }
    }


    Column {
        id: mainRow;
        width: win.width;
        height: win.height-254/screenRate;
        anchors.top: rect1_bgImg.bottom;

        //实时监控
        Rectangle {
            id: real_time;
            width: parent.width;
            //anchors.top: mainRow.top;
            //anchors.bottom: tab.photo.top;
            height: parent.height;
            //height: parent.height
            visible: indexPage==0;

            //开机比、上线天数
            Image{
                id:background
                width: win.width
                height: parent.height * 13/30
                source: "content/background.png"
                Rectangle{
                    id: rate_rect
                    width: parent.width / 3
                    anchors.left: parent.left
                    height: parent.height
                    color:"#00000000"
                    Text{
                        id: rate_text
                        color: "#fff"
                        text: "1/2"
                        font.pointSize: 22/screenRate
                        anchors.topMargin: 240/screenRate
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    id: time_rect
                    width: parent.width / 3
                    anchors.right: parent.right
                    height: parent.height
                    color:"#00000000"
                    Text{
                        id: time_text
                        color: "#fff"
                        text: "33"
                        font.pointSize: 22/screenRate
                        anchors.topMargin: 240/screenRate
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            //时间
            Rectangle{
                id: rect0_time
                width: parent.width
                height: parent.height/30
                anchors.bottom : background.bottom;
                anchors.bottomMargin: 10;
                color: "#03135b"
                Text {
                    id: time;
                    color: "#ffffff";
                    font.pointSize: 12/screenRate;
                    anchors.centerIn: parent;
                }
            }

            //通知报警
            Rectangle{
                id: rect0_alart
                width: parent.width
                height: parent.height/30;
                anchors.top: rect0_time.bottom;
                color: "#fff"
                Text {
                    id: alert
                    color: "#EC6901";
                    font.pointSize: 12/screenRate;
                    anchors.top:parent.top;
                    anchors.topMargin: 8;
                    text: "     通知报警："
                }
            }

            //设备实时状态，饼形图
            Column {
                // anchors.fill: parent
                // property var othersSlice: 0
                id: rect2_state;
                width: mainRow.width
                height: parent.height*15/30
                //color: "#fff";
                //anchors.top : rect2_option.bottom
                anchors.top : rect0_alart.bottom
                //Rectangle{
                //width: parent.width
                //height: parent.height * 4 / 15
                Rectangle{
                    width: parent.width * 18 / 30
                    height: parent.height * 1 /6
                    anchors.horizontalCenter: parent.horizontalCenter
                    color:"#fff"
                    Row{
                        width: parent.width
                        height: parent.height
                        spacing : 40/screenRate
                        //离线标签
                        Item{
                            width: 100/screenRate
                            height: parent.height
                            anchors.bottom: parent.bottom
                            Rectangle{
                                id: off_number
                                height: 50/screenRate
                                width : parent.width
                                color: "#fff"
                                Text{
                                    id: off_text
                                    anchors.centerIn: parent
                                    color: "#000"
                                    text: "2"
                                    font.pointSize: 20/screenRate
                                }
                            }
                            Rectangle{
                                id: off_rect
                                anchors.top : off_number.bottom
                                height: 50/screenRate
                                width: parent.width
                                color: stsColorArr[0]
                                Text{
                                    id: off_rectword
                                    font.pointSize: 30/screenRate
                                    anchors.centerIn: parent
                                    text: "离线"
                                    color: "#fff"
                                }
                            }
                        }
                        //待机标签
                        Item{
                            width: 100/screenRate
                            height: parent.height
                            anchors.bottom: parent.bottom
                            Rectangle{
                                id: wait_number
                                height: 50/screenRate
                                width : parent.width
                                color: "#fff"
                                Text{
                                    id: wait_text
                                    anchors.centerIn: parent
                                    color: "#000"
                                    text: "2"
                                    font.pointSize: 20/screenRate
                                }
                            }
                            Rectangle{
                                id: wait_rect
                                anchors.top : wait_number.bottom
                                height: 50/screenRate
                                width: parent.width
                                color: stsColorArr[1]
                                Text{
                                    id: wait_rectword
                                    font.pointSize: 30/screenRate
                                    anchors.centerIn: parent
                                    text: "待机"
                                    color: "#fff"
                                }
                            }
                        }
                        //怠速标签
                        Item{
                            width: 100/screenRate
                            height: parent.height
                            anchors.bottom: parent.bottom
                            Rectangle{
                                id: idle_number
                                height: 50/screenRate
                                width : parent.width
                                color: "#fff"
                                Text{
                                    id: idle_text
                                    anchors.centerIn: parent
                                    color: "#000"
                                    text: "2"
                                    font.pointSize: 20/screenRate
                                }
                            }
                            Rectangle{
                                id: idle_rect
                                anchors.top : idle_number.bottom
                                height: 50/screenRate
                                width: parent.width
                                color: stsColorArr[2]
                                Text{
                                    id: idle_rectword
                                    font.pointSize: 30/screenRate
                                    anchors.centerIn: parent
                                    text: "怠速"
                                    color: "#fff"
                                }
                            }
                        }
                        //运行标签
                        Item{
                            width: 100/screenRate
                            height: parent.height
                            anchors.bottom: parent.bottom
                            Rectangle{
                                id: run_number
                                height: 50/screenRate
                                width : parent.width
                                color: "#fff"
                                Text{
                                    id: run_text
                                    anchors.centerIn: parent
                                    color: "#000"
                                    text: "2"
                                    font.pointSize: 20/screenRate
                                }
                            }
                            Rectangle{
                                id: run_rect
                                anchors.top : run_number.bottom
                                height: 50/screenRate
                                width: parent.width
                                color: stsColorArr[3]
                                Text{
                                    id: run_rectword
                                    font.pointSize: 30/screenRate
                                    anchors.centerIn: parent
                                    text: "运行"
                                    color: "#fff"
                                }
                            }
                        }
                        //报警标签
                        Item{
                            width: 100/screenRate
                            height: parent.height
                            anchors.bottom: parent.bottom
                            Rectangle{
                                id: err_number
                                height: 50/screenRate
                                width : parent.width
                                color: "#fff"
                                Text{
                                    id: err_text
                                    anchors.centerIn: parent
                                    color: "#000"
                                    text: "2"
                                    font.pointSize: 20/screenRate
                                }
                            }
                            Rectangle{
                                id: err_rect
                                anchors.top : err_number.bottom
                                height: 50/screenRate
                                width: parent.width
                                color: stsColorArr[4]
                                Text{
                                    id: err_rectword
                                    font.pointSize: 30/screenRate
                                    anchors.centerIn: parent
                                    text: "报警"
                                    color: "#fff"
                                }
                            }
                        }


                    }
                }

                Rectangle{
                    width: parent.width
                    height: parent.height * 5 / 6
                    //anchors.top : rect2_state.bottom
                    ChartView {
                        id: chart
                        //title: "设备实时状态"
                        //height: parent.height
                        anchors.fill: parent

                        // 示例的位置
                        legend.visible: false   // 是否显示
                        //                legend.alignment: Qt.AlignLeft
                        // 边缘更加圆滑
                        antialiasing: true
                        //titleFont : 12
                        //color: "#8AB846"; borderColor: "#163430" ;
                        PieSeries {
                            id: pieSeries
                            size: 0.7
                            PieSlice { id: slice1; label: "运行"; value: value1; labelFont.pointSize: 11; color:stsColorArr[3]}
                            PieSlice { id: slice2; label: "报警"; value: value5; labelFont.pointSize: 11; color:stsColorArr[4]}
                            PieSlice { id: slice3; label: "离线"; value: value4; labelFont.pointSize: 11; color:stsColorArr[0]}
                            PieSlice { id: slice4; label: "待机"; value: value2; labelFont.pointSize: 11; color:stsColorArr[1]}
                            PieSlice { id: slice5; label: "怠速"; value: value3; labelFont.pointSize: 11; color:stsColorArr[2]}
                        }
                    }
                }
                Component.onCompleted: {
                    // 新增使用 append(name, value)，系统函数会自动根据值的大小重新计算比例，52/（52+20*5）
                    //othersSlice = pieSeries.append("Others", 52.0);
                    // 突出显示 .exploded
                    //pieSeries.find(slice1.label).exploded = true;
                    // 在图上显示lable
                    for (var i = 0; i < pieSeries.count; i++)
                    {
                        pieSeries.at(i).labelPosition = PieSlice.LabelOutside;
                        //pieSeries.at(i).labelPosition = PieSlice.LabelInsideNormal;
                        pieSeries.at(i).labelVisible = true;
                        // 每一块边框的宽度，如果定义了颜色，则会更加明显
                        //pieSeries.at(i).borderWidth = 5;
                    }
                }
            }
        }

        //设备效能
        Rectangle {
            id: rect1_effort
            width: parent.width
            height : parent.height
            color: "#000070"
            visible: indexPage==1;
            //选择栏

            Column{
                id : column0
                width: parent.width
                height: parent.height

                Rectangle{
                    id: rect1_Box
                    width:parent.width
                    height: parent.height/7
                    color: "#000070"
                    ComboBox {
                        id: mc_box
                        width: 200
                        height: 100/screenRate
                        anchors.centerIn: parent
                        model: [ "GSJ005", "GSJ006", "SKJ005", "SKJ006", "SKJ010", "SKJ011", "SKJ012", "SKJ013"]
                        onCurrentIndexChanged: {
                            // 使用信号槽处理显示信息的变化情况
                            if(currentIndex == 0) {
                                mcPage = 0;
                            }
                            else if(currentIndex == 1) {
                                mcPage = 1;
                            }
                            else if(currentIndex == 2) {
                                mcPage = 2;
                            }
                            else if(currentIndex == 3) {
                                mcPage = 3;
                            }
                            else if(currentIndex == 4) {
                                mcPage = 4;
                            }
                            else if(currentIndex == 5) {
                                mcPage = 5;
                            }
                            else if(currentIndex == 6) {
                                mcPage = 6;
                            }
                            else if(currentIndex == 7) {
                                mcPage = 7;
                            }
                        }
                    }
                }

                //GSJ005
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#000070"
                    visible: mcPage == 0? true : false
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc0
                            size:0.6
                            holeSize: 0.35;
                            PieSlice {
                                borderColor: "#000"
                                color: "#999999"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                }
                //GSJ006
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#000070"
                    visible: mcPage == 1? true : false
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc1
                            size:0.6
                            holeSize: 0.35;
                            PieSlice {
                                borderColor: "#000"
                                color: "#999999"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                }
                //SKJ005
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#000070"
                    visible: mcPage == 2? true : false
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc2
                            size:0.6
                            holeSize: 0.35;
                            PieSlice {
                                borderColor: "#000"
                                color: "#999999"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                }
                //SKJ006
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#000070"
                    visible: mcPage == 3? true : false
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc3
                            size:0.6
                            holeSize: 0.35;
                            PieSlice {
                                borderColor: "#000"
                                color: "#999999"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                }
                //SKJ010
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#000070"
                    visible: mcPage == 4? true : false
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc4
                            size:0.6
                            holeSize: 0.35;
                            PieSlice {
                                borderColor: "#000"
                                color: "#999999"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                }
                //SKJ011
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#000070"
                    visible: mcPage == 5? true : false
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc5
                            size:0.6
                            holeSize: 0.35;
                            PieSlice {
                                borderColor: "#000"
                                color: "#999999"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                }
                //SKJ012
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#000070"
                    visible: mcPage == 6? true : false
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc6
                            size:0.6
                            holeSize: 0.35;
                            PieSlice {
                                borderColor: "#000"
                                color: "#999999"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                }
                //SKJ013
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#000070"
                    visible: mcPage == 7? true : false
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc7
                            size:0.6
                            holeSize: 0.35;
                            PieSlice {
                                borderColor: "#000"
                                color: "#999999"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                }
            }

        }

        //异常加工
        Rectangle {
            id: rect2_err
            width: parent.width
            height : parent.height
            color: "#000070"
            visible: indexPage==2;
            //选择栏

            Column{
                id : column2
                width: parent.width
                height: parent.height

                Rectangle{
                    id: rect3_err
                    width:parent.width
                    height: parent.height * 1/7
                    color: "#000070"
                    ComboBox {
                        id: err_box
                        width: 200
                        height: 100/screenRate
                        anchors.centerIn: parent
                        model: [ "异常运行", "异常待机", "异常报警"]
                        onCurrentIndexChanged: {
                            // 使用信号槽处理显示信息的变化情况
                            if(currentIndex == 0) {
                                mcPage = 0;
                            }
                            else if(currentIndex == 1) {
                                mcPage = 1;
                            }
                            else if(currentIndex == 2) {
                                mcPage = 2;
                            }
                        }
                    }
                }
                Rectangle{
                    width: parent.width * 95 / 100
                    height: parent.height * 6/7
                    anchors.horizontalCenter: parent.horizontalCenter   //水平居中
                    //anchors.rightMargin: 20/screenRate
                    color:"#000070"
                    Column {
                        anchors.margins: 1;
                        anchors.fill: parent;
                        spacing: 0;
                        // 表头
                        Rectangle {
                            width: parent.width;
                            height: 55/screenRate;
                            color: "#000070";
                            Row {
//                                anchors.topMargin: -1;
//                                anchors.leftMargin: -1;
//                                anchors.rightMargin: -1;
                                width:parent.width
                                height: parent.height
                                spacing: 10/screenRate;
                                Rectangle {
                                    height: parent.height;
                                    width: parent.width * 1/5
                                    color: "#666666"
                                    Text {
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#ffffff";
                                        font.pixelSize: 22/screenRate;
                                        text: "序号";
                                    }
                                }
                                Rectangle {
                                    height: parent.height;
                                    width: parent.width * 2/5
                                    color: "#666666"
                                    Text {
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#ffffff";
                                        font.pixelSize: 22/screenRate;
                                        text: "设备名";
                                    }
                                }
                                Rectangle {
                                    height: parent.height;
                                    width: parent.width * 2/5
                                    color: "#666666"
                                    Text {
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#ffffff";
                                        font.pixelSize: 22/screenRate;
                                        text: "异常运行次数";
                                    }
                                }
                            }
                        }
                        // 报表
                        Item {
                            width: parent.width;
                            height: parent.height - 55/screenRate
                            Rectangle{
                                //anchors.margins: 2;
                                //anchors.fill: parent;
                                color: "#dcdcdc"
                                ListView {
                                    id: listview_tool;
                                    boundsBehavior: Flickable.StopAtBounds;
                                    anchors.fill: parent;
                                    delegate: delegate_tool;
                                    model: ListModel { }
                                    focus: true;
                                    highlight: Rectangle{ color: "#8a8a8a"; }
                                    section.criteria: ViewSection.FullString;
                                    currentIndex: 0;
                                    clip: true;
                                    highlightMoveDuration: 200;
                                }
                            }
                            // ListView模型配置
                            Component { id: delegate_tool;
                                Item {
                                    id: listviewMode; width: parent.width; height: 45;
                                    MouseArea { anchors.fill: parent;
                                        onClicked: listviewMode.ListView.view.currentIndex = index;
                                    }
                                    Row {
                                        anchors.margins: 0;
                                        anchors.fill: parent;
                                        spacing: 1;
                                        Text {
                                            text: Rank;
                                            clip: true;
                                            height: parent.height;
                                            width: (parent.width-5*parent.spacing)/6*0.7;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                            font.family: "Microsoft YaHei";
                                            color: listviewMode.ListView.isCurrentItem ? "#ffffff" : "#000000";
                                            font.pixelSize: 20;
                                        }
                                        Text {
                                            text: Name;
                                            clip: true;
                                            height: parent.height;
                                            width: (parent.width-5*parent.spacing)/6;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                            font.family: "Microsoft YaHei";
                                            color: listviewMode.ListView.isCurrentItem ? "#ffffff" : "#000000";
                                            font.pixelSize: 20;
                                        }
                                        Text {
                                            text: Counts;
                                            clip: true;
                                            height: parent.height;
                                            width: (parent.width-5*parent.spacing)/6*0.8;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                            font.family: "Microsoft YaHei";
                                            color: listviewMode.ListView.isCurrentItem ? "#ffffff" : "#000000";
                                            font.pixelSize: 20;
                                        }
                                        Text {
                                            text: Total;
                                            clip: true;
                                            height: parent.height;
                                            width: (parent.width-5*parent.spacing)/6*1.3;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                            font.family: "Microsoft YaHei";
                                            color: listviewMode.ListView.isCurrentItem ? "#ffffff" : "#000000";
                                            font.pixelSize: 20;
                                        }
                                        Text {
                                            text: Average;
                                            clip: true;
                                            height: parent.height;
                                            width: (parent.width-5*parent.spacing)/6*1.2;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                            font.family: "Microsoft YaHei";
                                            color: listviewMode.ListView.isCurrentItem ? "#ffffff" : "#000000";
                                            font.pixelSize: 20;
                                        }
                                        Item {
                                            height: parent.height;
                                            width: (parent.width-5*parent.spacing)/6;
                                            Button {
                                                text: Remarks;
                                                enabled: listviewMode.ListView.isCurrentItem ? true : false;
                                                clip: true;
                                                anchors.margins: 5;
                                                anchors.fill: parent;
                                                font.family: "Microsoft YaHei";
                                                font.pixelSize: 18;
                                                onClicked: {
                                                    // 切换页面
                                                    chart22Mouse.enabled = true;
                                                    chartView22.visible = true;
                                                    // 赋值信息
                                                    var listViewVal = listview_tool.model.get(listview_tool.currentIndex);
                                                    chartView22.staffName = listViewVal.Name;
                                                    chartView22.chartTitle = "[ "+chartView22.staffName+" ]换刀数据统计分析";
                                                    chartView22.dataBuffer = staffTools[listViewVal.realIndex];
                                                    // 画图
                                                    series22.clear();
                                                    var dataLen = chartView22.dataBuffer.length;
                                                    axisX22.max = dataLen + 1;
                                                    axisX22.tickCount = axisX22.max + 1;
                                                    axisY22.min = 0;
                                                    axisY22.max = 20;
                                                    for(var i=0; i<dataLen; i++) {
                                                        series22.append(i+1, Number((chartView22.dataBuffer[i][2]/60).toFixed(1)));
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }


            }
        }

        //员工绩效
        Rectangle {
            id: rect3_effort
            width: parent.width
            height : parent.height
            color: "#000070"
            visible: indexPage==3;
            //选择栏

            Column{
                id : column3
                width: parent.width
                height: parent.height

                Rectangle{
                    id: rect4_effort
                    width:parent.width
                    height: parent.height * 1/7
                    color: "#000070"
                    ComboBox {
                        id: effort_box
                        width: 200
                        height: 100/screenRate
                        anchors.centerIn: parent
                        model: [ "换刀数据统计","换料数据统计","加工实效统计"]
                        onCurrentIndexChanged: {
                            // 使用信号槽处理显示信息的变化情况
                            if(currentIndex == 0) {
                                mcPage = 0;
                            }
                            else if(currentIndex == 1) {
                                mcPage = 1;
                            }
                            else if(currentIndex == 2) {
                                mcPage = 2;
                            }
                            else if(currentIndex == 3) {
                                mcPage = 3;
                            }
                            else if(currentIndex == 4) {
                                mcPage = 4;
                            }
                            else if(currentIndex == 5) {
                                mcPage = 5;
                            }
                            else if(currentIndex == 6) {
                                mcPage = 6;
                            }
                            else if(currentIndex == 7) {
                                mcPage = 7;
                            }
                        }
                    }
                }


            }
        }
    }

    Column{
        id: tab
        width: win.width
        height: 150/screenRate
        anchors.top: mainRow.bottom
        anchors.bottom: win.bottom

        // tab图片切换
        Item{
            // anchors.topMargin: 50;
            // width: parent.width;
            // height: 30;
            id: tab_photo;
            width: parent.width;
            height: parent.height/15*9;
            Row{
                width: parent.width;
                height: parent.height;
                //anchors.top : parent.top;
                //实时监控
                Item {
                    width: parent.width/5;
                    height: parent.height/1.3;
                    z: indexPage==0 ? 5:4;
                    Image {
                        id: selImg;
                        height: parent.height-4;
                        width: 68/screenRate
                        //anchors.fill: parent;
                        anchors.centerIn: parent;
                        source: indexPage==0 ? "content/inspect_blue.png" : "content/inspect_black.png";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(0);
                            }
                        }
                    }
                }
                //设备效能
                Item {
                    width: (parent.width)/5;
                    height: parent.height/1.3;
                    z: indexPage==1 ? 5:3;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height - 4;
                        width: 65/screenRate
                        source: indexPage==1 ? "content/mc_blue.png" : "content/mc_black.png";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(1);
                            }
                        }
                    }
                }
                //异常加工
                Item {
                    width: (parent.width)/5;
                    height: parent.height/1.3;
                    z: indexPage==2 ? 5:2;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height;
                        width: 65/screenRate
                        source: indexPage==2 ? "content/err_blue.png" : "content/err_black.png";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(2);
                            }
                        }
                    }
                }
                //员工绩效
                Item {
                    width: (parent.width)/5;
                    height: parent.height/1.3;
                    z: indexPage==1 ? 5:3;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height - 4;
                        width: 65/screenRate
                        source: indexPage==3 ? "content/staff_blue.png" : "content/staff_black.png";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(3);
                            }
                        }
                    }
                }
                //我的
                Item {
                    width: (parent.width)/5;
                    height: parent.height/1.3;
                    z: indexPage==1 ? 5:3;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height - 4;
                        width: 65/screenRate
                        source: indexPage==4 ? "content/user_blue.png" : "content/user_black.png";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(4);
                            }
                        }
                    }
                }
            }
        }

        //tab文字切换
        Item{
            // anchors.topMargin: 50;
            // width: parent.width;
            // height: 30;
            id: tab_word;
            width: parent.width;
            height: parent.height/8;
            Row{
                width: parent.width;
                height: parent.height;
                // anchors.top : parent.top;
                //实时监控
                Item {
                    width: (parent.width)/5;
                    height: parent.height;
                    z: indexPage==0 ? 5:4;
                    //实时监控
                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 25/screenRate
                        text: "实时监控";
                        color: indexPage==0 ? "#000" : "#8a8a8a";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(0);
                            }
                        }
                    }
                }
                //设备效能
                Item {
                    width: (parent.width)/5;
                    height: parent.height;
                    z: indexPage==1 ? 5:3;
                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 25/screenRate
                        text: "设备效能";
                        color: indexPage==1 ? "#000" : "#8a8a8a";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(1);
                            }
                        }
                    }
                }
                //异常加工
                Item {
                    width: (parent.width)/5;
                    height: parent.height;
                    z: indexPage==2 ? 5:2;

                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 25/screenRate
                        text: "异常加工";
                        color: indexPage==2 ? "#000" : "#8a8a8a";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(2);
                            }
                        }
                    }
                }
                //员工绩效
                Item {
                    width: (parent.width)/5;
                    height: parent.height;
                    z: indexPage==1 ? 5:3;

                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 25/screenRate
                        text: "员工绩效";
                        color: indexPage==3 ? "#000" : "#8a8a8a";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(3);
                            }
                        }
                    }
                }
                //我的
                Item {
                    width: (parent.width)/5;
                    height: parent.height;
                    z: indexPage==1 ? 5:3;

                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 25/screenRate
                        text: "我的";
                        color: indexPage==4 ? "#000" : "#8a8a8a";
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                setCurrentFault(3);
                            }
                        }
                    }
                }
            }
        }
    }


    function setCurrentFault(index)
    {
        // visible状态
        indexPage = index;
        // 箭头移动
        //tabOBDII.anchors.leftMargin = tabOBDII.width*index;
    }

    function selectPage(index)
    {
        pageIndex = index;;
        selectItem.anchors.leftMargin = selectItem.width*index;
    }

}

