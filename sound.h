#ifndef SOUND_H
#define SOUND_H

#include <QObject>
#include <QString>
#include <QSoundEffect>



class Sound : public QObject
{
    Q_OBJECT

public:
    explicit Sound (QObject *parent = nullptr);

public slots:
    void play(int a);

private:
    QSoundEffect effect;
};


#endif // SOUND_H
