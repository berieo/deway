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

    property int indexPage: 0;    // 故障代码生成器的页面状态值，确定当前所在的页面
    property int mcPage: 0;
    property string tabSel: "content/tab_selected.png"
    property string tabSeless: "content/tab.png"

    //开机比
    property var rate1: 1
    property var rate2: 2

    //设备状态图
    property int value1: 10
    property int value2: 20
    property int value3: 20
    property int value4: 20
    property int value5: 20

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
        color: "#0c1d3b"
        Text {
            anchors.fill: parent;
            //text:"上海贸易学校交通诱导牌v1.0.0";
            text:"模具工厂后台信息";
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            font.pointSize: 14;
            color: "white";
        }
    }

    Column {
        id: mainRow;
        width: win.width;
        height: win.height-224/screenRate;
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

            //开机比、上线天数、正常圆图
            Rectangle {
                id: rect0_state
                width: parent.width
                //height: 450/screenRate
                height : parent.height * 5/16
                color: "#0c1d3b"

                Button {
                    id: setupbt;
                    width: parent.width/3.5;
                    height: 108/screenRate;
                    anchors.left: rect0_state.left;
                    anchors.leftMargin: 10;
                    anchors.top: rect0_state.top;
                    anchors.topMargin: 50;
                    Text {
                        anchors.centerIn: setupbt;
                        text: qsTr("开机比：" + rate1 + "/" + rate2);
                        font.pointSize: 11;
                        font.family: "Microsoft YaHei";
                        color:"#000080";
                    }
//                    onClicked:{
//                            tcpclient.connectToHost(target_ip, target_port, 0);
//                    }
                }

                Image
                {
                    width: 120
                    height: 120
                    anchors.centerIn: parent
                    source: "content/正常.png"
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                }

                Button {
                    id: exit;
                    width: parent.width/3.5;
                    height: 108/screenRate;
                    anchors.right: rect0_state.right;
                    anchors.rightMargin: 10;
                    anchors.top: rect0_state.top;
                    anchors.topMargin: 50;
                    Component.onCompleted: {
                        dateDiff(date2,date1)
                    }
                    Text {
                        anchors.centerIn: exit;
                        text: qsTr("上线天数：" + idays);
                        font.pointSize: 12;
                        font.family: "Microsoft YaHei";
                        color:"#000080";
                    }
                }
            }

            Rectangle{
                id: rect0_time
                width: parent.width
                height: parent.height/30
                anchors.bottom : rect0_state.bottom;
                anchors.bottomMargin: 10;
                color: "#0c1d3b"
                Text {
                    id: time;
                    color: "#ffffff";
                    font.pointSize: 10;
                    anchors.centerIn: parent;
                }
            }

            Rectangle{
                id: rect0_alart
                width: parent.width
                height: parent.height/20;
                anchors.top: rect0_time.bottom;
                color: "#DBF1FF"
                Text {
                    id: alert
                    color: "#EC6901";
                    font.pointSize: 10;
                    anchors.top:parent.top;
                    anchors.topMargin: 8;
                    text: "     通知报警："
                }
            }

            //设备实时状态，饼形图
            Rectangle {
                // anchors.fill: parent
                // property var othersSlice: 0
                id: rect2_state;
                width: mainRow.width
                height: parent.height*13/20
                color: "#DBF1FF";
                //anchors.top : rect2_option.bottom
                anchors.top : rect0_alart.bottom
                ChartView {
                    id: chart
                    title: "设备实时状态"
                    anchors.fill: parent
                    // 示例的位置
                    //                legend.visible: true   // 是否显示
                    //                legend.alignment: Qt.AlignLeft
                    // 边缘更加圆滑
                    antialiasing: true
                    //titleFont : 12
                    //color: "#8AB846"; borderColor: "#163430" ;
                    PieSeries {
                        id: pieSeries
                        size:0.7
                        PieSlice { id: slice1; label: "运行"; value: value1; labelFont.pointSize: 11; }
                        PieSlice { id: slice2; label: "待机"; value: value2; labelFont.pointSize: 11; }
                        PieSlice { id: slice3; label: "怠速"; value: value3; labelFont.pointSize: 11; }
                        PieSlice { id: slice4; label: "离线"; value: value4; labelFont.pointSize: 11; }
                        PieSlice { id: slice5; label: "报警"; value: value5; labelFont.pointSize: 11; }
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
            color: "#0c1d3b"
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
                    color: "#0c1d3b"
                    ComboBox {
                        id: mc_box
                        width: 200
                        height: 100/screenRate
                        anchors.centerIn: parent
                        model: [ "Bosen001", "Bosen002", "SKJ005", "SKJ006", "SKJ010", "SKJ011", "SKJ012", "SKJ013"]
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

                //图表
                Rectangle {
                    id: mc_chart;
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#DBF1FF"
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
                            id: pieSeries_mc
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
            color: "#0c1d3b"
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
                    color: "#0c1d3b"
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

                //图表
                Rectangle {
                    id: err_chart;
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#DBF1FF"
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
                            id: pieSeries_err
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

        //员工绩效
        Rectangle {
            id: rect3_effort
            width: parent.width
            height : parent.height
            color: "#0c1d3b"
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
                    color: "#0c1d3b"
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

                //图表
                Rectangle {
                    id: effort_chart;
                    width: parent.width;
                    height: parent.height * 6/7
                    color: "#DBF1FF"
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
                            id: pieSeries_effort
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
                    width: parent.width/4;
                    height: parent.height/1.3;
                    z: indexPage==0 ? 5:4;
                    Image {
                        id: selImg;
                        height: parent.height-4;
                        width: 22
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
                    width: (parent.width)/4;
                    height: parent.height/1.3;
                    z: indexPage==1 ? 5:3;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height - 4;
                        width: 22
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
                    width: (parent.width)/4;
                    height: parent.height/1.3;
                    z: indexPage==2 ? 5:2;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height;
                        width: 22
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
                    width: (parent.width)/4;
                    height: parent.height/1.3;
                    z: indexPage==1 ? 5:3;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height - 4;
                        width: 22
                        source: indexPage==3 ? "content/staff_blue.png" : "content/staff_black.png";
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
                    width: (parent.width)/4;
                    height: parent.height;
                    z: indexPage==0 ? 5:4;
                    //实时监控
                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 12
                        text: "实时监控";
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
                    width: (parent.width)/4;
                    height: parent.height;
                    z: indexPage==1 ? 5:3;
                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 12
                        text: "设备效能";
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
                    width: (parent.width)/4;
                    height: parent.height;
                    z: indexPage==2 ? 5:2;

                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 12
                        text: "异常加工";
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
                    width: (parent.width)/4;
                    height: parent.height;
                    z: indexPage==1 ? 5:3;

                    Text{
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: 12
                        text: "员工绩效";
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

    /*           //切换页面
            Item{
                width: parent.width;
                height: 1000/screenRate;
                Rectangle{
                    width: parent.width;
                    height: 100/screenRate;
                    color: "#8199E1";
                }

                //异常加工
                Rectangle {
                    width: parent.width;
                    height: parent.height;
                    color: "#8199E1";
                    visible: indexPage == 1
                    Column{
                        width: parent.width;
                        height: parent.height;
                        Rectangle {
                            width:parent.width;
                            height:100/screenRate;
                            color:"#8199E1";
                            ComboBox {
                                width: 200
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
                        Rectangle {
                            width: parent.width;
                            height: 800/screenRate;
                            color: "#8199E1"
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
                                    id: pieSeries_err
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
                //员工绩效
                Rectangle {
                    width: parent.width;
                    height: parent.height;
                    color: "#8199E1";
                    visible: indexPage == 2
                    Column{
                        width: parent.width;
                        height: parent.height;
                        Rectangle {
                            width:parent.width;
                            height:100/screenRate;
                            color:"#8199E1";
                            ComboBox {
                                width: 200
                                model: [ "换刀数据", "换料数据", "加工实效"]
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
                        Rectangle {
                            width: parent.width;
                            height: 800/screenRate;
                            color: "#8199E1"
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
                                    id: pieSeries_perfom
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
            }
                Text {
                    id: targetTemp;
                    text: "192.168.0.28";
                    visible: false;
                }

                Text {
                    id: ledTemp;
                    text: "192.168.0.100";
                    visible: false;
                }
*/

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

    function isIp(ip)
    {
        var ip_array = ip.text.split(".");
        if(ip_array[0]>255||ip_array[0]<1){
            return false;
        } else if(ip_array[1]>255||ip_array[1]<0){
            return false;
        } else if(ip_array[2]>255||ip_array[2]<0){
            return false;
        } else if(ip_array[3]>255||ip_array[3]<1){
            return false;
        } else {
            return true;
        }
        return false;
    }

    function setup()
    {
        //label1.text = "names: " + ntcip.getItemNames().length
        //return;

        if(button2.version === "version3")
        {
            //if(ntcip.initNTCIPCenter("unsecure", "version1", "169.254.39.166", "6699") === 1)

            /*if(ntcip.initNTCIPCenter("md5des", "version3",
                                     "169.254.39.166", "6699" , "MD5DES",
                                     "12345678", "12345678",
                                     "MD5", "DES") === 1)

            if(ntcip.initNTCIPCenter("md5des", "version3",
                                     "192.168.5.100", "6699" , "MD5DES",
                                     "12345678", "12345678",
                                     "MD5", "DES") === 1)

                //securemodel = "md5des", version = "version3"
            if(ntcip.initNTCIPCenter("md5des", "version3",
                                     localip1.text, "6699" , "MD5DES",
                                     "12345678", "12345678",
                                     "MD5", "DES") === 1)

                //ip = "169.254.39.166", port = "6699"
                //username = "MD5DES", authpassword = "12345678"
                //encryptpassword = "12345678", auth method = "MD5"
                //encry method = "DES"
            {
                label1.text = "Initializatin ok" + "\r\n"
                button2.enabled = 1
            }
            else
            {

                label1.text = "Initializatin failure" + "\r\n"
            }
            label1.text += "iface: " + ntcip.getNetworkInterfaces() + "\r\n"
        }
        else
            label1.text = "ret: " + ntcip.initNTCIPCenter(version, 4700);
        //label1.text = "init ok";

            if(ntcip1.initNTCIPCenter("md5des", "version3",
                                     "192.168.5.28", "6699" , "MD5DES",
                                     "12345678", "12345678",
                                     "MD5", "DES") === 1)

                //ip = "169.254.39.166", port = "6699"
                //username = "MD5DES", authpassword = "12345678"
                //encryptpassword = "12345678", auth method = "MD5"
                //encry method = "DES"
            {
                label1.text = "Initializatin ok" + "\r\n"
                button2.enabled = 1
            }
            else
            {

                label1.text = "Initializatin failure" + "\r\n"
            }*/

            if(ntcip.addNTCIPCenter("md5des", "version3",
                                    targetip.text, "6699" , "MD5DES",
                                    "12345678", "12345678",
                                    "MD5", "DES") === 0)

                //ip = "169.254.39.166", port = "6699"
                //username = "MD5DES", authpassword = "12345678"
                //encryptpassword = "12345678", auth method = "MD5"
                //encry method = "DES"
            {
                //label1.text = "Initializatin ok" + "\r\n"
                button2.enabled = 1
                flag=true
            }
            else
            {
                //label1.text = "Initializatin failure" + "\r\n"
                flag=false
            }
            //label1.text += "iface: " + ntcip.getNetworkInterfaces() + "\r\n"
        }
        else
            //label1.text = "ret: " + ntcip.initNTCIPCenter(version, 4700);
            //label1.text = "init ok";
            //return;
            if(ntcip.addNTCIPCenter("md5des", "version3",
                                    localip.text, "6699" , "MD5DES",
                                    "12345678", "12345678",
                                    "MD5", "DES") === 0)

                //ip = "169.254.39.166", port = "6699"
                //username = "MD5DES", authpassword = "12345678"
                //encryptpassword = "12345678", auth method = "MD5"
                //encry method = "DES"
            {
                //label1.text = "Initializatin ok" + "\r\n"
                button2.enabled = 1
            }
            else
            {
                //label1.text = "Initializatin failure" + "\r\n"
            }
        //label1.text = "list: " + ntcip.getCenterIPs()

    }

    function call(index)
    {
        /* win.indexVal = parseInt((index10.currentIndex - 1) * 10 + (index0.currentIndex - 1))
        //indexVal = ((index10.currentIndex - 1) * 10 + (index0.currentIndex - 1))
        //win.indexVal = win.indexVal + 1*/
        var v;

        //v = ntcip.set_multi("192.168.5.99:6699", "dmsMessageBeacon", win.indexVal)
        //v = ntcip.set_multi("192.168.5.99", "dmsMessageBeacon", win.indexVal)

        v = ntcip.set_multi(targetip.text, "dmsMessageBeacon", index)
        return;

        //        if(cmdselect.currentText === "Switch Pic")
        //            v = ntcip.set("dmsMessageBeacon", win.indexVal, "192.168.5.99:6699")
        //        else
        //            v = ntcip.set("dmsResetMessage", win.indexVal)
        //label1.text += "result: " + v + "\r\n";
        //label1.text += "ntext: " + parseInt((index10.currentIndex - 1) * 10 + (index0.currentIndex - 1)) + "\r\n"

    }
    function  dateDiff(sDate1,  sDate2){    //sDate1和sDate2是xxxx-xx-xx格式
        var  aDate1, aDate2, oDate1,  oDate2
        aDate1  =  sDate1.split("-")
        //oDate1  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0])    //转换为xx-xx-xxxx格式
        aDate2  =  sDate2.split("-")
        //oDate2  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0])
        //win.idays  =  parseInt(Math.abs(oDate1  -  oDate2)/1000/60/60/24)    //把相差的毫秒数转换为天数
        win.idays = (aDate1[0] - aDate2[0]) * 365 + (aDate1[1] - aDate2[1]) * 30 + (aDate1[2] - aDate2[2])
        //要改进

    }
}

