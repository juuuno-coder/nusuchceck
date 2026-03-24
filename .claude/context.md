# 누수체크 프로젝트 Claude 컨텍스트

> 맥미니 이전 시 이 파일과 `.claude/memory/` 폴더를 참고해서 대화를 이어가세요.

---

## 프로젝트 현황 (2026-03-24 기준)

### 인프라
- **서버**: NCP (49.50.138.93) — Docker Compose 운영 중
- **도메인**: https://nusucheck.vibers.co.kr (Cloudflare 프록시)
- **배포**: git push origin main → GitHub Actions → NCP 자동 배포
- **Fly.io**: 완전 삭제 완료 (nusucheck, nusucheck-db 모두 제거)

### Docker 구성 (docker-compose.yml)
| 컨테이너 | 역할 | 포트 |
|---------|------|------|
| nusucheck-app | Rails 서버 | 4080→3000 |
| nusucheck-sidekiq | 백그라운드 작업 | - |
| nusucheck-db | PostgreSQL 16 | - |
| nusucheck-redis | Redis 7 | - |

- 네트워크: `npm_default` (외부 네트워크, Nginx Proxy Manager와 공유)
- NPM Proxy: nusucheck.vibers.co.kr → http://nusucheck-app:3000

### GitHub
- 레포: https://github.com/vibers-leo/nusucheck
- GitHub Actions: `.github/workflows/deploy.yml`
- Secrets: `NCP_HOST`, `NCP_USER`, `NCP_SSH_KEY`

### 서버 SSH 접속
```bash
ssh root@49.50.138.93  # 비밀번호: Elfoq2026^
# 또는 키 인증 (서버의 /tmp/gh_deploy)
```

### 서버 .env 위치
```
/root/projects/nusucheck/.env
```

---

## 주요 해결된 버그

### Stimulus 컨트롤러 전체 미작동 (2026-03-22)
- **원인**: `chat_controller.js`에서 `import consumer from "../channels/consumer"` 상대 경로 사용
- importmap은 bare specifier만 처리 → 404 → ES module 체인 전체 실패 → 모든 Stimulus 컨트롤러 미등록
- **해결**: `import consumer from "channels/consumer"` 로 변경

### 다음 버튼 활성화 안 됨 (check-wizard)
- 위 Stimulus 전체 미작동 문제가 근본 원인이었음
- chat_controller.js 수정 후 정상 동작 확인

### Docker 빌드 실패 (chown 오류)
- **원인**: log, storage, tmp 디렉토리가 빌드 컨텍스트에 없어서 chown 실패
- **해결**: Dockerfile에 `mkdir -p db log storage tmp` 추가

### Rails HostAuthorization 403
- **원인**: localhost 헬스체크가 허용 호스트 목록에 없었음
- **해결**: production.rb에 `"localhost"`, `nusucheck.vibers.co.kr` 등 추가

---

## 클로드 작업 스타일 (메모리 요약)

1. **에요체 사용** — 토스 스타일, 입니다체 금지
2. **한국어로 진행** — 기술 용어는 영어, 설명은 한국어
3. **컬러**: primary = 파랑(#3b82f6), teal = 점검/문제 상태 전용

---

## 맥미니 이전 체크리스트

1. 프로젝트 폴더 복사 (`rsync -av`)
2. `~/.claude/` 폴더 복사 (메모리, 플랜, 설정)
3. 맥미니에서 동일 경로 사용 권장: `/Users/admin/Desktop/nusucheck`
   - 경로가 다르면 `~/.claude/projects/` 하위 메모리 폴더를 새 경로명으로 rename
4. git remote는 GitHub 연결이므로 별도 설정 불필요
5. Fly.io CLI는 맥미니에 재설치 불필요 (이미 NCP로 이전 완료)
