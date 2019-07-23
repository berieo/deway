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
    //枚举
    property var cncNumber: ["GSJ005", "GSJ006", "SKJ005", "SKJ006", "SKJ010", "SKJ011", "SKJ012", "SKJ013"]
    property var operator: ["吴国兴","赵文峰","王向前","葛伟刚","陈勇驰","乔国才","杨吉","周定武"]

    property int indexPage: 0;    // 故障代码生成器的页面状态值，确定当前所在的页面
    property int mcPage: 0;
    property string tabSel: "content/tab_selected.png"
    property string tabSeless: "content/tab.png"

    property var setspeed_errRun : 20 // 设定转速/100
    property var setfeedrate_errRun : 20 // 设定进给速度/100

    //开机比
    property var rate1: 1
    property var rate2: 2

    //设备状态图
    property int value1: 10
    property int value2: 20
    property int value3: 20
    property int value4: 20
    property int value5: 20

    property var err_Arr: new Array(20)

    //计数器
    property int j: 0
    property int i: 0
    property int k: 0
    property int m: 0

    // 屏幕适配标志位
    property real screenRate: (1080/win.width).toFixed(3);
    property var faultPageSts: 0
    property bool flag: false;

    //TCP连接
    //property string target_ip: "127.0.0.1"
    //property int target_port: 8080
    property string target_ip: "192.168.1.5"
    property int target_port: 9212
    property var err_Wait : new Array(8)
    property var err_Alarm: new Array(8)
    property var err_Run : new Array(8)


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
            slice1.value = data[5]
            slice2.value = data[3]
            slice3.value = data[4]
            slice4.value = data[2]
            slice5.value = data[6]
            pie1Slice1.value = data[8]
            pie1Slice2.value = data[9]
            pie1Slice3.value = data[10]
            pie1Slice4.value = data[11]
            pie1Slice5.value = data[12]
            pie2Slice1.value = data[14]
            pie2Slice2.value = data[15]
            pie2Slice3.value = data[16]
            pie2Slice4.value = data[17]
            pie2Slice5.value = data[18]
            pie3Slice1.value = data[20]
            pie3Slice2.value = data[21]
            pie3Slice3.value = data[22]
            pie3Slice4.value = data[23]
            pie3Slice5.value = data[24]
            pie4Slice1.value = data[26]
            pie4Slice2.value = data[27]
            pie4Slice3.value = data[28]
            pie4Slice4.value = data[29]
            pie4Slice5.value = data[30]
            pie5Slice1.value = data[32]
            pie5Slice2.value = data[33]
            pie5Slice3.value = data[34]
            pie5Slice4.value = data[35]
            pie5Slice5.value = data[36]
            pie6Slice1.value = data[38]
            pie6Slice2.value = data[39]
            pie6Slice3.value = data[40]
            pie6Slice4.value = data[41]
            pie6Slice5.value = data[42]
            pie7Slice1.value = data[44]
            pie7Slice2.value = data[45]
            pie7Slice3.value = data[46]
            pie7Slice4.value = data[47]
            pie7Slice5.value = data[48]
            pie8Slice1.value = data[50]
            pie8Slice2.value = data[51]
            pie8Slice3.value = data[52]
            pie8Slice4.value = data[53]
            pie8Slice5.value = data[54]
            j = data[55]
            setspeed_errRun = data[56]
            setfeedrate_errRun = data[57]
            //errModel.append({"number":"1", "name":"1", "count":1})
            //            for(i=1; i<=j*3; i++){
            //                err_Arr[i-1] = data[57+i]
            //                text1.text += err_Arr[i-1]
            //            }
            for(i=0, k=0; k<8; i+=6){
                err_Wait[k] = data[9+i]
                err_Alarm[k] = data[12+i]
                err_Run[k] = err_Wait[k] + err_Alarm[k]
                k++
            }
            //异常运行赋值
            for(k=0,m=1; k<8; k++){
                if(err_Run[k] === 0){
                    continue;
                }
                errModel.append({"number":""+m, "name":cncNumber[k], "count":err_Run[k]})
                m++
                //errModel.append({"number":"1", "name":"1", "count":1})
            }
            //异常待机赋值
            for(k=0,m=1; k<8; k++){
                if(err_Wait[k] === 0){
                    continue;
                }
                errModel_wait.append({"number":""+m, "name":cncNumber[k], "count":err_Wait[k]})
                m++;
            }
            //异常报警赋值
            for(k=0,m=1; k<8; k++){
                if(err_Alarm[k] === 0){
                    continue;
                }
                errModel_alarm.append({"number":""+m, "name":cncNumber[k], "count":err_Alarm[k]})
                m++;
            }
            //换刀数据统计
            for(k=0,m=1; k<8; k++){
                staffModel_tool.append({"number":""+m, "name":operator[k], "count":err_Wait[k], "mc":cncNumber[k]})
                m++;
            }
            //换料数据统计
            for(k=0,m=1; k<8; k++){
                staffModel_material.append({"number":""+m, "name":operator[k], "count":err_Wait[k], "mc":cncNumber[k]})
                m++;
            }
            //加工实效统计
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
        color: "#337df8"
        Text {
            id: text0
            anchors.fill: parent;
            text:"模具工厂后台信息";
            font.family:"Microsoft JhengHei"
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            font.pointSize: 15/screenRate;
            //font.pointSize: 30/screenRate
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
                height : parent.height * 13/30
                color: "#fff"


                Image {
                    width:parent.width
                    height:parent.height * 27/30
                    source: "content/background.png"
                }
                Image
                {
                    width: 520/screenRate
                    height: 570/screenRate
                    //anchors.centerIn: parent
                    source: "content/normal.png"
                    //anchors.topMargin: 1/screenRate

                    anchors.horizontalCenter: parent.horizontalCenter
                    //fillMode: Image.PreserveAspectCrop
                    //clip: true
                }

                Rectangle {
                    id: setupbt;
                    width: parent.width * 2/7;
                    height: 108/screenRate;
                    anchors.left: rect0_state.left;
                    anchors.leftMargin: 10;
                    anchors.top: rect0_state.top;
                    anchors.topMargin: parent.height*1/2
                    radius: 30/screenRate
                    //anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: setupbt;
                        text: qsTr("开机比：" + rate1 + "/" + rate2);
                        font.pointSize: 11;
                        font.family: "mi";
                        color:"#000080";

                    }
                    //                    onClicked:{
                    //                            tcpclient.connectToHost(target_ip, target_port, 0);
                    //                    }
                }



                Rectangle {
                    id: exit;
                    width: parent.width* 2/7;
                    height: 108/screenRate;
                    anchors.right: rect0_state.right;
                    anchors.rightMargin: 10;
                    anchors.top: rect0_state.top;
                    anchors.topMargin: parent.height*1/2
                    radius: 30/screenRate
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
            //
            //}

            Rectangle{
                id: rect0_time
                width: parent.width
                height: parent.height * 1/30
                anchors.bottom : rect0_state.bottom;
                anchors.bottomMargin: 10/screenRate;
                color: "#fff"
                Text {
                    id: time;
                    color: "#337df8";
                    font.pointSize: 12/screenRate;
                    anchors.centerIn: parent;
                }
            }

            Rectangle{
                id: rect0_alart
                width: parent.width
                height: parent.height * 1/30;
                anchors.top: rect0_time.bottom;
                color: "#fff"
                Text {
                    id: alert
                    color: "#EC6901";
                    font.pointSize: 10;
                    anchors.top:parent.top;
                    anchors.topMargin: 10/screenRate;
                    text: "     通知报警："
                }
            }

            //设备实时状态，饼形图
            Rectangle {
                // anchors.fill: parent
                // property var othersSlice: 0
                id: rect2_state;
                width: mainRow.width/30 * 28
                height: parent.height* 15/30
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#fff";
                //anchors.top : rect2_option.bottom
                anchors.top : rect0_alart.bottom


                ChartView {
                    id: chart
                    title: "设备实时状态"
                    anchors.fill: parent
                    anchors.centerIn: parent

                    // 示例的位置
                    legend.visible: false;   // 是否显示
                    //legend.font.pixelSize : 40/screenRatelegend.alignment: Qt.AlignLeft
                    // 边缘更加圆滑
                    antialiasing: true
                    animationOptions: ChartView.SeriesAnimations
                    titleFont.pixelSize : 45/screenRate
                    titleFont.family: "Helvetica"
                    titleColor: "#f9faf5"

                    // color: "#8AB846";

                    backgroundColor:"#3388F8"
                    backgroundRoundness:35/screenRate
                    //plotAreaColor: "#1a154b"
                    PieSeries {
                        holeSize: 0.56;
                        id: pieSeries
                        size:0.7
                        PieSlice { id: slice1; label: "运行"; value: 20; labelFont.pointSize: 11; labelColor: "#f9faf5"; color:"#599DD9"; labelFont.family:"NSimSun"}
                        PieSlice { id: slice2; label: "待机"; value: 20; labelFont.pointSize: 11; labelColor: "#f9faf5"; color:"#94CEF2"; labelFont.family:"NSimSun"}
                        PieSlice { id: slice3; label: "怠速"; value: 20; labelFont.pointSize: 11; labelColor: "#f9faf5"; color:"#05AFF2"; labelFont.family:"NSimSun"}
                        PieSlice { id: slice4; label: "离线"; value: 20; labelFont.pointSize: 11; labelColor: "#f9faf5"; color:"#0597F2"; labelFont.family:"NSimSun"}
                        PieSlice { id: slice5; label: "报警"; value: 20; labelFont.pointSize: 11; labelColor: "#f9faf5"; color:"#4A89C1"; labelFont.family:"NSimSun"}
                    }
                }

                Component.onCompleted: {
                    // 新增使用 append(name, value)，系统函数会自动根据值的大小重新计算比例，52/（52+20*5）
                    //othersSlice = pieSeries.append("Others", 52.0);
                    // 突出显示 .exploded
                    pieSeries.find(slice1.label).exploded = true;
                    // 在图上显示lable
                    for (var i = 0; i < pieSeries.count; i++)
                    {
                        pieSeries.at(i).labelPosition = PieSlice.LabelOutside;
                        //pieSeries.at(i).labelPosition = PieSlice.LabelInsideNormal;
                        pieSeries.at(i).labelVisible = true;
                        // 每一块边框的宽度，如果定义了颜色，则会更加明显
                        pieSeries.at(i).borderWidth = 0;
                    }
                }
            }
        }

        //设备效能
        Rectangle {
            id: rect1_effort
            width: parent.width
            height : parent.height
            //color: "#337df8"
            color:"#337df8"
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
                    color: "#337df8"
                    ComboBox {
                        id: mc_box
                        width: 450/screenRate
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

                //图表
                Rectangle {
                    id: mc_chart;
                    width: parent.width;
                    height: parent.height * 6/7
                    //color: "#DBF1FF"
                    color: "#337df8"
                    //color:"#0e8afe"
                    //GSJ005
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        visible: mcPage == 0
                        //plotArea.radius:5
                        legend{
                            visible: false
                        }
                        PieSeries {
                            id: pieSeries_mc
                            size:0.6
                            holeSize: 0.44;
                            PieSlice {
                                id: pie1Slice1
                                borderColor: "#000"
                                color: "#00fffe"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie1Slice2
                                borderColor: "#000"
                                color: "#e66c31"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie1Slice3
                                borderColor: "#000"
                                color: "#967ddf"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie1Slice4
                                borderColor: "#000"
                                color: "#82ca51"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie1Slice5
                                borderColor: "#000"
                                color: "#42a2da"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                    //GSJ006
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        visible: mcPage == 1
                        legend{
                            visible: false
                        }

                        PieSeries {
                            id: pieSeries_mc1
                            size:0.6
                            holeSize: 0.44;
                            PieSlice {
                                id: pie2Slice1
                                borderColor: "#000"
                                color: "#e66c31"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie2Slice2
                                borderColor: "#000"
                                color: "#00fffe"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie2Slice3
                                borderColor: "#000"
                                color: "#82ca51"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie2Slice4
                                borderColor: "#000"
                                color: "#42a2da"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie2Slice5
                                borderColor: "#000"
                                color: "#967ddf"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                    //SKJ005
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        visible: mcPage == 2
                        legend{
                            visible: false
                        }

                        PieSeries {
                            id: pieSeries_mc2
                            size:0.6
                            holeSize: 0.44;
                            PieSlice {
                                id: pie3Slice1
                                borderColor: "#000"
                                color: "#967ddf"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie3Slice2
                                borderColor: "#000"
                                color: "#42a2da"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie3Slice3
                                borderColor: "#000"
                                color: "#00fffe"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie3Slice4
                                borderColor: "#000"
                                color: "#e66c31"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie3Slice5
                                borderColor: "#000"
                                color: "#82ca51"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                    //SKJ006
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        visible: mcPage == 3
                        legend{
                            visible: false
                        }

                        PieSeries {
                            id: pieSeries_mc3
                            size:0.6
                            holeSize: 0.44;
                            PieSlice {
                                id: pie4Slice1
                                borderColor: "#000"
                                color: "#42a2da"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie4Slice2
                                borderColor: "#000"
                                color: "#82ca51"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie4Slice3
                                borderColor: "#000"
                                color: "#967ddf"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie4Slice4
                                borderColor: "#000"
                                color: "#e66c31"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie4Slice5
                                borderColor: "#000"
                                color: "#00fffe"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                    //SKJ010
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        visible: mcPage == 4
                        legend{
                            visible: false
                        }

                        PieSeries {
                            id: pieSeries_mc4
                            size:0.6
                            holeSize: 0.44;
                            PieSlice {
                                id: pie5Slice1
                                borderColor: "#000"
                                color: "#e66c31"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie5Slice2
                                borderColor: "#000"
                                color: "#00fffe"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie5Slice3
                                borderColor: "#000"
                                color: "#967ddf"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie5Slice4
                                borderColor: "#000"
                                color: "#82ca51"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie5Slice5
                                borderColor: "#000"
                                color: "#42a2da"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                    //SKJ011
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        visible: mcPage == 5
                        legend{
                            visible: false
                        }
                        PieSeries {

                            size:0.6
                            holeSize: 0.44;
                            PieSlice {
                                id: pie6Slice1
                                borderColor: "#000"
                                color: "#00fffe"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie6Slice2
                                borderColor: "#000"
                                color: "#e66c31"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie6Slice3
                                borderColor: "#000"
                                color: "#967ddf"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie6Slice4
                                borderColor: "#000"
                                color: "#42a2da"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie6Slice5
                                borderColor: "#000"
                                color: "#82ca51"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                    //SKJ012
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        visible: mcPage == 6
                        legend{
                            visible: false
                        }
                        PieSeries {

                            size:0.6
                            holeSize: 0.44;
                            PieSlice {
                                id: pie7Slice1
                                borderColor: "#000"
                                color: "#e66c31"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie7Slice2
                                borderColor: "#000"
                                color: "#967ddf"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie7Slice3
                                borderColor: "#000"
                                color: "#00fffe"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie7Slice4
                                borderColor: "#000"
                                color: "#42a2da"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie7Slice5
                                borderColor: "#000"
                                color: "#82ca51"
                                label: qsTr("报警")
                                labelVisible: true
                                value: 20
                            }
                        }
                    }
                    //SKJ013
                    ChartView {
                        anchors.fill: parent
                        theme: ChartView.ChartThemeQt
                        antialiasing: true
                        //legend.visible: false
                        animationOptions: ChartView.AllAnimations
                        visible: mcPage == 7
                        legend{
                            visible: false
                        }

                        PieSeries {
                            size:0.6
                            holeSize: 0.44;
                            PieSlice {
                                id: pie8Slice1
                                borderColor: "#000"
                                color: "#967ddf"
                                label: qsTr("离线")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie8Slice2
                                borderColor: "#000"
                                color: "#82ca51"
                                label: qsTr("待机")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie8Slice3
                                borderColor: "#000"
                                color: "#42a2da"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie8Slice4
                                borderColor: "#000"
                                color: "#00fffe"
                                label: qsTr("运行")
                                labelVisible: true
                                value: 20
                            }
                            PieSlice {
                                id: pie8Slice5
                                borderColor: "#000"
                                color: "#e66c31"
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
            color: "#337df8"
            visible: indexPage==2;

            Column{
                id : column2
                width: parent.width
                height: parent.height
                //选择栏
                Rectangle{
                    id: rect3_err
                    width:parent.width
                    height: parent.height * 1/7
                    color: "#337df8"
                    ComboBox {
                        id: err_box
                        width: 450/screenRate
                        height: 100/screenRate
                        anchors.centerIn: parent
                        model: [ "异常运行", "异常待机", "异常报警"]
                        onCurrentIndexChanged: {
                            // 使用信号槽处理显示信息的变化情况
                            if(currentIndex == 0) {
                                mcPage = 0;
                                listview.model = errModel
                            }
                            else if(currentIndex == 1) {
                                mcPage = 1;
                                listview.model = errModel_wait
                            }
                            else if(currentIndex == 2) {
                                mcPage = 2;
                                listview.model = errModel_alarm
                            }
                        }
                    }
                }
                //序号、设备名、异常运行次数列表
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    //color: "#000"
                    //border.color: "#d0d0d0";
                    //border.width: 1;
                    Column {
                        //anchors.margins: 1;
                        width: parent.width
                        anchors.fill: parent;
                        spacing: 0;
                        // 表头
                        Rectangle {
                            width: parent.width;
                            //height: 55/screenRate;
                            height: parent.height * 1/15
                            //height: parent.height
                            color: "#337df8";
                            Row {
                                anchors.topMargin: -1;
                                anchors.leftMargin: 20/screenRate;
                                anchors.rightMargin: 20/screenRate;
                                anchors.fill: parent;
                                spacing: 5/screenRate;
                                //序号
                                Rectangle {
                                    height: parent.height;
                                    //width: (parent.width-5*parent.spacing)/5;
                                    width: parent.width/5
                                    color: "#56BFBF"
                                    Text {
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#000";
                                        font.pixelSize: 42/screenRate;
                                        text: "序号";
                                    }
                                }
                                //设备名
                                Rectangle {
                                    height: parent.height;
                                    //width: (parent.width-5*parent.spacing)/5 * 2;
                                    width: parent.width/5 * 2
                                    color: "#56BFBF"
                                    Text {
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#000";
                                        font.pixelSize: 42/screenRate;
                                        text: "设备名";
                                    }
                                }
                                //异常运行次数
                                Rectangle {
                                    height: parent.height;
                                    //width: (parent.width-5*parent.spacing)/5 * 2;
                                    width: parent.width/5 * 2
                                    color: "#56BFBF"
                                    Text {
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#000";
                                        font.pixelSize: 42/screenRate;
                                        text: "异常运行次数";
                                    }
                                }
                            }
                        }
                        //报表
                        Rectangle {
                            width: parent.width
                            height: parent.height * 14/15
                            color: "#337df8"
                            anchors.topMargin: 50
                            Component.onCompleted: {
                                //console.log(fruitModel.count) // 3
                            }

                            Item {
                                id: item_1
                                height: parent.height
                                width : parent.width
                                anchors.left: parent.left;
                                anchors.leftMargin: 20/screenRate;
                                anchors.right: parent.right;
                                anchors.rightMargin: 10/screenRate;
                                anchors.fill: parent;
                                ListView {
                                    id: listview
                                    anchors.fill: parent
                                    model: errModel
                                    delegate: errDelegate
                                }
                            }

                            ListModel {
                                id: errModel
                                //                                ListElement {
                                //                                    number: "1"
                                //                                    name: "red"
                                //                                    count: 6.45
                                //                                }
                            }
                            ListModel {
                                id: errModel_wait
                            }
                            ListModel{
                                id: errModel_alarm
                            }

                            Component {
                                id: errDelegate
                                Rectangle {
                                    width: item_1.width;
                                    height: 100/screenRate;
                                    //color: colors
                                    Row {
                                        //width: parent.width
                                        //height: parent.height
                                        Text {
                                            //width: parent.width/5 * 1;
                                            width: item_1.width / 5
                                            text: number;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        Text {
                                            width: item_1.width/5 * 2
                                            text: name;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        Text {
                                            width: item_1.width/5 * 2
                                            text: count;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter;
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
            color: "#0c1d3b"
            visible: indexPage==3;
            //选择栏

            Column{
                id : column3
                width: parent.width
                height: parent.height
                //选择栏，换刀数据统计，换料数据统计，加工实效统计
                Rectangle{
                    id: rect4_effort
                    width:parent.width
                    height: parent.height * 1/7
                    color: "#337df8"
                    ComboBox {
                        id: effort_box
                        width: 450/screenRate
                        height: 100/screenRate
                        anchors.centerIn: parent
                        model: ["加工实效统计","换刀数据统计","换料数据统计"]
                        onCurrentIndexChanged: {
                            // 使用信号槽处理显示信息的变化情况
                            if(currentIndex == 0) {
                                mcPage = 0;

                            }
                            else if(currentIndex == 1) {
                                mcPage = 1;
                                listview1.model = staffModel_tool
                                text1.text = "序号"
                                text3.text = "换料次数"

                            }
                            else if(currentIndex == 2) {
                                mcPage = 2;
                                listview1.model = staffModel_material
                                text1.text = "序号"
                                text3.text = "换料次数"
                            }
                        }
                    }
                }

                //加工实效
                Rectangle{
                    width: parent.width;
                    height: parent.height * 6/7
                    visible: mcPage == 0
                    ChartView {
                        //title: ""
                        anchors.fill: parent
                        legend.alignment: Qt.AlignBottom

                        antialiasing: true

                        HorizontalBarSeries {
                            axisY: BarCategoryAxis { categories: operator }
                            BarSet { label: "换刀"; values: [3, 4, 1, 2, 5, 3, 5, 8] }
                            BarSet { label: "换料"; values: [2, 2, 3, 4, 6, 5, 2, 5] }
                        }
                    }
                }

                //换刀次数统计，换料次数统计
                Rectangle {
                    width: parent.width;
                    height: parent.height * 6/7
                    //color: "#000"
                    //border.color: "#d0d0d0";
                    //border.width: 1;
                    visible: mcPage != 0

                    Column {
                        //anchors.margins: 1;
                        width: parent.width
                        anchors.fill: parent;
                        spacing: 0;
                        // 表头
                        Rectangle {
                            width: parent.width;
                            //height: 55/screenRate;
                            height: parent.height * 1/15
                            //height: parent.height
                            color: "#337df8"
                            Row {
                                anchors.topMargin: -1;
                                anchors.leftMargin: 20/screenRate;
                                anchors.rightMargin: 20/screenRate;
                                anchors.fill: parent;
                                spacing: 5/screenRate;
                                //序号
                                Rectangle {
                                    height: parent.height;
                                    //width: (parent.width-5*parent.spacing)/5;
                                    width: parent.width/ 7
                                    color: "#666666"
                                    Text {
                                        id:text1
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#ffffff";
                                        font.pixelSize: 42/screenRate;
                                        text: "序号";
                                    }
                                }
                                //姓名
                                Rectangle {
                                    height: parent.height;
                                    //width: (parent.width-5*parent.spacing)/5 * 2;
                                    width: parent.width/ 7 * 2
                                    color: "#666666"
                                    Text {
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#ffffff";
                                        font.pixelSize: 42/screenRate;
                                        text: "姓名";
                                    }
                                }
                                //换刀次数
                                Rectangle {
                                    height: parent.height;
                                    //width: (parent.width-5*parent.spacing)/5 * 2;
                                    width: parent.width/ 7 * 2
                                    color: "#666666"
                                    Text {
                                        id:text3
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#ffffff";
                                        font.pixelSize: 42/screenRate;
                                        text: "换刀次数";
                                    }
                                }
                                //操作机器
                                Rectangle {
                                    height: parent.height;
                                    //width: (parent.width-5*parent.spacing)/5 * 2;
                                    width: parent.width/ 7 * 2
                                    color: "#666666"
                                    Text {
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#ffffff";
                                        font.pixelSize: 42/screenRate;
                                        text: "操作机器";
                                    }
                                }
                            }
                        }
                        //报表
                        Rectangle {
                            width: parent.width
                            height: parent.height * 14/15
                            color: "#337df8"
                            anchors.topMargin: 50

                            Item {
                                id: item_2
                                height: parent.height
                                width : parent.width
                                anchors.left: parent.left;
                                anchors.leftMargin: 20/screenRate;
                                anchors.right: parent.right;
                                anchors.rightMargin: 10/screenRate;
                                anchors.fill: parent;
                                ListView {
                                    id: listview1
                                    anchors.fill: parent
                                    model: staffModel_tool
                                    delegate: errDelegate1
                                }
                            }
                            ListModel {
                                id: staffModel_tool
                                //                                ListElement {
                                //                                    number: "1"
                                //                                    name: "red"
                                //                                    count: 6.45
                                //                                    mc:"23"
                                //                                }
                            }
                            ListModel {
                                id: staffModel_material
                            }
                            ListModel{
                                id: staffModel_process
                            }

                            Component {
                                id: errDelegate1
                                Rectangle {
                                    width: item_2.width;
                                    height: 100/screenRate;
                                    //color: colors
                                    Row {
                                        //width: parent.width
                                        //height: parent.height
                                        Text {
                                            //width: parent.width/5 * 1;
                                            width: item_2.width / 7
                                            text: number;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        Text {
                                            width: item_2.width/7 * 2
                                            text: name;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        Text {
                                            width: item_2.width/7 * 2
                                            text: count;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter;
                                        }
                                        Text {
                                            width: item_2.width/7 * 2
                                            text: mc;
                                            verticalAlignment: Text.AlignVCenter;
                                            horizontalAlignment: Text.AlignHCenter;
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
    //切换栏
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
                        width: 65/screenRate
                        //anchors.fill: parent;
                        anchors.centerIn: parent;
                        source: indexPage==0 ? "content/inspect_blue.png" : "content/inspect_black.png";

                    }
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            setCurrentFault(0);
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
                        width: 65/screenRate
                        source: indexPage==1 ? "content/mc_blue.png" : "content/mc_black.png";

                    }
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            setCurrentFault(1);
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
                        width: 70/screenRate
                        source: indexPage==2 ? "content/err_blue.png" : "content/err_black.png";

                    }
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            setCurrentFault(2);
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
                        width: 65/screenRate
                        source: indexPage==3 ? "content/staff_blue.png" : "content/staff_black.png";
                    }
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            setCurrentFault(3);
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
                        font.pixelSize: 32/screenRate
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
                        font.pixelSize: 32/screenRate
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
                        font.pixelSize: 32/screenRate
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
                        font.pixelSize: 32/screenRate
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

