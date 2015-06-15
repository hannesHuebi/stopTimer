import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Pickers 0.1
import QtMultimedia 5.0
import Ubuntu.Components.Pickers 1.0

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: mainView
    property date startTime: new Date()
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "stoptimer.hanneslindner"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(100)
    height: units.gu(75)

    Page {
        id: page1
        title: i18n.tr("StopTimer")

        Column {
            id: column1
            width: 768
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            spacing: units.gu(1)
            anchors {
                margins: units.gu(2)
            }

            Label {
                id: label
                width: parent.width
                objectName: "label"

                text: Qt.formatDateTime(getDiffrenceDate(new Date()), "mm:ss.zzz");
                fontSize: "large"
                horizontalAlignment: Text.AlignHCenter
            }



            DatePicker {
                    id: datePicker
                    anchors.horizontalCenter: parent.horizontalCenter

                    mode: "Minutes|Seconds"
                    onDateChanged: {

                        label.text = Qt.formatDateTime(datePicker.date, "mm:ss.zzz");
                    }
                }
//            Dialer {
//                anchors.horizontalCenter: parent.horizontalCenter
//                size: units.gu(20)
//                minimumValue: 0
//                maximumValue: 60

//                DialerHand {
//                    id: mainHand
//                    onValueChanged: console.log(value)
//                }
//                Dialer {
//                    size: units.gu(30)
//                    minimumValue: 0
//                    maximumValue: 120

//                    DialerHand {
//                        id: secondHand
//                        onValueChanged: console.log(value)
//                    }
//                }
//            }
            Row {
                id: row1
                width: parent.width
                spacing: units.gu(1)
                Button {
                    id: startStopButton
                    objectName: "button"
                    width: parent.width / 2

                    text: i18n.tr("Start")

                    onClicked: {
                        if (!setlabel.running)
                        {
                            startStopButton.text = "Stop";
                            resetButton.enabled = false;
                            label.text = Qt.formatDateTime(datePicker.date, "hh:mm:ss.zzz")
                            player.stop();

                            startTime = new Date();

                            var miliseconds = ((datePicker.date.getMinutes()*60)+datePicker.date.getSeconds())*1000;
                            if (Math.abs(miliseconds) > 100)
                            {
                                timer.interval = miliseconds;
                                timer.start();
                            }
                            else
                            {
                                timer.interval = 0;
                            }

                            datePicker.enabled = false;

                            setlabel.start();
                        }
                        else
                        {
                            console.log(player.playbackState.toString())
                            if (player.playbackState == 1)
                            {
                                player.stop();
                            }
                            else
                            {
                                startStopButton.text = "Start";
                                resetButton.enabled = true;
                                datePicker.enabled = true;
                                timer.stop();
                                setlabel.stop();
                                player.stop();
                            }


                        }
                    }
                }
                Button {
                    id: resetButton
                    objectName: "button"
                    width: parent.width / 2

                    text: i18n.tr("Reset")

                    onClicked: {
                        timer.stop();
                        timer.interval = 0;
                        datePicker.date = getDiffrenceDate(new Date());
                    }
                }
            }
        }
    }
    Timer {
        id: timer
        interval: 0; running: false; repeat: false
        onTriggered: {
//            setlabel.stop()
            if(mainView.focus == true)
            {
                datePicker.date = getDiffrenceDate(startTime);
            //label.text = Qt.formatDateTime(getDiffrenceDate(startTime), "mm:ss.zzz");
            }

            player.play()
        }
    }

    Timer {
        id: setlabel
        interval: 100; running: false; repeat: true
        onTriggered: {
            if(mainView.focus == true)
            {
                datePicker.date = getDiffrenceDate(startTime);
            }

        }
    }

    function getDiffrenceDate(start) {
        var now = new Date();
//        now.setDate(now.getDate());
        var differenceTime = new Date(0);
        differenceTime = Math.abs(now - start);
        var bla = new Date(Math.abs(timer.interval - differenceTime));
//        bla.setHours(0);
        return bla;
    }
    MediaPlayer {
        id: player
        source: "sound/foo.mp3"
        onStatusChanged: {
            if (status == MediaPlayer.EndOfMedia) {
                button.pressed = false
                button.text = i18n.tr("Play")
            }
        }
        onPlaybackStateChanged: {
            if (status == player.playbackState == 1)
            {
                mainView.activeFocus;
            }
        }
    }

}

