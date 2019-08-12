import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Window 2.0
import dw.TcpClient 1.0
import dw.TcpServer 1.0
import dw.DB 1.0

Window {
    id: root
    x: 20;
    y: 20;
    width: 480;
    height: 320;
    color: "#dcdcdc";
    visible: false;

    property int socket_ptr: 0
    property string local_IP: "127.0.0.1"
    property int local_port: 8080

    // 服务器数据库参数配置及相关参数
    property string dbDriver: "mysql"
    property string hostName: "127.0.0.1"
    //property string hostName: "192.168.1.8"
    property int hostPort: 3306
    //property string loginName: "admin"
    //property string passWord: "admin@$^"
    property string loginName: "root"
    property string passWord: "deway"
    property string dbNameCNC: "bosen_cnc"
    property bool dbCalConnectFlag: false   // 数据库连接标志位
    property bool dbQueConnectFlag: true // 数据库连接标志位

    property int i : 0
    property int j : 0
    property int k : 0
    property int n0 : 0    //全部离线数
    property int n1 : 0    //全部待机数
    property int n2 : 0    //全部怠速数
    property int n3 : 0    //全部运行数
    property int n4 : 0    //全部报警数

    property int m1 : 0      //GSJ005总数
    property int m1_0 : 0    //GSJ005离线数
    property int m1_1 : 0    //GSJ005待机数
    property int m1_2 : 0    //GSJ005怠速数
    property int m1_3 : 0    //GSJ005运行数
    property int m1_4 : 0    //GSJ005报警数

    property int m2 : 0      //GSJ006总数
    property int m2_0 : 0    //GSJ006离线数
    property int m2_1 : 0    //GSJ006待机数
    property int m2_2 : 0    //GSJ006怠速数
    property int m2_3 : 0    //GSJ006运行数
    property int m2_4 : 0    //GSJ006报警数

    property int m3 : 0      //SKJ005总数
    property int m3_0 : 0    //SKJ005离线数
    property int m3_1 : 0    //SKJ005待机数
    property int m3_2 : 0    //SKJ005怠速数
    property int m3_3 : 0    //SKJ005运行数
    property int m3_4 : 0    //SKJ005报警数

    property int m4 : 0      //SKJ006总数
    property int m4_0 : 0    //SKJ006离线数
    property int m4_1 : 0    //SKJ006待机数
    property int m4_2 : 0    //SKJ006怠速数
    property int m4_3 : 0    //SKJ006运行数
    property int m4_4 : 0    //SKJ006报警数

    property int m5 : 0      //SKJ010总数
    property int m5_0 : 0    //SKJ010离线数
    property int m5_1 : 0    //SKJ010待机数
    property int m5_2 : 0    //SKJ010怠速数
    property int m5_3 : 0    //SKJ010运行数
    property int m5_4 : 0    //SKJ010报警数

    property int m6 : 0      //SKJ011总数
    property int m6_0 : 0    //SKJ011离线数
    property int m6_1 : 0    //SKJ011待机数
    property int m6_2 : 0    //SKJ011怠速数
    property int m6_3 : 0    //SKJ011运行数
    property int m6_4 : 0    //SKJ011报警数

    property int m7 : 0      //SKJ012总数
    property int m7_0 : 0    //SKJ012离线数
    property int m7_1 : 0    //SKJ012待机数
    property int m7_2 : 0    //SKJ012怠速数
    property int m7_3 : 0    //SKJ012运行数
    property int m7_4 : 0    //SKJ012报警数

    property int m8 : 0      //SKJ013总数
    property int m8_0 : 0    //SKJ013离线数
    property int m8_1 : 0    //SKJ013待机数
    property int m8_2 : 0    //SKJ013怠速数
    property int m8_3 : 0    //SKJ013运行数
    property int m8_4 : 0    //SKJ013报警数

    //暂设转速为 设定速度/100,进给速度为 设定进给速度/100
    //暂设设定速度为2000,设定进给速度为2000
    //待改进为实际设置速度
    property var setspeed_errRun : 20 // 设定转速/100
    property var setfeedrate_errRun : 20 // 设定进给速度/100

    DB {
        id: dbQuery;
        property var queryhandle;
    }

    Component.onCompleted: {
        initDBServerQuery(loginName,passWord,dbDriver,dbNameCNC);
        text0.text = dbQueConnectFlag

        //开始监听
        tcpserver.listen(local_IP, local_port);
        var ipAddressPool = tcpserver.getLocalIP();
        text2.text += "\n IP地址池：" + ipAddressPool;
    }

    TcpServer{
        id: tcpserver
        onDataComing: {
            text2.text += "\n ip: " + ip + " port: " + port + " data: " + data;
        }
        onNewConnection: {
            socket_ptr = socketptr;
            //需要发送数据的个数
            var sendArr = new Array(100)
            var sendArr_real = new Array(100)
            //查找数据
            var tempSQL, tempFlag;
            var tempSQL1, tempFlag1;

            //设备运行状态
            tempSQL = "select cmnumber,ccurrstate from  tab_cncmodeswitch";
            tempFlag = dbQuery.execQuery(0, tempSQL, 1);
            if(tempFlag === true) {
                var tempArr1 = new Array();
                var tempLen = dbQuery.getNumRowsAffectedQuery(dbQuery.queryhandle);
                if(tempLen > 0) {
                    for(i=0; i<tempLen; i++) {
                        tempArr1[i] = dbQuery.getRowsQuery(dbQuery.queryhandle, i, 1);
                    }
                    //统计所有设备运行情况
                    for(i=0; i<tempLen; i++){
                        if(tempArr1[i][1] === "S0")
                            n0++;
                        else if(tempArr1[i][1] === "S1")
                            n1++;
                        else if(tempArr1[i][1] === "S2")
                            n2++;
                        else if(tempArr1[i][1] === "S3")
                            n3++;
                        else if(tempArr1[i][1] === "S4")
                            n4++;
                    }
                    //统计每个设备
                    for(i=0; i<tempLen; i++){
                        if(tempArr1[i][0] === "GSJ005"){
                            m1++;
                            if(tempArr1[i][1] === "S0")
                                m1_0++;
                            else if(tempArr1[i][1] === "S1")
                                m1_1++;
                            else if(tempArr1[i][1] === "S2")
                                m1_2++;
                            else if(tempArr1[i][1] === "S3")
                                m1_3++;
                            else if(tempArr1[i][1] === "S4")
                                m1_4++;
                        }
                        if(tempArr1[i][0] === "GSJ006"){
                            m2++;
                            if(tempArr1[i][1] === "S0")
                                m2_0++;
                            else if(tempArr1[i][1] === "S1")
                                m2_1++;
                            else if(tempArr1[i][1] === "S2")
                                m2_2++;
                            else if(tempArr1[i][1] === "S3")
                                m2_3++;
                            else if(tempArr1[i][1] === "S4")
                                m2_4++;
                        }
                        if(tempArr1[i][0] === "SKJ005"){
                            m3++;
                            if(tempArr1[i][1] === "S0")
                                m3_0++;
                            else if(tempArr1[i][1] === "S1")
                                m3_1++;
                            else if(tempArr1[i][1] === "S2")
                                m3_2++;
                            else if(tempArr1[i][1] === "S3")
                                m3_3++;
                            else if(tempArr1[i][1] === "S4")
                                m3_4++;
                        }
                        if(tempArr1[i][0] === "SKJ006"){
                            m4++;
                            if(tempArr1[i][1] === "S0")
                                m4_0++;
                            else if(tempArr1[i][1] === "S1")
                                m4_1++;
                            else if(tempArr1[i][1] === "S2")
                                m4_2++;
                            else if(tempArr1[i][1] === "S3")
                                m4_3++;
                            else if(tempArr1[i][1] === "S4")
                                m4_4++;
                        }
                        if(tempArr1[i][0] === "SKJ010"){
                            m5++;
                            if(tempArr1[i][1] === "S0")
                                m5_0++;
                            else if(tempArr1[i][1] === "S1")
                                m5_1++;
                            else if(tempArr1[i][1] === "S2")
                                m5_2++;
                            else if(tempArr1[i][1] === "S3")
                                m5_3++;
                            else if(tempArr1[i][1] === "S4")
                                m5_4++;
                        }
                        if(tempArr1[i][0] === "SKJ011"){
                            m6++;
                            if(tempArr1[i][1] === "S0")
                                m6_0++;
                            else if(tempArr1[i][1] === "S1")
                                m6_1++;
                            else if(tempArr1[i][1] === "S2")
                                m6_2++;
                            else if(tempArr1[i][1] === "S3")
                                m6_3++;
                            else if(tempArr1[i][1] === "S4")
                                m6_4++;
                        }
                        if(tempArr1[i][0] === "SKJ012"){
                            m7++;
                            if(tempArr1[i][1] === "S0")
                                m7_0++;
                            else if(tempArr1[i][1] === "S1")
                                m7_1++;
                            else if(tempArr1[i][1] === "S2")
                                m7_2++;
                            else if(tempArr1[i][1] === "S3")
                                m7_3++;
                            else if(tempArr1[i][1] === "S4")
                                m7_4++;
                        }
                        if(tempArr1[i][0] === "SKJ013"){
                            m8++;
                            if(tempArr1[i][1] === "S0")
                                m8_0++;
                            else if(tempArr1[i][1] === "S1")
                                m8_1++;
                            else if(tempArr1[i][1] === "S2")
                                m8_2++;
                            else if(tempArr1[i][1] === "S3")
                                m8_3++;
                            else if(tempArr1[i][1] === "S4")
                                m8_4++;
                        }
                    }

                    sendArr[0] = tempLen - n0  //开机比分子
                    sendArr[1] = tempLen       //开机比分母

                    sendArr[2] = n0            //全部离线数
                    sendArr[3] = n1            //全部待机数
                    sendArr[4] = n2            //全部怠速数
                    sendArr[5] = n3            //全部运行数
                    sendArr[6] = n4            //全部报警数

                    sendArr[7] = m1            //GSJ005全部设备数
                    sendArr[8] = m1_0          //GSJ005离线数
                    sendArr[9] = m1_1          //GSJ005待机数
                    sendArr[10] = m1_2         //GSJ005怠速数
                    sendArr[11] = m1_3         //GSJ005运行数
                    sendArr[12] = m1_4         //GSJ005报警数

                    sendArr[13] = m2           //GSJ006全部设备数
                    sendArr[14] = m2_0         //GSJ006离线数
                    sendArr[15] = m2_1         //GSJ006待机数
                    sendArr[16] = m2_2         //GSJ006怠速数
                    sendArr[17] = m2_3         //GSJ006运行数
                    sendArr[18] = m2_4         //GSJ006报警数

                    sendArr[19] = m3           //SKJ005全部设备数
                    sendArr[20] = m3_0         //SKJ005离线数
                    sendArr[21] = m3_1         //SKJ005待机数
                    sendArr[22] = m3_2         //SKJ005怠速数
                    sendArr[23] = m3_3         //SKJ005运行数
                    sendArr[24] = m3_4         //SKJ005报警数

                    sendArr[25] = m4           //SKJ006全部设备数
                    sendArr[26] = m4_0         //SKJ006离线数
                    sendArr[27] = m4_1         //SKJ006待机数
                    sendArr[28] = m4_2         //SKJ006怠速数
                    sendArr[29] = m4_3         //SKJ006运行数
                    sendArr[30] = m4_4         //SKJ006报警数

                    sendArr[31] = m5           //SKJ010全部设备数
                    sendArr[32] = m5_0         //SKJ010离线数
                    sendArr[33] = m5_1         //SKJ010待机数
                    sendArr[34] = m5_2         //SKJ010怠速数
                    sendArr[35] = m5_3         //SKJ010运行数
                    sendArr[36] = m5_4         //SKJ010报警数

                    sendArr[37] = m6           //SKJ011全部设备数
                    sendArr[38] = m6_0         //SKJ011离线数
                    sendArr[39] = m6_1         //SKJ011待机数
                    sendArr[40] = m6_2         //SKJ011怠速数
                    sendArr[41] = m6_3         //SKJ011运行数
                    sendArr[42] = m6_4         //SKJ011报警数

                    sendArr[43] = m7           //SKJ012全部设备数
                    sendArr[44] = m7_0         //SKJ012离线数
                    sendArr[45] = m7_1         //SKJ012待机数
                    sendArr[46] = m7_2         //SKJ012怠速数
                    sendArr[47] = m7_3         //SKJ012运行数
                    sendArr[48] = m7_4         //SKJ012报警数

                    sendArr[49] = m8           //SKJ013全部设备数
                    sendArr[50] = m8_0         //SKJ013离线数
                    sendArr[51] = m8_1         //SKJ013待机数
                    sendArr[52] = m8_2         //SKJ013怠速数
                    sendArr[53] = m8_3         //SKJ013运行数
                    sendArr[54] = m8_4         //SKJ013报警数
                }
            }

            //            //异常处理
            var id_errRun = new Array()  //设备编号
            var speed_errRun = new Array()  //设备转速
            var feedrate_errRun = new Array()  //设备进给

            tempSQL1 = "SELECT  lmnumber, lspeed, lfeedrate  FROM bosen_cnc.tab_livedata;";
            tempFlag1 = dbQuery.execQuery(0, tempSQL1, 1);
            if(tempFlag1 === true) {
                var tempArr2 = new Array();
                var tempLen1 = dbQuery.getNumRowsAffectedQuery(dbQuery.queryhandle);

                if(tempLen1 > 0) {

                    for(i=0; i<tempLen1; i++) {
                        tempArr2[i] = dbQuery.getRowsQuery(dbQuery.queryhandle, i, 1);
                    }
                    //统计所有设备运行情况
                    for(i=0,j=0; i<tempLen1; i++){
                        if(tempArr2[i][1] >= (setspeed_errRun * 100 * 1.1) || tempArr2[i][1] <= (setspeed_errRun * 100 * 0.9) || tempArr2[i][2] >= (setfeedrate_errRun * 100 * 1.1) || tempArr2[i][2] <= (setfeedrate_errRun * 100 * 0.9))
                            if(tempArr2[i][0] ===  "Bofsen001"){
                                id_errRun[j] = 1
                                speed_errRun[j] = tempArr2[i][1] / 100
                                feedrate_errRun[j++] = tempArr2[i][2] /100
                            }
                            else if(tempArr2[i][0] === "Bosen002"){
                                id_errRun[j] = 2
                                speed_errRun[j] = tempArr2[i][1] / 100
                                feedrate_errRun[j++] = tempArr2[i][2] / 100
                            }
                            else if(tempArr2[i][0] === "SKJ005"){
                                id_errRun[j] = 3
                                speed_errRun[j] = tempArr2[i][1] / 100
                                feedrate_errRun[j++] = tempArr2[i][2] / 100
                            }
                            else if(tempArr2[i][0] === "SKJ006"){
                                id_errRun[j] = 4
                                speed_errRun[j] = tempArr2[i][1]
                                feedrate_errRun[j++] = tempArr2[i][2]
                            }
                            else if(tempArr2[i][0] === "SKJ010"){
                                id_errRun[j] = 5
                                speed_errRun[j] = tempArr2[i][1] / 100
                                feedrate_errRun[j++] = tempArr2[i][2] / 100
                            }
                            else if(tempArr2[i][0] === "SKJ011"){
                                id_errRun[j] = 6
                                speed_errRun[j] = tempArr2[i][1] / 100
                                feedrate_errRun[j++] = tempArr2[i][2] / 100
                            }
                            else if(tempArr2[i][0] === "SKJ012"){
                                id_errRun[j++] = 7
                                speed_errRun[j] = tempArr2[i][1] / 100
                                feedrate_errRun[j++] = tempArr2[i][2] / 100
                            }
                            else if(tempArr2[i][0] === "SKJ013"){
                                id_errRun[j] = 8
                                speed_errRun[j] = tempArr2[i][1] / 100
                                feedrate_errRun[j++] = tempArr2[i][2] / 100
                            }
                    }

                    for (i=0,k=58;i<j;i++){
                        sendArr[k++] = id_errRun[i]  //机器编号
                        sendArr[k++] = speed_errRun[i]　//该机器错误转速
                        sendArr[k++] = feedrate_errRun[i]　//该机器错误进给
                    }
                }

                text1.text = sendArr[0]
                sendArr[55] = j
                sendArr[56] = setspeed_errRun
                sendArr[57] = setfeedrate_errRun

                if(tcpserver.accecptNewCon(socketptr) === 1){
                    tcpserver.sendToHost(socket_ptr, sendArr.slice(0,58+j*3));
                }
                else{
                    text1.text += "\naccept Fail"
                }
                //初始化
                i = 0
                j = 0
                k = 0
                n0 = 0;
                n1 = 0;
                n2 = 0;
                n3 = 0;
                n4 = 0;
                m1 = 0      //GSJ005总数
                m1_0 = 0    //GSJ005离线数
                m1_1 = 0    //GSJ005待机数
                m1_2 = 0    //GSJ005怠速数
                m1_3 = 0    //GSJ005运行数
                m1_4 = 0    //GSJ005报警数

                m2 = 0      //GSJ006总数
                m2_0 = 0    //GSJ006离线数
                m2_1 = 0    //GSJ006待机数
                m2_2 = 0    //GSJ006怠速数
                m2_3 = 0    //GSJ006运行数
                m2_4 = 0    //GSJ006报警数

                m3 = 0      //SKJ005总数
                m3_0 = 0    //SKJ005离线数
                m3_1 = 0    //SKJ005待机数
                m3_2 = 0    //SKJ005怠速数
                m3_3 = 0    //SKJ005运行数
                m3_4 = 0    //SKJ005报警数

                m4 = 0      //SKJ006总数
                m4_0 = 0    //SKJ006离线数
                m4_1 = 0    //SKJ006待机数
                m4_2 = 0    //SKJ006怠速数
                m4_3 = 0    //SKJ006运行数
                m4_4 = 0    //SKJ006报警数

                m5 = 0      //SKJ010总数
                m5_0 = 0    //SKJ010离线数
                m5_1 = 0    //SKJ010待机数
                m5_2 = 0    //SKJ010怠速数
                m5_3 = 0    //SKJ010运行数
                m5_4 = 0    //SKJ010报警数

                m6 = 0      //SKJ011总数
                m6_0 = 0    //SKJ011离线数
                m6_1 = 0    //SKJ011待机数
                m6_2 = 0    //SKJ011怠速数
                m6_3 = 0    //SKJ011运行数
                m6_4 = 0    //SKJ011报警数

                m7 = 0      //SKJ012总数
                m7_0 = 0    //SKJ012离线数
                m7_1 = 0    //SKJ012待机数
                m7_2 = 0    //SKJ012怠速数
                m7_3 = 0    //SKJ012运行数
                m7_4 = 0    //SKJ012报警数

                m8 = 0      //SKJ013总数
                m8_0 = 0    //SKJ013离线数
                m8_1 = 0    //SKJ013待机数
                m8_2 = 0    //SKJ013怠速数
                m8_3 = 0    //SKJ013运行数
                m8_4 = 0    //SKJ013报警数
            }
        }
    }

    Button {
        id: button1
        x: 99
        y: 37
        text: "开始监听"
        onClicked: {
            tcpserver.listen(local_IP, local_port);
            var ipAddressPool = tcpserver.getLocalIP();
            text2.text += "\n IP地址池：" + ipAddressPool;
        }
    }

    Button {
        id: button2
        x: 251
        y: 37
        text: "回复数据"
        onClicked: {
            var sendString = "16,15";
            tcpserver.sendToHost(socket_ptr, sendString.slice(1,57));
        }
    }

    Text {
        id: text0
        x: 370
        y: 43
        width: 464
        height: 246
        text: qsTr("test")
    }

    Text {
        id: text1
        x: 420
        y: 43
        width: 464
        height: 246
        text: qsTr("test")
    }

    Text {
        id: text2
        x: 8
        y: 66
        width: 464
        height: 246
        text: qsTr("Info")
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 14
    }

    Label {
        id: label1
        x: 192
        y: 8
        width: 96
        height: 28
        text: "TCP服务器端"
        font.pointSize: 16
    }
    //连接数据库
    function initDBServerQuery(vLoginName, vPassWord, vDBDriver, vDBName) {
        dbQuery.addDatabaseDB( vDBDriver );
        dbQuery.setHostNameDB( hostName );
        dbQuery.setPortDB( hostPort );
        dbQuery.setUserNameDB( vLoginName );
        dbQuery.setPasswordDB( vPassWord );
        dbQuery.setDatabaseNameDB( vDBName );
        if(dbQuery.openDB()) {
            dbQuery.queryhandle = dbQuery.createQuery();
            if(dbQuery.queryhandle > 0) {
                dbQueConnectFlag = true;
            }
        }else {
            dbQuery.setConnectOptionsDB();
            dbQuery.closeDB();
            dbQueConnectFlag = false;
        }
    }

}

