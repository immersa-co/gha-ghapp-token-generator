export INPUT_PRIVATEKEY=`cat ~/.ssh/test-surat-gh-app.2022-04-16.private-key.pem`
export INPUT_APPID=191773
export INPUT_INSTALLID=25000618
export INPUT_DURATION=10

docker build --platform linux/amd64 -t test:test-gha-token-v1 .
docker run -e INPUT_PRIVATEKEY -e INPUT_APPID -e INPUT_INSTALLID -e INPUT_DURATION -it \
--platform linux/amd64 test:test-gha-token-v1
