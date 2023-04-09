import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.3
import QtMultimedia

Window {
    width: 600
    height: 500
    visible: true
    title: qsTr("Alarm Clock")
    property string date: Qt.formatTime(new Date(),"hh:mm")
    property int clickTimeHrs: 0
    property int hrsCount: 0
    property int minCount: 0
    property string alarm: ""
    property int snoozeValue: 5
    property string hour: Qt.formatTime(new Date(),"hh")
    property string mins: Qt.formatTime(new Date(),"mm")
    property bool soundPlay: false
    property int exitTimeCount: 0

    SoundEffect {
        id: sound
        source: "sound.wav"
    }

    Label {
        height: 95
        width: 375
        x: 120
        y: 120
        id: timeText
        font.pixelSize: 80
        text: date
        horizontalAlignment: Text.AlignHCenter
        background: Rectangle {
            border.width: 1.5
            border.color: "lightGray"
            radius: 20
            gradient: Gradient {
                GradientStop { position: 0; color: "#ffffff"; }
                GradientStop { position: 0.1; color: "#f0f0f0"; }
                GradientStop { position: 0.5; color: "#d0d0d0"; }
                GradientStop { position: 0.9; color: "#f0f0f0"; }
                GradientStop { position: 1; color: "#ffffff"; }
            }
        }
    }


    Timer {
        id: timer
        interval: 1000
        repeat: true
        running: true

        onTriggered:{
            date =  Qt.formatTime(new Date(),"hh:mm")
            hour = Qt.formatTime(new Date(),"hh")
            mins = Qt.formatTime(new Date(),"mm")

            console.log("alarm" + alarm)
            console.log("current time" + date)

            if(!soundPlay){
                if(date == alarm) {
                    sound.play();
                    soundPlay = true;
                }
            }
        }    
    }

    Timer {
        id:exitTimer
        interval: 1000
        repeat: true
        running: false

        onTriggered: {
            exitTimeCount++
            if(exitTimeCount == 20){
                exitTimeCount = 0;
                blinkHrs.stop();
                blinkMin.stop();
                timeSystem.stop();
                snoozeTime.stop();
                setsnooze.visible = false;
                setTimeSystem.visible = false;
                setAlarm.visible = false;
            }
        }
    }

    Row {
        x: 115
        y: 235

        Button {
            id:downButton
            text: qsTr("Down")

            onPressAndHold: {
                exitTimeCount = 0;
                exitTimer.stop();
                if(clickTimeHrs == 1){
                    deaccelerateHrs.start();
                }else if(clickTimeHrs == 2){
                    deaccelerateMin.start();
                }else if(clickTimeHrs == 5){
                    deaccelerateSnoozeValue.start();
                }
            }

            onReleased: {
                exitTimer.start();
                if(clickTimeHrs == 1){
                    deaccelerateHrs.stop();
                }else if(clickTimeHrs == 2) {
                    deaccelerateMin.stop();
                }else if(clickTimeHrs == 5){
                    accelerateSnoozeValue.stop();
                }
            }

            onClicked: {

                exitTimeCount = 0;

                if(soundPlay) {
                    sound.stop();
                    soundPlay = false;
                }

                if(clickTimeHrs == 1) {
                    if(hrsCount > 0) {
                        hrsCount--;
                        hrs.text = hrsCount;
                    }else {
                        hrsCount = 23;
                        hrs.text = hrsCount;
                    }
                }else if(clickTimeHrs == 2) {
                    if(minCount > 0) {
                        minCount--;
                        min.text = minCount;
                    }else {
                        minCount = 59;
                        min.text = minCount;
                    }
                }else if(clickTimeHrs == 5){
                    if(snoozeValue > 5) {
                        snoozeValue--;
                        snooze.text = snoozeValue;
                    } else {
                        snoozeValue = 60;
                        snooze.text = snoozeValue;
                    }
                }
            }
        }

        Button {
            id:shutRadioButton
            text: qsTr("ShutAlarm")

           onClicked: {
               exitTimeCount = 0;
               alarm = "";
               if(soundPlay) {
                   sound.stop();
                   soundPlay = false;
               }
            }
        }

        Button {
            id:snooseButton
            text: qsTr("Snooze")

            onClicked: {
                exitTimeCount = 0;
                if(soundPlay) {
                    sound.stop();
                    soundPlay = false;
                }

                if (parseInt(hour) >= 10 && parseInt(hour) < 23){
                    if(parseInt(mins) >= 5 && parseInt(mins) + snoozeValue <= 59){
                        alarm = hour + ":" + (parseInt(mins) + snoozeValue).toString();
                    }else if (parseInt(mins) < 5) {
                        alarm = hour + ":" + "0" + (parseInt(mins) + snoozeValue).toString();
                    }else if (parseInt(mins) + snoozeValue >= 60) {
                        if((parseInt(mins) + snoozeValue)-60 < 10){
                            alarm =(parseInt(hour)+1).toString() + ":" + "0" + ((parseInt(mins) + snoozeValue)-60).toString();
                        }else {
                            alarm =(parseInt(hour)+1).toString() + ":" + ((parseInt(mins) + snoozeValue)-60).toString();
                        }
                    }
                }else if (parseInt(hour) === 23){
                    if(parseInt(mins) >= 5 && parseInt(mins) + snoozeValue < 60){
                        alarm = hour + ":" + (parseInt(mins) + snoozeValue).toString();
                    }else if (parseInt(mins) < 5) {
                        alarm = hour + ":" + "0" + (parseInt(mins) + snoozeValue).toString();
                    }else if (parseInt(mins) + snoozeValue >= 60){
                        if((parseInt(mins) + snoozeValue)-60 < 10){
                             alarm = "00" + ":" + "0" + ((parseInt(mins) + snoozeValue)-60).toString();
                        }else {
                             alarm = "00" + ":" + ((parseInt(mins) + snoozeValue)-60).toString();
                        }
                    }
                } else if (parseInt(hour)<10){
                    if(parseInt(mins) + snoozeValue < 60){
                        alarm = hour + ":" + (parseInt(mins) + snoozeValue).toString();
                    }else{
                        if((parseInt(mins) + snoozeValue)-60 < 10 && parseInt(hour)+1 < 10){
                            alarm = "0" + (parseInt(hour)+1).toString() + ":" + "0" + ((parseInt(mins) + snoozeValue)-60).toString();
                        }else if(((parseInt(mins) + snoozeValue)-60) > 10 && (parseInt(hour)+1) < 10){
                            alarm = "0" + (parseInt(hour)+1).toString() + ":" + ((parseInt(mins) + snoozeValue)-60).toString();
                        }else if(((parseInt(mins) + snoozeValue)-60) < 10 && (parseInt(hour)+1) >= 10){
                            alarm = (parseInt(hour)+1).toString() + ":" + "0" + ((parseInt(mins) + snoozeValue)-60).toString();
                        }else if((parseInt(mins) + snoozeValue)-60 > 10 && (parseInt(hour)+1) >= 10){
                            alarm = (parseInt(hour)+1).toString() + ":" + ((parseInt(mins) + snoozeValue)-60).toString();
                        }
                    }
                }
            }
        }

        Button {
            id:setButton
            text: qsTr("Set")

            onPressAndHold: {
                if(setAlarm.visible){
                    setAlarm.visible = false;
                    clickTimeHrs = 0;
                }else {
                    setAlarm.visible = true;
                    blinkHrs.start();
                    clickTimeHrs++;
                    exitTimer.start();
                }
            }

            onClicked: {
                exitTimeCount = 0;
                if(soundPlay) {
                    sound.stop();
                    soundPlay = false;
                }

                if(clickTimeHrs == 1){
                    blinkHrs.stop();
                    hrs.text = hrsCount
                    blinkMin.start();
                    clickTimeHrs++;

                } else if (clickTimeHrs == 2) {
                    blinkMin.stop();
                    min.text = minCount
                    if (hrsCount < 10 && minCount < 10) {
                        alarm = "0" + hrsCount.toString() + ":" + "0" + minCount.toString();
                    }else if(hrsCount < 10) {
                        alarm = "0" + hrsCount.toString() + ":" + minCount.toString();
                    }else if(minCount < 10) {
                        alarm = hrsCount.toString() + ":" + "0" + minCount.toString();
                    }else {
                        alarm = hrsCount.toString() + ":"+ minCount.toString();
                    }
                    clickTimeHrs++;
                } else if (clickTimeHrs == 3) {
                    setAlarm.visible = false;
                    setsnooze.visible = true;
                    snoozeTime.start();
                    //setTimeSystem.visible = true;
                   // timeSystem.start();
                    clickTimeHrs++;
                } else if (clickTimeHrs == 4) {
                    //timeSystem.stop();
                    //setTimeSystem.visible = false;
//                    setsnooze.visible = true;
//                    snoozeTime.start();
                    snoozeTime.stop();
                    setsnooze.visible = false;
                    clickTimeHrs == 0;
                    exitTimer.stop();
                }
                //else if (clickTimeHrs == 5) {
//                    snoozeTime.stop();
//                    setsnooze.visible = false;
//                    clickTimeHrs == 0;
//                    exitTimer.stop();
                //}
            }
        }

        Button {
            id:upButton
            text: qsTr("Up")
            onPressAndHold: {
                exitTimeCount = 0;
                exitTimer.stop();
                if(clickTimeHrs == 1){
                    accelerateHrs.start();
                } else if(clickTimeHrs == 2){
                    accelerateMin.start();
                } else if(clickTimeHrs == 5){
                    accelerateSnoozeValue.start();
                }
            }

            onReleased: {
                exitTimer.start();
                if(clickTimeHrs == 1){
                    accelerateHrs.stop();
                }else if(clickTimeHrs == 2) {
                    accelerateMin.stop();
                }else if(clickTimeHrs == 5){
                    accelerateSnoozeValue.stop();
                }
            }

            onClicked: {
                exitTimeCount = 0;
                if(soundPlay) {
                    sound.stop();
                    soundPlay = false;
                }

                if(clickTimeHrs == 1) {
                    if(hrsCount < 23) {
                        hrsCount++;
                        hrs.text = hrsCount;
                    }else {
                        hrsCount = 0;
                        hrs.text = hrsCount;
                    }
                }else if(clickTimeHrs == 2) {
                    if(minCount < 59) {
                        minCount++;
                        min.text = minCount;
                    }else {
                        minCount = 0;
                        min.text = minCount;
                    }
                }else if(clickTimeHrs == 5){
                    if(snoozeValue < 60) {
                        snoozeValue++;
                        snooze.text = snoozeValue;
                    } else {
                        snoozeValue = 5;
                        snooze.text = snoozeValue;
                    }
                }
            }
        }
    }

    Item {
        Timer {
           id: blinkHrs
           property int begin: 0;
           interval: 200; running: false; repeat: true
           onTriggered:
                if(begin === 0) {
                    hrs.text = "";
                    begin = 1
                }
                else if(begin === 1) {
                    hrs.text = hrsCount;
                    begin = 0;
                }
        }

        Timer {
            id: accelerateHrs
            interval: 400; running: false; repeat: true
            onTriggered:
                if(hrsCount < 23) {
                    hrsCount++;
                    hrs.text = hrsCount;
                }else {
                    hrsCount = 0;
                    hrs.text = hrsCount;
                }
        }

        Timer {
            id: deaccelerateHrs
            interval: 400; running: false; repeat: true
            onTriggered:
                if(hrsCount > 0) {
                    hrsCount--;
                    hrs.text = hrsCount;
                }else {
                    hrsCount = 23;
                    hrs.text = hrsCount;
                }
        }
    }

    Item {
        Timer {
           id: blinkMin
           property int begin: 0;
           interval: 200; running: false; repeat: true
           onTriggered:
               if(begin === 0) {
                    min.text = "";
                    begin = 1
                }else if(begin === 1) {
                    min.text = minCount;
                    begin = 0;
                }
        }

        Timer {
            id: accelerateMin
            interval: 400; running: false; repeat: true
            onTriggered:
                if(minCount < 59) {
                    minCount++;
                    min.text = minCount;
                }else {
                    minCount = 0;
                    min.text = minCount;
                }
        }

        Timer {
            id: deaccelerateMin
            interval: 400; running: false; repeat: true
            onTriggered:
                if(minCount > 0) {
                    minCount--;
                    min.text = minCount;
                }else {
                    minCount = 59;
                    min.text = minCount;
                }
        }
    }

//    Item {
//        Timer {
//           id: timeSystem
//           property int begin: 0;
//           interval: 400; running: false; repeat: true
//           onTriggered:
//            if(begin === 0) {
//                timeSystemText.text = "";
//                begin = 1}
//            else if(begin === 1) {
//                timeSystemText.text = "24H";
//                begin = 0;
//            }
//        }
//    }


    Item {
        Timer {
           id: snoozeTime
           property int begin: 0;
           interval: 400; running: false; repeat: true
           onTriggered:
            if(begin === 0) {
                snooze.text = "";
                begin = 1
            } else if(begin === 1) {
                snooze.text = snoozeValue;
                begin = 0;
            }
        }

        Timer {
            id: accelerateSnoozeValue
            interval: 400; running: false; repeat: true
            onTriggered:{
                if(snoozeValue >= 5 && snoozeValue < 60) {
                    snoozeValue++;
                } else {
                    snoozeValue = 5;
                }
            }
        }

        Timer {
            id: deaccelerateSnoozeValue
            interval: 400; running: false; repeat: true
            onTriggered:{
                if(snoozeValue > 5) {
                   snoozeValue--;
                } else {
                   snoozeValue = 60;
                }
            }
        }
    }


    Label {
        id: setsnooze
        height: 95
        width: 375
        x: 120
        y: 120
        visible: false
        horizontalAlignment: Text.AlignHCenter
        background: Rectangle {
           border.width: 1.5
           border.color: "gray"
           radius: 10
        }

        Text {
            id: snooze
            text:snoozeValue
            x: 150
            y: 0
            font.pointSize: 80
        }
    }

//    Label {
//        id: setTimeSystem
//        height: 95
//        width: 375
//        x: 120
//        y: 120
//        visible: false
//        horizontalAlignment: Text.AlignHCenter
//        background: Rectangle {
//           border.width: 1.5
//           border.color: "gray"
//           radius: 10
//        }

//        Text {
//            id: timeSystemText
//            text: "24H"
//            x: 120
//            y: 3
//            font.pointSize: 80
//        }
//    }

    Label {
        id: setAlarm
        height: 95
        width: 375
        x: 120
        y: 120
        visible: false
        horizontalAlignment: Text.AlignHCenter
        background: Rectangle {
           border.width: 1.5
           border.color: "gray"
           radius: 10
        }

        Text {
            id: hrs
            text:hrsCount
            x: 70
            y: 3
            font.pointSize: 80
        }

        Text {
            id: min
            text: minCount
            x: 210
            y: 3
            font.pointSize: 80
        }

        Text {
            id: dots
            text: ":"
            x: 170
            y: 3
            font.pointSize: 80
        }
    }    
}
