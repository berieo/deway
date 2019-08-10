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

    property string target_ip: "127.0.0.1"
    property int target_port: 8080

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

