# Docker Push on Tag - TODO 체크리스트

## Phase 1: 워크플로우 파일 생성

- [x] `.github/workflows/docker-push-on-tag.yml` 파일 생성
- [x] 트리거 조건 설정 (`on.push.tags: 'v*'`)
- [x] 환경 변수 정의 (`IMAGE_NAME`, `REGISTRY`, `DOCKER_USERNAME`)
- [x] Job 및 Steps 구현
  - [x] 코드 체크아웃 (`actions/checkout@v4`)
  - [x] 태그 버전 추출 스크립트
  - [x] Docker Buildx 설정 (`docker/setup-buildx-action@v3`)
  - [x] Docker Registry 로그인 (`docker/login-action@v3`)
  - [x] 이미지 빌드 및 푸시 (`docker/build-push-action@v5`)
  - [x] 결과 출력 메시지

## Phase 2: GitHub Secrets 설정

> **설정 경로**: Repository > Settings > Secrets and variables > Actions > New repository secret

- [ ] `DOCKER_REGISTRY_USERNAME` 설정 (`kenshin579`)
- [ ] `DOCKER_REGISTRY_PASSWORD` 설정 (Docker Hub Access Token)

## Phase 3: 검증

- [ ] 테스트 태그 생성 (`git tag v0.3-test`)
- [ ] 태그 푸시 (`git push origin v0.3-test`)
- [ ] GitHub Actions 워크플로우 실행 확인
- [ ] Docker Hub에서 이미지 생성 확인
- [ ] 테스트 태그 정리 (선택)
