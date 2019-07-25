import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs 1.3
import dw.NTCIP  1.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import "content"
import QtCharts 2.0
import dw.TcpClient 1.0

Window {
    id: win
    visible: true
    width: Screen.desktopAvailableWidth;
    height: Screen.desktopAvailableHeight;
    //width: 380
    //height: 640

    property int indexPage: 0;    // 故障代码生成器的页面状态值，确定当前所在的页面
    property int mcPage: 0;
    property string tabSel: "content/tab_selected.png"
    property string tabSeless: "content/tab.png"

    // 屏幕适配标志位
    property real screenRate: (1080/win.width).toFixed(3);

    property var faultPageSts: 0

    property bool flag: false;

    Timer
    {
        id: timer
        onTriggered:
        {
            image2.x = image2.x + 1
            //timer.start(200)
        }
    }

    NTCIP {
        id: ntcip
        property int errorCount: 0
        property int curindex: 0
        onRequestA: {/*label1.text = ip;*/}
        onResponseA: {/*label1.text = "ip: " + ip + " id: " + oid + " cmdtype: " + cmdtype + " data = " + data;
            console.debug(label1.text)*/
        }
        onErrorA: {/*label1.text = "error: " + msg + "\r\n";
            //console.debug("err: " + label1.text)
            errorCount = errorCount + 1*/
        }
    }


    // 设置title
    Rectangle {
        id: rect1_bgImg;
        width:win.width;
        height: 84/screenRate;
        anchors.margins: 10/screenRate;
        color: "#38468A"
        Text {
            anchors.fill: parent;
            //text:"上海贸易学校交通诱导牌v1.0.0";
            text:"模具工厂后台信息";
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            font.pointSize: 12;
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
            visible: indexPage == 0;
            //圆形
            Rectangle {
                id: rect0_state
                width: parent.width
                //height: 450/screenRate
                height : parent.height * 2/7
                color: "#8199E1"
                Image
                {
                    width: 450/screenRate
                    height: 450/screenRate
                    anchors.centerIn: parent
                    source: "content/正常.png"
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                }
            }

            //开机比、上线天数
            Rectangle {
                id: rect2_option;
                width: parent.width;
                height: 120/screenRate;
                anchors.top : rect0_state.bottom;
                color: "#8199E1";

                Row{
                    width: parent.width;
                    height: parent.height;
                    spacing: 30/screenRate;
                    anchors.margins: 30/screenRate;
                    anchors.centerIn: parent;

                    Button {
                        id: setupbt;
                        width: parent.width/2-15;
                        height: 108/screenRate;
                        Text {
                            anchors.centerIn: setupbt;
                            text: qsTr("开机比：5/8");
                            font.pointSize: 12;
                            font.family: "Microsoft YaHei";
                            color:"#000080";
                        }
                    }

                    Button {
                        id: exit;
                        width: parent.width/2-15;
                        height: 108/screenRate;
                        Text {
                            anchors.centerIn: exit;
                            text: qsTr("上线天数：45");
                            font.pointSize: 12;
                            font.family: "Microsoft YaHei";
                            color:"#000080";
                        }
                    }
                }
            }

            //设备实时状态，饼形图
            Rectangle {
                //            anchors.fill: parent
                //            property var othersSlice: 0
                id: rect2_state;
                width: mainRow.width
                height: 1020/screenRate
                color: "#8199E1";
                anchors.top : rect2_option.bottom
                anchors.bottom : real_time.bottom
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

                        PieSlice { id: slice1; label: "运行"; value: 20.0; labelFont.pointSize: 11; }
                        PieSlice { id: slice2; label: "待机"; value: 20.0; labelFont.pointSize: 11; }
                        PieSlice { id: slice3; label: "空转"; value: 20.0; labelFont.pointSize: 11; }
                        PieSlice { id: slice4; label: "离线"; value: 20.0; labelFont.pointSize: 11; }
                        PieSlice { id: slice5; label: "报警"; value: 20.0; labelFont.pointSize: 11; }
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
                        //pieSeries.at(i).borderWidth = 5;
                    }
                }
            }
        }

        //设备效能
        Rectangle {
            id: rect1_effort
            width: parent.width
            //height: 450/screenRate
            height : parent.height
            color: "#8199E1"
            visible: indexPage == 1
            //选择栏
            Column{
                id : column0
                width: parent.width
                height: parent.height
                Rectangle{
                    id: rect1_Box
                    width:parent.width
                    height: parent.height * 1/5
                    color: "#8199E1"
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
                    height: parent.height * 4/5
                    anchors.top: rect1_Box.bottom;
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
    }

    Column{
        id: tab
        width: win.width
        height: 140/screenRate
        anchors.top: mainRow.bottom
        anchors.bottom: win.bottom
        // tab图片切换
        Item{
            anchors.top : tab.top;
            anchors.bottom: tab_word.top;
            //            anchors.topMargin: 50;
            //            width: parent.width; height: 30;
            id: tab_photo;
            width: parent.width;
            height: 90/screenRate;
            //            Rectangle{
            //                anchors.fill: parent;
            //                radius: 5;
            //                color: "#00000000";
            //                width: parent.width;
            //                height: parent.height;
            //            }
            // tab横条
            Row{
                width: parent.width;
                height: parent.height;
                anchors.top : parent.top;
                //实时监控
                Item {
                    width: (parent.width)/4;
                    height: parent.height;
                    //z: indexPage==0 ? 5:4;
                    Image {
                        id: selImg;
                        height: parent.height-4;
                        width: 29
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
                    height: parent.height;
                    //z: indexPage==1 ? 5:3;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height - 4;
                        width: 30
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
                    height: parent.height;
                    //z: indexPage==2 ? 5:2;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height;
                        width: 40
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
                    height: parent.height;
                    //z: indexPage==1 ? 5:3;
                    Image {
                        //anchors.fill: parent;
                        anchors.centerIn: parent
                        height: parent.height - 4;
                        width: 30
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
            anchors.top: tab.photo.bottom
            anchors.bottom: tab.bottom
            //            anchors.topMargin: 50;
            //            width: parent.width; height: 30;
            id: tab_word;
            width: parent.width;
            height: 50/screenRate;
            Row{
                width: parent.width;
                height: parent.height;
                //                anchors.top : parent.top;
                //实时监控
                Item {
                    width: (parent.width)/4;
                    height: parent.height;
                    //z: indexPage==0 ? 5:4;
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
                    //z: indexPage==1 ? 5:3;
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
                    //z: indexPage==2 ? 5:2;

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
                    //z: indexPage==1 ? 5:3;

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


    //        //切换页面
    //        Item{
    //            width: parent.width;
    //            height: 1000/screenRate;
    //            Rectangle{
    //                width: parent.width;
    //                height: 100/screenRate;
    //                color: "#8199E1";
    //            }

    //            //异常加工
    //            Rectangle {
    //                width: parent.width;
    //                height: parent.height;
    //                color: "#8199E1";
    //                visible: indexPage == 1
    //                Column{
    //                    width: parent.width;
    //                    height: parent.height;
    //                    Rectangle {
    //                        width:parent.width;
    //                        height:100/screenRate;
    //                        color:"#8199E1";
    //                        ComboBox {
    //                            width: 200
    //                            model: [ "异常运行", "异常待机", "异常报警"]
    //                            onCurrentIndexChanged: {
    //                                // 使用信号槽处理显示信息的变化情况
    //                                if(currentIndex == 0) {
    //                                    mcPage = 0;
    //                                }
    //                                else if(currentIndex == 1) {
    //                                    mcPage = 1;
    //                                }
    //                                else if(currentIndex == 2) {
    //                                    mcPage = 2;
    //                                }
    //                                else if(currentIndex == 3) {
    //                                    mcPage = 3;
    //                                }
    //                                else if(currentIndex == 4) {
    //                                    mcPage = 4;
    //                                }
    //                                else if(currentIndex == 5) {
    //                                    mcPage = 5;
    //                                }
    //                                else if(currentIndex == 6) {
    //                                    mcPage = 6;
    //                                }
    //                                else if(currentIndex == 7) {
    //                                    mcPage = 7;
    //                                }
    //                            }
    //                        }
    //                    }
    //                    Rectangle {
    //                        width: parent.width;
    //                        height: 800/screenRate;
    //                        color: "#8199E1"
    //                        ChartView {
    //                            anchors.fill: parent
    //                            theme: ChartView.ChartThemeQt
    //                            antialiasing: true
    //                            //legend.visible: false
    //                            animationOptions: ChartView.AllAnimations
    //                            legend{
    //                                    visible: false
    //                                    }
    //                            PieSeries {
    //                                id: pieSeries_err
    //                                holeSize: 0.35;
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#999999"
    //                                    label: qsTr("离线")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#FF6600"
    //                                    label: qsTr("待机")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#F1C40F"
    //                                    label: qsTr("怠速")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#27AE60"
    //                                    label: qsTr("运行")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#C0392B"
    //                                    label: qsTr("报警")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //            //员工绩效
    //            Rectangle {
    //                width: parent.width;
    //                height: parent.height;
    //                color: "#8199E1";
    //                visible: indexPage == 2
    //                Column{
    //                    width: parent.width;
    //                    height: parent.height;
    //                    Rectangle {
    //                        width:parent.width;
    //                        height:100/screenRate;
    //                        color:"#8199E1";
    //                        ComboBox {
    //                            width: 200
    //                            model: [ "换刀数据", "换料数据", "加工实效"]
    //                            onCurrentIndexChanged: {
    //                                // 使用信号槽处理显示信息的变化情况
    //                                if(currentIndex == 0) {
    //                                    mcPage = 0;
    //                                }
    //                                else if(currentIndex == 1) {
    //                                    mcPage = 1;
    //                                }
    //                                else if(currentIndex == 2) {
    //                                    mcPage = 2;
    //                                }
    //                                else if(currentIndex == 3) {
    //                                    mcPage = 3;
    //                                }
    //                                else if(currentIndex == 4) {
    //                                    mcPage = 4;
    //                                }
    //                                else if(currentIndex == 5) {
    //                                    mcPage = 5;
    //                                }
    //                                else if(currentIndex == 6) {
    //                                    mcPage = 6;
    //                                }
    //                                else if(currentIndex == 7) {
    //                                    mcPage = 7;
    //                                }
    //                            }
    //                        }
    //                    }
    //                    Rectangle {
    //                        width: parent.width;
    //                        height: 800/screenRate;
    //                        color: "#8199E1"
    //                        ChartView {
    //                            anchors.fill: parent
    //                            theme: ChartView.ChartThemeQt
    //                            antialiasing: true
    //                            //legend.visible: false
    //                            animationOptions: ChartView.AllAnimations
    //                            legend{
    //                                    visible: false
    //                                    }
    //                            PieSeries {
    //                                id: pieSeries_perfom
    //                                holeSize: 0.35;
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#999999"
    //                                    label: qsTr("离线")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#FF6600"
    //                                    label: qsTr("待机")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#F1C40F"
    //                                    label: qsTr("怠速")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#27AE60"
    //                                    label: qsTr("运行")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                                PieSlice {
    //                                    borderColor: "#000"
    //                                    color: "#C0392B"
    //                                    label: qsTr("报警")
    //                                    labelVisible: true
    //                                    value: 20
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //            Text {
    //                id: targetTemp;
    //                text: "192.168.0.28";
    //                visible: false;
    //            }

    //            Text {
    //                id: ledTemp;
    //                text: "192.168.0.100";
    //                visible: false;
    //            }




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
}

