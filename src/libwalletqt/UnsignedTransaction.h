#ifndef UNSIGNEDTRANSACTION_H
#define UNSIGNEDTRANSACTION_H

#include <QObject>

#include <wallet/api/wallet2_api.h>

class UnsignedTransaction : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Status status READ status)
    Q_PROPERTY(QString errorString READ errorString)
  //  Q_PROPERTY(QList<qulonglong> amount READ amount)
  //  Q_PROPERTY(QList<qulonglong> fee READ fee)
    Q_PROPERTY(quint64 txCount READ txCount)
    Q_PROPERTY(QString confirmationMessage READ confirmationMessage)
    Q_PROPERTY(QStringList recipientAddress READ recipientAddress)
    Q_PROPERTY(QStringList paymentId READ paymentId)
    Q_PROPERTY(quint64 minMixinCount READ minMixinCount)

public:
    enum Status {
        Status_Ok       = Incognito::UnsignedTransaction::Status_Ok,
        Status_Error    = Incognito::UnsignedTransaction::Status_Error,
        Status_Critical    = Incognito::UnsignedTransaction::Status_Critical
    };
    Q_ENUM(Status)

    Status status() const;
    QString errorString() const;
    Q_INVOKABLE quint64 amount(int index) const;
    Q_INVOKABLE quint64 fee(int index) const;
    Q_INVOKABLE quint64 mixin(int index) const;
    QStringList recipientAddress() const;
    QStringList paymentId() const;
    quint64 txCount() const;
    QString confirmationMessage() const;
    quint64 minMixinCount() const;
    Q_INVOKABLE bool sign(const QString &fileName) const;
    Q_INVOKABLE void setFilename(const QString &fileName);

private:
    explicit UnsignedTransaction(Incognito::UnsignedTransaction * pt, Incognito::Wallet *walletImpl, QObject *parent = 0);
    ~UnsignedTransaction();
private:
    friend class Wallet;
    Incognito::UnsignedTransaction * m_pimpl;
    QString m_fileName;
    Incognito::Wallet * m_walletImpl;
};

#endif // UNSIGNEDTRANSACTION_H
