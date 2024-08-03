### Docker 설치
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

### 부팅시 Docker 자동 실행
sudo systemctl enable docker

### istio 설치
curl -L https://istio.io/downloadIstio | sh -
cd istio-<version>
export PATH=$PWD/bin:$PATH
export PATH="$PATH:/home/junho/Documents/istio-1.22.3/bin"

### istio 설치 파일 적용
istioctl install --set profile=demo -y

### Istio 시스템 네임스페이스와 기본 네임스페이스에 레이블 추가
kubectl label namespace default istio-injection=enabled

### Bookinfo 애플리케이션 배포
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

### 정상 배포 확인
kubectl get services
kubectl get pods

### 애플리케이션 인그레스 게이트웨이 설정
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

### 게이트웨이의 IP 주소/포트 확인
******** 
kubectl get svc istio-ingressgateway -n istio-system

## 모니터링 툴 Prometheus 접근
kubectl -n istio-system port-forward svc/prometheus 9090:9090

## Grafana 접근
kubectl -n istio-system port-forward svc/grafana 3000:3000

## Kiali 설치
istioctl install --set profile=demo -y

# Checkout the source code
mkdir kiali_sources
cd kiali_sources
export KIALI_SOURCES=$(pwd)

git clone https://github.com/kiali/kiali.git
git clone https://github.com/kiali/kiali-operator.git
git clone https://github.com/kiali/helm-charts.git

ln -s $KIALI_SOURCES/kiali-operator kiali/operator

# Build the back-end and run the tests
cd $KIALI_SOURCES/kiali
make build test

# You can pass go test flags through the GO_TEST_FLAGS env var
# make -e GO_TEST_FLAGS="-race -v -run=\"TestCanConnectToIstiodReachable\"" test

# Build the front-end and run the tests
make build-ui-test

cd $KIALI_SOURCES/kiali
make kiali-reload-image

## Kiali 접근
istioctl dashboard kiali

### Jaeger 대시보드
istioctl dashboard jaeger
kubectl -n istio-system port-forward deploy/jaeger 16686:16686
### trace 추적
kubectl -n istio-system port-forward svc/jaeger-query 16685:16686 -n istio-system

## Zipkin 접근
kubectl -n istio-system port-forward svc/zipkin 9411:9411

### Zipkin 설명
Zipkin 은 분산 추적 시스템입니다. 서비스 아키텍처에서 지연 문제를 해결하는 데 필요한 타이밍 데이터를 수집하는 데 도움이 됩니다. 이 데이터의 수집과 조회가 모두 특징입니다.

Zipkin은 Jaeger의 대안이며 기본적으로 배포되지 않습니다. Jaeger를 Zipkin으로 바꾸려면 를 실행합니다. 또한 사용되지 않을 Jaeger 배포를 로 제거 하거나 시작하기kubectl delete deployment jaeger 의 선택적 설치 단계에 따라 처음부터 설치하지 않을 수도 있습니다 .

### Zipkin 설치
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

### Zipkin 연동
https://docs.traceable.ai/docs/istio-with-zipkin

### Zipkin 실행
minikube service zipkin -n default

### helm 저장소 추가
helm repo add openzipkin https://openzipkin.github.io/zipkin-chart/
helm repo update

### label 확인 명령어
kubectl get ns istio-system --show-labels

### istio-system의 구성 파드들 나열
kubectl get pods -n istio-system

### 트래픽 라우팅 설정
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

### wrk 설치
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev git zlib1g-dev
sudo git clone https://github.com/giltene/wrk2.git
cd wrk2
sudo make
# move the executable to somewhere in your PATH
sudo cp wrk /usr/local/bin

### wrk2 설치
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev git zlib1g-dev
git clone https://github.com/giltene/wrk2.git
cd wrk2
make
# move the executable to somewhere in your PATH
sudo cp wrk /usr/local/bin

### 트래픽 발생
wrk -t4 -c50 -d1h -R100 --latency http://192.168.49.2:31909/productpage

### CRD 문제
istioctl install --set profile=demo -y

### 기존에 존재하던 쿠버네티스 컨테이너 혹은 도커 컨테이너 조회
kubectl config get-contexts

### 필요없는 컨텍스트 삭제
kubectl config delete-context <context-name>

### 쿠버네티스 충돌 및 미니쿠베 제거
minikube delete --all --purge

### 충돌시 도커 컨테이너 및 이미지 제거

--------------------------------
### bookinfo 설치
curl -L https://istio.io/downloadIstio | sh -
cd istio-<version>
export PATH=$PWD/bin:$PATH
export PATH="$PATH:/home/junho/Documents/istio-1.22.3/bin"

istioctl install --set profile=demo -y

kubectl label namespace default istio-injection=enabled

kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

kubectl get services
kubectl get pods

kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

kubectl get svc istio-ingressgateway -n istio-system
-------------------------------------
### minikube 클러스터 완전히 삭제하기
sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube*   
sudo apt-get autoremove  
sudo rm -rf ~/.kube

### docker 자동으로 시작하게 만들기
sudo systemctl enable docker

### minikube start가 안될 떄
minikube delete
minikube start --driver=docker

GUI Enable
$ sudo systemctl set-default graphical
GUI Disable
$ sudo systemctl set-default multi-user

### minikube 실행 안됨
minikube delete --all --purge
