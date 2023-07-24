FROM    golang:1.17-alpine

ADD             . /app
WORKDIR /app
RUN             echo "export export GO111MODULE=auto" >> /root/.bashrc
RUN             go mod init github.com/agunal/krantor
RUN             apk add git \
                && go get github.com/putdotio/go-putio@latest \
                && go get github.com/fsnotify/fsnotify@latest \
                && go get golang.org/x/oauth2@latest \
                && go mod tidy

RUN             go build -o krantor
CMD             ["/app/krantor"]