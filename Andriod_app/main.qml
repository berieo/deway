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
    property var mcName: ["GSJ005", "GSJ006", "SKJ005", "SKJ006", "SKJ010", "SKJ011", "SKJ012", "SKJ013"]

    //每台设备操作员名称，从0到7与mcName的机器分别对应
    //待改为实际员工对应的机器
    property var staffName: ["吴国兴","赵文峰", "王向前", "陈勇驰", "乔国才", "杨吉", "周定武"]
    property int indexPage: 0;    // 故障代码生成器的页面状态值，确定当前所在的页面
    property int mcPage: 0;       //用于Como
    property string tabSel: "content/tab_selected.png"
    property string tabSeless: "content/tab.png"

    //计数器
    property int i: 0
    property int k: 0

    //开机比
    property var rate1: 1
    property var rate2: 2

    //设备状态图,各种设备运行、待机、怠速、离线、报警数据
    property int value1: 2   //离线总数
    property int value2: 2   //待机总数
    property int value3: 3   //怠速总数
    property int value4: 4   //运行总数
    property int value5: 1   //报警总数

    property int m1: 12
    property int m1_0: 4
    property int m1_1: 2
    property int m1_2: 3
    property int m1_3: 2
    property int m1_4: 1

    property int m2: 12
    property int m2_0: 1
    property int m2_1: 3
    property int m2_2: 2
    property int m2_3: 4
    property int m2_4: 2

    property int m3: 12
    property int m3_0: 3
    property int m3_1: 1
    property int m3_2: 2
    property int m3_3: 4
    property int m3_4: 1

    property int m4: 12
    property int m4_0: 3
    property int m4_1: 4
    property int m4_2: 2
    property int m4_3: 2
    property int m4_4: 1

    property int m5: 12
    property int m5_0: 1
    property int m5_1: 2
    property int m5_2: 2
    property int m5_3: 3
    property int m5_4: 4

    property int m6: 12
    property int m6_0: 1
    property int m6_1: 4
    property int m6_2: 2
    property int m6_3: 3
    property int m6_4: 2

    property int m7: 12
    property int m7_0: 4
    property int m7_1: 3
    property int m7_2: 2
    property int m7_3: 2
    property int m7_4: 1

    property int m8: 12
    property int m8_0: 3
    property int m8_1: 1
    property int m8_2: 2
    property int m8_3: 2
    property int m8_4: 4

    property int j: 0
    property int setspeed_errRun: 0
    property int setfeedrate_errRun: 0

    // 屏幕适配标志位
    property real screenRate: (1080/win.width).toFixed(3);

    //TCP连接
    property string target_ip: "127.0.0.1"
    property int target_port: 8080

    //显示日期
    Timer {
        interval: 500;
        running: true;
        repeat: true;
        onTriggered: time.text = Qt.formatDateTime(new Date(), "yyyy年MM月dd日 hh:mm dddd")
        // 星期 年份 月份 号 大月份
    }

    //从后端获取数据，获取后处理
    TcpClient
    {
        id: tcpclient
        onDataComing: {
            //text1.text += " \nip: " + ip + " \nport: " + port + " \ndata: " + data
            var id_errRun = new Array()         //设备编号数组
            var speed_errRun = new Array()      //设备转速数组
            var feedrate_errRun = new Array()   //设备进给数组
            rate1 = data[0]   //运行设备分子
            rate2 = data[1]   //所有设备数

            value1 = data[2]  //全部离线数
            value2 = data[3]　//全部待机数
            value3 = data[4]　//全部怠速数
            value4 = data[5]　//全部运行数
            value5 = data[6]　//全部报警数

            m1 = data[7]      //GSJ005全部设备数
            m1_0 = data[8]　  //GSJ005离线数
            m1_1 = data[9]　  //GSJ005待机数
            m1_2 = data[10]　 //GSJ005怠速数
            m1_3 = data[11]　 //GSJ005运行数
            m1_4 = data[12]　 //GSJ005报警数

            m2 = data[13]     //GSJ006全部设备数
            m2_0 = data[14]　 //GSJ006离线数
            m2_1 = data[15]　 //GSJ006待机数
            m2_2 = data[16]　 //GSJ006怠速数
            m2_3 = data[17]　 //GSJ006运行数
            m2_4 = data[18]　 //GSJ006报警数

            m3 = data[19]     //SKJ005全部设备数
            m3_0 = data[20]　 //SKJ005离线数
            m3_1 = data[21]　 //SKJ005待机数
            m3_2 = data[22]　 //SKJ005怠速数
            m3_3 = data[23]　 //SKJ005运行数
            m3_4 = data[24]　 //SKJ005报警数

            m4 = data[25]     //SKJ006全部设备数
            m4_0 = data[26]　 //SKJ006离线数
            m4_1 = data[27]　 //SKJ006待机数
            m4_2 = data[28]　 //SKJ006怠速数
            m4_3 = data[29]　 //SKJ006运行数
            m4_4 = data[30]　 //SKJ006报警数

            m5 = data[31]     //SKJ010全部设备数
            m5_0 = data[32]　 //SKJ010离线数
            m5_1 = data[33]　 //SKJ010待机数
            m5_2 = data[34]　 //SKJ010怠速数
            m5_3 = data[35]　 //SKJ010运行数
            m5_4 = data[36]　 //SKJ010报警数

            m6 = data[37]     //SKJ011全部设备数
            m6_0 = data[38]　 //SKJ011离线数
            m6_1 = data[39]　 //SKJ011待机数
            m6_2 = data[40]　 //SKJ011怠速数
            m6_3 = data[41]　 //SKJ011运行数
            m6_4 = data[42]　 //SKJ011报警数

            m7 = data[43]     //SKJ012全部设备数
            m7_0 = data[44]　 //SKJ012离线数
            m7_1 = data[45]　 //SKJ012待机数
            m7_2 = data[46]　 //SKJ012怠速数
            m7_3 = data[47]　 //SKJ012运行数
            m7_4 = data[48]　 //SKJ012报警数

            m8 = data[49]     //SKJ013全部设备数
            m8_0 = data[50]　 //SKJ013离线数
            m8_1 = data[51]　 //SKJ013待机数
            m8_2 = data[52]　 //SKJ013怠速数
            m8_3 = data[53]　 //SKJ013运行数
            m8_4 = data[54]　 //SKJ013报警数

            j = data[55]
            setspeed_errRun = data[56]        //机器设定速度
            setfeedrate_errRun = data[57]     //机器设定进给速度

            for (i=0,k=58;i<j;i++){
                id_errRun[i] = data[k++]        //机器编号
                speed_errRun[i] = data[k++]     //机器错误转速
                feedrate_errRun[i] = data[k++]  //机器错误进给
            }

            //异常加工页面数据设定，异常运行为运行数，异常待机为待机数，异常报警为报警数
            //异常运行、异常待机待更改
            for (i=0,k=11;i<8;i++){
                runView.model.append({"number":i,"name":mcName[i],"account":data[k]})
                waitView.model.append({"number":i,"name":mcName[i],"account":data[k-2]})
                errView.model.append({"number":i,"name":mcName[i],"account":data[k+1]})
                k += 6
            }
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
            id: title
            anchors.fill: parent;
            text:"模具工厂后台信息";
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            font.pointSize: 14/screenRate;
            color: "white";
        }
    }

    //主体部分，tab切换仅切换主体
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
                        text: rate1 + "/" + rate2
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

            //显示当前时间
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
                id: rect2_state;
                width: mainRow.width
                height: parent.height*15/30
                anchors.top : rect0_alart.bottom
                //五个标签，显示具体数字
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
                                    text: value1
                                    font.pointSize: 15/screenRate
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
                                    font.pointSize: 14/screenRate
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
                                    text: value2
                                    font.pointSize: 15/screenRate
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
                                    font.pointSize: 14/screenRate
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
                                    text: value3
                                    font.pointSize: 15/screenRate
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
                                    font.pointSize: 14/screenRate
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
                                    text: value4
                                    font.pointSize: 15/screenRate
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
                                    font.pointSize: 14/screenRate
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
                                    text: value5
                                    font.pointSize: 15/screenRate
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
                                    font.pointSize: 14/screenRate
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
                    ChartView {
                        id: chart
                        anchors.fill: parent
                        legend.visible: false   // 是否显示
                        antialiasing: true
                        PieSeries {
                            id: pieSeries
                            size: 1.0
                            PieSlice { id: slice1; label: "运行"; value: value4; labelFont.pointSize: 11; color:stsColorArr[3]}
                            PieSlice { id: slice2; label: "报警"; value: value5; labelFont.pointSize: 11; color:stsColorArr[4]}
                            PieSlice { id: slice3; label: "离线"; value: value1; labelFont.pointSize: 11; color:stsColorArr[0]}
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

            Column{
                id : column0
                width: parent.width
                height: parent.height
                //选择栏
                Rectangle{
                    id: rect1_Box
                    width:parent.width
                    height: parent.height/7
                    color: "#000070"
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

                //主体部分

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
                                value: m1_0
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: m1_1
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: m1_2
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: m1_3
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: m1_4
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
                                value: m2_0
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: m2_1
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: m2_2
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: m2_3
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: m2_4
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
                                value: m3_0
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: m3_1
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: m3_2
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: m3_3
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: m3_4
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
                                value: m4_0
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: m4_1
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: m4_2
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: m4_3
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: m4_4
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
                                value: m5_0
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: m5_1
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: m5_2
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: m5_3
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: m5_4
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
                                value: m6_0
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: m6_1
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: m6_2
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: m6_3
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: m6_4
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
                                value: m7_0
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: m7_1
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: m7_2
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: m7_3
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: m7_4
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
                                value: m8_0
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#FF6600"
                                label: qsTr("待机")
                                labelVisible: true
                                value: m8_1
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#F1C40F"
                                label: qsTr("怠速")
                                labelVisible: true
                                value: m8_2
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#27AE60"
                                label: qsTr("运行")
                                labelVisible: true
                                value: m8_3
                            }
                            PieSlice {
                                borderColor: "#000"
                                color: "#C0392B"
                                label: qsTr("报警")
                                labelVisible: true
                                value: m8_4
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

            Column{
                id : column2
                width: parent.width
                height: parent.height
                //选择栏
                Rectangle{
                    id: rect3_err
                    width:parent.width
                    height: parent.height * 1/7
                    color: "#000070"
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
                                err_table.text = "异常运行次数"
                            }
                            else if(currentIndex == 1) {
                                mcPage = 1;
                                err_table.text = "异常待机次数"

                            }
                            else if(currentIndex == 2) {
                                mcPage = 2;
                                err_table.text = "异常报警次数"
                            }
                        }
                    }
                }

                //列表部分
                Rectangle{
                    width: parent.width * 95 / 100
                    height: parent.height * 6/7
                    anchors.horizontalCenter: parent.horizontalCenter   //水平居中
                    color:"#000070"
                    Column {
                        anchors.margins: 1;
                        anchors.fill: parent;
                        spacing: 0;
                        // 表头
                        Rectangle {
                            width: parent.width;
                            height: 90/screenRate;
                            color: "#000070";
                            Row {
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
                                        font.pixelSize: 35/screenRate;
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
                                        font.pixelSize: 35/screenRate;
                                        text: "设备名";
                                    }
                                }
                                Rectangle {
                                    height: parent.height;
                                    width: parent.width * 2/5
                                    color: "#666666"
                                    Text {
                                        id: err_table
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Microsoft YaHei";
                                        color: "#ffffff";
                                        font.pixelSize: 35/screenRate;
                                        text: "异常运行次数";
                                    }
                                }
                            }
                        }
                        //异常运行次数报表
                        Item {
                            width: parent.width;
                            height: parent.height - 90/screenRate
                            visible: mcPage == 0  ? true : false
                            Rectangle {
                                width: parent.width;
                                height: parent.height
                                color:"#000070"
                                ListModel {
                                    id: runModel
//                                    ListElement {
//                                        number: 1
//                                        name: "GSJ005"
//                                        account: 3
//                                    }
                                }

                                Component {
                                    id: runDelegate
                                    Row {
                                        id: run
                                        width:parent.width
                                        height: 100/screenRate
                                        spacing: 10/screenRate;
                                        Rectangle{
                                            width: parent.width * 1 / 5
                                            height: parent.height
                                            Text {
                                                text: "     " + number;
                                            }
                                        }
                                        Rectangle{
                                            width: parent.width * 2 / 5
                                            height: parent.height
                                            Text {
                                                text: "        " + name
                                            }
                                        }
                                        Rectangle{
                                            width: parent.width * 2 / 5
                                            height: parent.height
                                            Text {
                                                text: "            " + account
                                            }
                                        }
                                    }
                                }

                                ListView {
                                    id:runView
                                    property color run_color: "green"
                                    model: runModel
                                    delegate: runDelegate
                                    anchors.fill: parent
                                }
                            }

                        }
                        //异常待机次数报表
                        Item {
                            width: parent.width;
                            height: parent.height - 90/screenRate
                            visible: mcPage == 1 ? true : false
                            Rectangle {
                                width: parent.width;
                                height: parent.height
                                color:"#000070"
                                ListModel {
                                    id: waitModel
                                    //                                    ListElement {
                                    //                                        number: 1
                                    //                                        name: "GSJ005"
                                    //                                        account: 3
                                    //                                    }
                                }

                                Component {
                                    id: waitDelegate
                                    Row {
                                        id: wait
                                        width:parent.width
                                        height: 100/screenRate
                                        spacing: 10/screenRate;
                                        Rectangle{
                                            width: parent.width * 1 / 5
                                            height: parent.height
                                            Text {
                                                text: "     " + number;
                                            }
                                        }
                                        Rectangle{
                                            width: parent.width * 2 / 5
                                            height: parent.height
                                            Text {
                                                text: "        " + name
                                            }
                                        }
                                        Rectangle{
                                            width: parent.width * 2 / 5
                                            height: parent.height
                                            Text {
                                                text: "            " + account
                                            }
                                        }
                                    }
                                }
                                ListView {
                                    id: waitView
                                    model: waitModel
                                    delegate: waitDelegate
                                    anchors.fill: parent

                                }
                            }

                        }
                        //异常报警次数报表
                        Item {
                            width: parent.width;
                            height: parent.height - 90/screenRate
                            visible: mcPage == 2 ? true : false
                            Rectangle {
                                width: parent.width;
                                height: parent.height
                                color:"#000070"
                                ListModel {
                                    id: errModel
                                    //                                    ListElement {
                                    //                                        number: 1
                                    //                                        name: "GSJ005"
                                    //                                        account: 3
                                    //                                    }
                                }
                                Component {
                                    id: errDelegate
                                    Row {
                                        id: err
                                        width:parent.width
                                        height: 100/screenRate
                                        spacing: 10/screenRate;
                                        Rectangle{
                                            width: parent.width * 1 / 5
                                            height: parent.height
                                            Text {
                                                text: "     " + number;
                                            }
                                        }
                                        Rectangle{
                                            width: parent.width * 2 / 5
                                            height: parent.height
                                            Text {
                                                text: "        " + name
                                            }
                                        }
                                        Rectangle{
                                            width: parent.width * 2 / 5
                                            height: parent.height
                                            Text {
                                                text: "            " + account
                                            }
                                        }
                                    }
                                }
                                ListView {
                                    id: errView
                                    model: errModel
                                    delegate: errDelegate
                                    anchors.fill: parent
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

            Column{
                id : column3
                width: parent.width
                height: parent.height

                //选择栏
                Rectangle{
                    id: rect4_effort
                    width:parent.width
                    height: parent.height * 1/7
                    color: "#000070"
                    ComboBox {
                        id: effort_box
                        width: 450/screenRate
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
                        }
                    }
                }

                //数据显示部分
                //换刀数据统计，数据是固定的，从数据库读取待做
                Rectangle{
                    width: parent.width
                    height: parent.height * 6/7
                    anchors.horizontalCenter: parent.horizontalCenter   //水平居中
                    color:"#000070"
                    visible: mcPage == 0 ? true : false
                    ChartView {
                        //title: "Horizontal Bar series"
                        anchors.fill: parent
                        legend.alignment: Qt.AlignBottom
                        antialiasing: true
                        HorizontalBarSeries {
                            axisY: BarCategoryAxis { categories: ["吴国兴","赵文峰", "王向前", "陈勇驰", "乔国才", "杨吉", "周定武"]}
                            BarSet { label: "换刀"; values: [5, 2, 5, 6, 4, 3, 2, 2, ]; color: stsColorArr[1] }
                            BarSet { label: "换料"; values: [8, 5, 3, 5, 2, 1, 4, 3]; color: stsColorArr[3] }
                        }
                    }
                }
                //换料数据统计
                Rectangle{
                    width: parent.width
                    height: parent.height * 6/7
                    color:"#000070"
                    visible: mcPage == 1 ? true : false
                    // 表头
                    Rectangle {
                        width: parent.width * 92 / 100;
                        height: 90/screenRate;
                        anchors.horizontalCenter: parent.horizontalCenter   //水平居中
                        color: "#000070";
                        Row {
                            width:parent.width
                            height: parent.height
                            spacing: 10/screenRate;
                            Rectangle {
                                height: parent.height;
                                width: parent.width * 1/6
                                color: "#666666"
                                Text {
                                    anchors.fill: parent;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Microsoft YaHei";
                                    color: "#ffffff";
                                    font.pixelSize: 32/screenRate;
                                    text: "序号";
                                }
                            }
                            Rectangle {
                                height: parent.height;
                                width: parent.width * 1/6
                                color: "#666666"
                                Text {
                                    anchors.fill: parent;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Microsoft YaHei";
                                    color: "#ffffff";
                                    font.pixelSize: 32/screenRate;
                                    text: "姓名";
                                }
                            }
                            Rectangle {
                                height: parent.height;
                                width: parent.width * 2/6
                                color: "#666666"
                                Text {
                                    anchors.fill: parent;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Microsoft YaHei";
                                    color: "#ffffff";
                                    font.pixelSize: 32/screenRate;
                                    text: "换料次数";
                                }
                            }
                            Rectangle {
                                height: parent.height;
                                width: parent.width * 2/6
                                color: "#666666"
                                Text {
                                    anchors.fill: parent;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Microsoft YaHei";
                                    color: "#ffffff";
                                    font.pixelSize: 32/screenRate;
                                    text: "操作机器";
                                }
                            }
                        }
                    }
                    // 报表
                    Item {
                        width: parent.width;
                        height: parent.height - 70/screenRate
                        Rectangle{
                            //anchors.margins: 2;
                            //anchors.fill: parent;
                            color: "#dcdcdc"
                            ListView {

                            }
                        }

                    }                }
                //加工实效统计
                Rectangle{
                    width: parent.width
                    height: parent.height * 6/7
                    anchors.horizontalCenter: parent.horizontalCenter   //水平居中
                    color:"#000070"
                    visible: mcPage == 2 ? true : false
                    // 表头
                    Rectangle {
                        width: parent.width * 92 / 100;
                        height: 90/screenRate;
                        anchors.horizontalCenter: parent.horizontalCenter   //水平居中
                        color: "#000070";
                        Row {
                            width:parent.width
                            height: parent.height
                            spacing: 10/screenRate;
                            Rectangle {
                                height: parent.height;
                                width: parent.width * 1/6
                                color: "#666666"
                                Text {
                                    anchors.fill: parent;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Microsoft YaHei";
                                    color: "#ffffff";
                                    font.pixelSize: 32/screenRate;
                                    text: "序号";
                                }
                            }
                            Rectangle {
                                height: parent.height;
                                width: parent.width * 1/6
                                color: "#666666"
                                Text {
                                    anchors.fill: parent;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Microsoft YaHei";
                                    color: "#ffffff";
                                    font.pixelSize: 32/screenRate;
                                    text: "姓名";
                                }
                            }
                            Rectangle {
                                height: parent.height;
                                width: parent.width * 2/6
                                color: "#666666"
                                Text {
                                    anchors.fill: parent;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Microsoft YaHei";
                                    color: "#ffffff";
                                    font.pixelSize: 32/screenRate;
                                    text: "加工次数";
                                }
                            }
                            Rectangle {
                                height: parent.height;
                                width: parent.width * 2/6
                                color: "#666666"
                                Text {
                                    anchors.fill: parent;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Microsoft YaHei";
                                    color: "#ffffff";
                                    font.pixelSize: 32/screenRate;
                                    text: "操作机器";
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

                            }
                        }

                    }

                }
            }
        }
    }

    //tabbar部分
    Column{
        id: tab
        width: win.width
        height: 150/screenRate
        anchors.top: mainRow.bottom
        anchors.bottom: win.bottom

        //tab图片切换
        Item{
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
            id: tab_word;
            width: parent.width;
            height: parent.height/8;
            Row{
                width: parent.width;
                height: parent.height;
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

    //tab切换函数
    function setCurrentFault(index)
    {
        indexPage = index;
    }

}

