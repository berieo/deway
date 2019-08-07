import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.0

import dw.Linux.V4L2 1.0
import dw.OpenCV.CVImgCodecs 1.0
import dw.CameraCalibration 1.0
import dw.OpenCV.ImgProc.CVImgProc 1.0


Window {
    visible: true
    width: 800
    height:600

    Timer
    {
        id: timer
        interval : 0
        onTriggered:
        {
            captureandshow()
            timer.start()
        }
    }

    //    CameraCalibration
    //    {
    //        id: cali
    //        onError: label2.text = "cali error: " + msg + "\r\n"
    //    }

    //    CVImgCodecs
    //    {
    //        id: codecs
    //    }

    CVImgProc
    {
        id: imgproc
    }

    V4L2
    {
        id: v4l2
        visible:  true
        x: 46
        y: 83
        width: 481
        height: 394
        property  int ptr: 0
        property int size: 0
        property int loadconfig: 0
        property int shot_a_cali: 0
        property int valid_count: 0
        property var cali_show_pic
        onStatusReport:  label1.text += label1.text + " " + msg;
    }

    //Open Camera
    Button {
        id: button
        x: 591
        y: 191
        width: 139
        height: 40
        text: qsTr("打开相机")
        enabled : true
        onClicked:
        {
            button.enabled=false;
            if(v4l2.openCamera("/dev/video0", 0, 0) >= 0)
                //if(v4l2.openCamera("/dev/video0", 0, 1) >= 0)
                label2.text += "open ok\r\n";
            else
                label2.text += "open fail\r\n";
            //label2.text = "cap: " +  v4l2.ioctlCamera("VIDIOC_QUERYCAP", 0);
            //label2.text = "cap: " +  v4l2.ioctlCamera("VIDIOC_QUERYSTD", 0);

            //label1.text = "cap: "

            if(v4l2.setFMT(640,480,"V4L2_PIX_FMT_YUYV") >= 0)
                //if(v4l2.setFMT(640,480,"V4L2_PIX_FMT_MJPEG") >=0)
                label2.text += "set fmt ok\r\n"
            else
                label2.text += "set fmt fail\r\n"

            if(v4l2.setFPS(30) >= 0)
                //if(v4l2.setFMT(640,480,"V4L2_PIX_FMT_MJPEG") >=0)
                label2.text += "set fps ok\r\n"
            else
                label2.text += "set fps fail\r\n"
            if(v4l2.setNMAP(4) >= 0)
                //if(v4l2.setFMT(640,480,"V4L2_PIX_FMT_MJPEG") >=0)
                label2.text += "set nmap ok\r\n"
            else
                label2.text += "set nmap fail\r\n"
            if(v4l2.startCapturing() >= 0)
                //if(v4l2.setFMT(640,480,"V4L2_PIX_FMT_MJPEG") >=0)
            {
                label2.text += "start caputuring ok\r\n"
                capture.enabled = true
            }
            else
                label2.text += "start caputuring fail\r\n"

            timer.start()
            //captureandshow()
        }
    }


    //    Button {
    //        id: cali_shot
    //        x: 515
    //        y: 320
    //        width: 147
    //        height: 40
    //        text: qsTr("Calibration")
    //        enabled: false
    //        onClicked:
    //        {
    //            v4l2.shot_a_cali = 1
    //        }
    //    }


    //Capture
    Button {
        id: capture
        x: 591
        y: 299
        width: 139
        height: 40
        text: qsTr("捕捉画面")
        enabled: false
        onClicked:
        {
            /*f(timerck.checked)
            {
                timer.start()
            }
            else*/
            timer.stop()
            captureandshow()
            //timer.start()

//            v4l2.ptr = v4l2.getFrame()
//            if(v4l2.ptr == 0)
//                label1.text += " getframe fail"  //读取失败
//            else
//                label1.text = " getframe= " + ptr //读取成功
        }
    }

    //    CheckBox {
    //        id: timerck
    //        x: 515
    //        y: 86
    //        text: qsTr("Timer")
    //    }

    //    Button {
    //        id: loadconfig
    //        x: 515
    //        y: 177
    //        text: qsTr("Load config file")
    //        onClicked:
    //        {
    //            if(cali.loadCalibrationConfigFile() === 0)
    //                cali_shot.enabled = true
    //            //label2.text += "node: " + cali.readConfigNode("BoardSize_Width") + "\r\n"
    //        }
    //    }
    Label{
        id: label1
        x:15
        y: 530
        width: 481
        height: 70
    }

    Label {
        id: label2
        x: 40
        y: 503
        width: 481
        height: 70
    }

    Label {
        id: label3
        x: 22
        y: 425
        width: 474
        height: 52
        wrapMode: Text.WrapAnywhere
    }

    function captureandshow()
    {
        v4l2.ptr = v4l2.getFrame()
        if(v4l2.ptr == 0)
            label2.text += "  getframe fail"
        else
            label2.text = " getframe= " + v4l2.ptr
        if(v4l2.setFrameforDisplay(v4l2.ptr) < 0)
            label2.text = "  setDisplay fail"
        else
        {
            if(v4l2.shot_a_cali == 1)
            {
                v4l2.cali_show_pic = codecs.createMat()
                //                if(cali.checkCalibration(v4l2.ptr, v4l2.cali_show_pic) >= 0)
                //                {
                label3.text = "This picture is ok for calibration\r\n"
                var cali_filename = "cali_" + v4l2.valid_count + ".png\r\n"
                label3.text += "cali_filename: " + cali_filename + "\r\n"
                //cali.saveCalibrationPICToDir(v4l2.ptr, cali_filename)
                //cali.saveCalibrationPICToDir(v4l2.cali_show_pic, cali_filename)

                //                }
                //                else
                //                    label3.text = "This picture is not valid for calibration, do it again\r\n"
                v4l2.shot_a_cali = 0;
                codecs.freeMat(v4l2.cali_show_pic)
            }
        }
        v4l2.freeFrame(v4l2.ptr)
    }

}

