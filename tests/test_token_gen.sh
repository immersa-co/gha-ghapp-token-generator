export INPUT_PRIVATEKEY=`cat ~/.ssh/test-surat-gh-app.2022-04-16.private-key.pem`
export INPUT_APPID=191773
export INPUT_INSTALLID=25000618
export INPUT_DURATION=10

#python3 ../main.py

echo $(../jwt-sign.sh)
