import QtQuick 2.0
import QtQuick.Controls 1.0
import dw.TcpClient 1.0
import QtQuick.Window 2.0

Window {
    id: root
    x: 20;
    y: 20;
    width: 480;
    height: 320;
    color: "#dcdcdc";
    visible: true;

    //本地连接
    property string target_ip: "127.0.0.1"
    property int target_port: 8080

    //局域网内连接
//    property string target_ip: "192.168.1.5"
//    property int target_port: 9212

    //云服务器连接
//      property string target_ip: "47.99.223.66"
//      property int target_port: 9212

    TcpClient
    {
        id: tcpclient
        onDataComing: {
            text1.text += " \nip: " + ip + " \nport: " + port + " \ndata: " + data
        }
        onStatusReport: {
            text1.text += "\nStatusReport:" + msg;
        }
    }

    Component.onCompleted: {
        console.log("The jumped over tall buildings");
        tcpclient.connectToHost(target_ip, target_port, 0);
    }


    Button {
        id: button1
        x: 99
        y: 37
        text: "建立连接"
        onClicked: {
            tcpclient.connectToHost(target_ip, target_port, 0);
        }
    }

    Button {
        id: button2
        x: 314
        y: 37
        text: "发送数据"
        onClicked: {
            var sendString = "Hello TCPServer!";
            tcpclient.send(sendString);
        }
    }

    Text {
        id: text1
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
        text: "TCP客户端"
        font.pointSize: 16
    }
}

