# Docker Push on Tag - GitHub Action 요구사항

## 개요

Git 태그 생성 시 자동으로 Docker 이미지를 빌드하고 Docker Registry로 푸시하는 GitHub Action 워크플로우 생성

## 참고 파일 분석

**참고**: `/Users/user/WebstormProjects/inspireme.advenoh.pe.kr/.github/workflows/docker-push-on-tag.yml`

### 참고 파일 주요 기능
| 기능 | 설명 |
|------|------|
| 트리거 | `v*` 패턴 태그 푸시 시 실행 (v1.0.0, v2.1.3 등) |
| 멀티 플랫폼 | linux/amd64, linux/arm64 동시 빌드 |
| 태그 전략 | 버전 태그 + `latest` 태그 동시 생성 |
| 캐시 | Registry 기반 빌드 캐시 활용 |
| Actions 사용 | checkout@v4, setup-buildx-action@v3, login-action@v3, build-push-action@v5 |

---

## 현재 프로젝트 상태

### 기존 설정
- **Registry**: Docker Hub (`kenshin579`)
- **Image Name**: `echo-server`
- **현재 태그**: `v0.2` (Makefile에 하드코딩)
- **Dockerfile**: 멀티스테이지 빌드 (golang:1.23.0-alpine3.20 -> alpine)
- **기존 워크플로우**: 없음 (`.github/workflows/` 비어있음)

### Makefile 현재 Docker 관련 명령어
```makefile
REGISTRY    := kenshin579
APP         := echo-server
TAG         := v0.2
IMAGE       := $(REGISTRY)/$(APP):$(TAG)

docker-build:  # 로컬 빌드
docker-push:   # 빌드 후 푸시
docker-run:    # 컨테이너 실행
```

---

## 작업 요구사항

### 1. GitHub Action 워크플로우 생성

**파일**: `.github/workflows/docker-push-on-tag.yml`

#### 1.1 트리거 조건
- `v*` 패턴 태그 푸시 시 자동 실행
- 예: `v1.0.0`, `v2.0.0-beta` 등

#### 1.2 환경 변수
| 변수 | 값 | 비고 |
|------|-----|------|
| `IMAGE_NAME` | `echo-server` | 고정값 |
| `REGISTRY` | GitHub Secrets에서 가져옴 | `DOCKER_REGISTRY_URL` |
| `DOCKER_USERNAME` | GitHub Secrets에서 가져옴 | `DOCKER_REGISTRY_USERNAME` |

#### 1.3 워크플로우 단계
1. **코드 체크아웃** - `actions/checkout@v4`
2. **태그 버전 추출** - `GITHUB_REF`에서 버전 파싱
3. **Docker Buildx 설정** - `docker/setup-buildx-action@v3`
4. **Docker Registry 로그인** - `docker/login-action@v3`
5. **이미지 빌드 및 푸시** - `docker/build-push-action@v5`
6. **결과 출력** - digest 및 성공 메시지

#### 1.4 빌드 옵션
- **플랫폼**: `linux/amd64`, `linux/arm64`
- **태그**:
  - `{REGISTRY}/{USERNAME}/{IMAGE_NAME}:{VERSION}` (예: v1.0.0)
  - `{REGISTRY}/{USERNAME}/{IMAGE_NAME}:latest`
- **캐시**: Registry 기반 캐시 사용 (`buildcache` 태그)

---

### 2. GitHub Secrets 설정 필요

| Secret 이름 | 설명 | 예시 값 |
|-------------|------|---------|
| `DOCKER_REGISTRY_USERNAME` | Registry 사용자명 | `kenshin579` |
| `DOCKER_REGISTRY_PASSWORD` | Registry 비밀번호/토큰 | `dckr_pat_xxx...` |

---

### 3. 선택사항 (권장)

#### 3.1 Go 테스트 단계 추가
- 이미지 빌드 전 `go test ./...` 실행
- 테스트 실패 시 빌드 중단

#### 3.2 Go 버전 일관성
- Dockerfile의 Go 버전 (`1.23.0`)과 CI 환경 일치

---

## 예상 결과

태그 생성 후 워크플로우 실행 시:
```bash
git tag v1.0.0
git push origin v1.0.0
```

생성되는 이미지:
- `{REGISTRY}/kenshin579/echo-server:v1.0.0`
- `{REGISTRY}/kenshin579/echo-server:latest`

---

## 관련 문서

- 구현 상세: `1_docker_implementation.md`
- TODO 체크리스트: `1_docker_todo.md`
