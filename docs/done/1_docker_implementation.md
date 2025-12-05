# Docker Push on Tag - 구현 문서

## 구현 대상

**파일**: `.github/workflows/docker-push-on-tag.yml`

---

## 워크플로우 구조

```yaml
name: Docker Image Push on Tag

on:
  push:
    tags:
      - 'v*'

env:
  IMAGE_NAME: echo-server
  REGISTRY: ${{ secrets.DOCKER_REGISTRY_URL }}
  DOCKER_USERNAME: ${{ secrets.DOCKER_REGISTRY_USERNAME }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      # 아래 단계별로 구현
```

---

## 구현 단계

### Step 1: 코드 체크아웃

```yaml
- name: 코드 체크아웃
  uses: actions/checkout@v4
```

### Step 2: 태그 버전 추출

```yaml
- name: 태그 버전 추출
  id: extract_version
  run: |
    TAG_VERSION=${GITHUB_REF#refs/tags/}
    echo "version=$TAG_VERSION" >> $GITHUB_OUTPUT
    echo "Extracted version: $TAG_VERSION"
```

### Step 3: Docker Buildx 설정

```yaml
- name: Docker Buildx 설정
  uses: docker/setup-buildx-action@v3
```

### Step 4: Docker Registry 로그인

```yaml
- name: Docker Registry 로그인
  uses: docker/login-action@v3
  with:
    registry: ${{ secrets.DOCKER_REGISTRY_URL }}
    username: ${{ secrets.DOCKER_REGISTRY_USERNAME }}
    password: ${{ secrets.DOCKER_REGISTRY_PASSWORD }}
```

### Step 5: 이미지 빌드 및 푸시

```yaml
- name: Docker 이미지 빌드 및 푸시
  uses: docker/build-push-action@v5
  with:
    context: .
    platforms: linux/amd64,linux/arm64
    push: true
    tags: |
      ${{ env.REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:${{ steps.extract_version.outputs.version }}
      ${{ env.REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
    cache-from: type=registry,ref=${{ env.REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:buildcache
    cache-to: type=registry,ref=${{ env.REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:buildcache,mode=max
```

### Step 6: 결과 출력

```yaml
- name: 이미지 digest
  run: echo "Image pushed successfully with tags - ${{ steps.extract_version.outputs.version }} and latest"
```

---

## GitHub Secrets 설정

| Secret 이름 | 값 |
|-------------|-----|
| `DOCKER_REGISTRY_USERNAME` | `kenshin579` |
| `DOCKER_REGISTRY_PASSWORD` | Docker Hub Access Token |

**설정 경로**: Repository > Settings > Secrets and variables > Actions > New repository secret

---

## 테스트 방법

```bash
# 태그 생성 및 푸시
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions 탭에서 워크플로우 실행 확인
# Docker Hub에서 이미지 확인
```
