#include "sound.h"
#include <QSoundEffect>
#include <QDebug>


Sound :: Sound(QObject *parent) : QObject(parent)

{
    //effect = new QSoundEffect;
    effect.setSource(QUrl::fromLocalFile("/Users/linhaiyuan/Alarm_clock/Sound.wav"));
    effect.setLoopCount(QSoundEffect::Infinite);
    effect.setVolume(1.0f);
}

void Sound :: play (int a)
{
    if(a == 1) {
        //effect.setSource(QUrl::fromLocalFile("/Users/linhaiyuan/Alarm_clock/Sound.wav"));
        //effect.setLoopCount(QSoundEffect::Infinite);
        //effect.setVolume(1.0f);
        effect.play();
    } else if(a == 2){
        effect.stop();
    }
    qDebug() << effect.status();
}
