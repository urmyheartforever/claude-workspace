# 할 일 (todo)

## 2026-11-17 — 방명록 Vercel 배포

> 상태: ✅ 완료 (실제 사이트에서 방명록 표시 확인)
- [x] 1. Vercel 환경변수 등록 (SUPABASE_URL, SUPABASE_ANON_KEY — production·preview)
- [x] 2. `portfolio/vercel.json`에 buildCommand(`node ../scripts/build-config.mjs`) 추가 → 배포 때 config.js 생성
- [x] 3. `guestbook` 브랜치 push → 미리보기 배포 빌드 로그 확인
- [x] 4. main 머지 → push → 실제 사이트 확인 (방명록 표시, config.js, 개인 파일 404)
- [x] 5. 기록

## 2026-11-17 — 방명록 글 수정 (비밀번호 방식)

> 상태: ✅ 완료 (브라우저 자동 테스트 8개 통과, guestbook 브랜치 커밋)
> 브랜치: `guestbook` (계속)

### 방식
- 글 쓸 때 비밀번호(4자 이상) 함께 입력 → DB에는 **암호화(bcrypt)해서** 저장, 아무도 원래 비밀번호를 볼 수 없음
- 수정할 때 같은 비밀번호를 넣으면 DB가 직접 확인 후 수정 (브라우저가 비밀번호 정답을 받지 않음)
- 방문자는 표에 직접 쓰기 불가 → **DB 함수 2개로만** 쓰기·수정 (`create_message`, `update_message`)
- 기존 테스트 글(id=2)은 비밀번호가 없어서 수정 불가 (대시보드에서 지우면 됨)

### 단계
- [x] 1. `supabase/message_edit.sql` 새로 만들기: `password_hash`·`updated_at` 칸 추가, 비밀번호 칸은 읽기 금지, 함수 2개, 직접 쓰기 권한 회수
- [x] 2. ⛔ **사용자가 Supabase SQL Editor에서 Run**
- [x] 3. `portfolio/index.html`: 작성 폼에 비밀번호 칸 + 글마다 [수정] 버튼(내용 고치기 + 비밀번호 확인) + "수정됨" 표시 (백업 먼저)
- [x] 4. 테스트: 비밀번호 맞음 → 수정됨 / 틀림 → 거절 / 비밀번호 칸 조회 불가 / 직접 쓰기 불가 / 브라우저 화면 확인
- [x] 5. `guestbook` 브랜치에 커밋 + 기록

## 2026-11-17 — 포트폴리오 방명록 (Supabase)

> 상태: ✅ 로컬 테스트 완료 (guestbook 브랜치 커밋, GitHub·Vercel 미반영)
> 브랜치: `guestbook` (테스트 끝날 때까지 main·Vercel은 그대로)
> 키: anon(공개용)만 사용. service_role 키는 사용·저장 안 함

### 단계
- [x] 1. 브랜치 `guestbook` 만들기
- [x] 2. `.env.local` 만들기 (SUPABASE_URL, SUPABASE_ANON_KEY) + `.env.example`(이름만) + `.gitignore`에 `.env.local`, `portfolio/config.js` 추가
- [x] 3. `supabase/message.sql` 새로 만들기: `message` 테이블(id, name, content, created_at) + RLS(누구나 읽기·쓰기, 수정·삭제 불가)
- [x] 4. ⛔ **사용자가 Supabase SQL Editor에서 Run** (anon 키로는 테이블 생성 불가)
- [x] 5. `scripts/build-config.mjs`: `.env.local` → `portfolio/config.js` 생성 (추가 설치 없음)
- [x] 6. `portfolio/index.html` 맨 아래에 방명록 폼 + 목록 추가 (라이브러리 없이 fetch, textContent로 안전하게 표시, 백업 먼저)
- [x] 7. 로컬 실행 준비: `npm run dev` → http://localhost:3000 (python 내장 서버)
- [x] 8. 테스트: 읽기·쓰기 성공 + 수정·삭제 차단 확인 (테스트 글 1개가 실제 DB에 남음) + 화면 캡처
- [x] 9. 브랜치에 커밋 (GitHub·Vercel 반영은 따로 확인 후)

## 2026-11-17 — 포트폴리오 Vercel 배포 준비 (배포 클릭은 사용자가 직접)

> 상태: ✅ 준비 완료 — Vercel에서 Import·Deploy는 사용자가 직접 (docs/vercel-배포가이드.md)
> 방식: Vercel이 private 레포 `claude-workspace`를 가져가되, **Root Directory = `portfolio`** 로 설정해서 포트폴리오 폴더만 공개

### 단계
- [x] 1. 대기 중인 화이트모드를 `portfolio-white` 브랜치에 커밋 → `main`에 머지 (Vercel은 main을 배포)
- [x] 2. `portfolio/vercel.json` 새로 만들기: 보안 헤더(다른 사이트에 몰래 끼워넣기 방지 등) + 주소 정리
- [x] 3. `docs/vercel-배포가이드.md` 새로 만들기: 클릭 순서 안내 (portfolio 폴더 밖이라 공개되지 않음)
- [x] 4. 커밋 → GitHub 업로드 → 올라간 파일 확인 → `progress.md` 기록

### ⚠️ 배포 전 확인
- `portfolio/index.html`에 휴대폰 번호·이메일이 있음 → 배포하면 **누구나 볼 수 있음**

## 2026-11-17 — 포트폴리오 화이트모드 (브랜치 작업)

> 상태: ✅ 완료 (main에 머지, GitHub 업로드)
> 브랜치: `portfolio-white` → 확인 후 `main`에 머지 → GitHub 업로드

### 색 바꾸기 (다크 → 화이트)
| 이름 | 지금 (다크) | 바꿀 색 (화이트) |
|---|---|---|
| 배경 `--bg` | #161514 딥 차콜 | #ffffff 흰색 |
| 카드 배경 `--bg-raise` | #1d1c1a | #f7f5f1 아주 옅은 아이보리 |
| 글자 `--text` | #ece6dc 아이보리 | #1c1b19 거의 검정 |
| 보조 글자 `--muted` | #9a938a | #6b665f |
| 흐린 글자 `--faint` | #6b665f | #9a938a |
| 구분선 `--line` | #2f2d2a | #e7e3dc |
| 강조 `--accent` | #c9a96e 골드 | #8f6d2f 진한 골드 (흰 배경에서 잘 읽히게) |
| 상단 메뉴 배경 | 반투명 차콜 | 반투명 흰색 |

### 단계
- [x] 0. main에 남아 있는 작업 기록(todo.md, progress.md) 변경을 먼저 커밋
- [x] 1. 새 브랜치 `portfolio-white` 만들기
- [x] 2. `portfolio/index.html` 색 변경 (기존 `index.html.bak`은 그대로 두고, 다크 버전은 `index.html.dark.bak`으로 새로 백업)
- [x] 3. 브라우저(Edge)로 PC·모바일 화면 캡처 → **보여드리고 OK 받기**
- [x] 4. 브랜치에 커밋 → `main`에 머지
- [x] 5. GitHub에 업로드 → 확인 → `progress.md` 기록

## 2026-11-17 — claude-workspace를 GitHub에 올리기

> 상태: ✅ 완료 (커밋 b351ce7, PRIVATE 확인, 11개 업로드 / 5개 제외)
> 레포: `urmyheartforever/claude-workspace` (**private**) / 첫 커밋: `Initial setup`
> 작성자: `urmyheartforever` / `357676600+urmyheartforever@users.noreply.github.com` (실제 이메일 노출 안 됨, 이 폴더에만 설정)

### 단계
- [x] 1. `.gitignore` 만들기
  - 민감 파일: `.env`, `.env.*`(단 `.env.example`은 허용), `*.key`, `*.pem`, `id_rsa*`, `*credentials*`
  - 개인 문서: `resume.pdf`, `자기소개서_*.md`, `*.bak`, `tasks/downloads-move-log.txt`
  - 기타: 파이썬 캐시(`__pycache__/`), Windows 시스템 파일(`desktop.ini`, `Thumbs.db`)
- [x] 2. `README.md` 정리 (수정 전 `README.md.bak`으로 백업, 백업은 업로드 제외)
  - 실제 폴더 구조 반영 (portfolio / scripts / tasks / 샘플 데이터)
  - "GitHub에 안 올라가는 파일" 표 추가
- [x] 3. `git init` → 작성자 설정(이 폴더만) → `git add .`
- [x] 4. **올라갈 파일 목록 확인** (민감·개인 파일이 빠졌는지 검사) → 보여드리고 OK 받기
- [x] 5. 커밋 `Initial setup`
- [x] 6. `gh repo create --private`로 레포 만들고 업로드(push)
- [x] 7. GitHub에서 private 여부와 파일 목록 확인 → `progress.md` 기록

### 참고
- `portfolio/index.html`에는 휴대폰 번호가 있지만, 선택하신 대로 그대로 올라감 (private 레포)

## 2026-11-17 — 포트폴리오 웹페이지

> 상태: ✅ 완료 (이력서 기반, 최장 경력 3곳, 연락처 = 이메일+휴대폰)

- [x] 1. 정보 출처 확정 (CLAUDE.md는 이름·경력·연락처가 비어 있음 → resume.pdf 사용 여부 확인)
- [x] 2. `portfolio/index.html` 만들기 (파일 하나, 인터넷 연결 없이 열림, 반응형)
  - 소개 / 경력 3개 / 연락처
- [x] 3. 브라우저로 열어서 PC 화면·모바일 화면 확인
- [x] 4. `tasks/progress.md` 기록

### 보안 메모
- 집 주소·휴대폰 번호는 기본으로 넣지 않기 (웹페이지는 공유되기 쉬움)
- 인터넷에 올리지 않고 **내 컴퓨터에서만** 열기

## 2026-11-17 — 고양시 날씨·미세먼지 자동 저장

> 상태: ⏸️ 자동 실행 꺼짐 (작업 스케줄러 GoyangWeather = Disabled, 스크립트·weather.txt는 보관)

### 사용할 서비스 (API 키 필요 없음)
- **Open-Meteo** (open-meteo.com): 무료, 가입·키 없이 사용 가능
  - 날씨: 기온, 체감온도, 하늘 상태, 강수확률, 습도, 바람
  - 대기질: 미세먼지(PM10), 초미세먼지(PM2.5) + 한국 환경부 기준 등급(좋음/보통/나쁨/매우나쁨)
- 보내는 정보: 고양시 **시청 부근 좌표**(위도 37.66, 경도 126.83)만. 집 주소 등 개인정보는 보내지 않음

### 단계
- [x] 1. `scripts/goyang_weather.py` 만들기 (파이썬, 추가 설치 없이 기본 기능만 사용)
- [x] 2. 시험 실행 → `weather.txt` 내용 확인
- [x] 3. Windows **작업 스케줄러**에 "매일 오전 9시 실행" 등록 (컴퓨터가 꺼져 있었다면 켜질 때 실행)
- [x] 4. 등록 확인 → `tasks/progress.md` 기록

### 되돌리는 방법
- 자동 실행 끄기: 작업 스케줄러에서 `GoyangWeather` 작업 삭제 (명령어 한 줄)

## 2026-11-17 — 다운로드 폴더 정리

> 상태: ✅ 완료 (151개 이동, 건너뜀 0개, 덮어쓰기 0개)
> 결정: .html·.pem → misc / desktop.ini → 그대로 둠
> 대상: `C:\Users\user\Downloads` 맨 위에 있는 파일 152개 (하위 폴더 안쪽은 건드리지 않음)

### 안전장치
- 새로 만들 폴더 5개(exe/zip/images/docs/misc)는 **지금 모두 없음**. 그래서 같은 이름 파일과 부딪칠 일이 없음
- 그래도 `mv -n`(같은 이름이 있으면 **옮기지 않고 건너뜀**)을 사용. 덮어쓰기는 일어나지 않음
- 옮기기 전에 "원래 위치 → 새 위치" 목록을 `tasks/downloads-move-log.txt`에 저장. 나중에 되돌릴 때 사용

### 분류 계획
- [x] **폴더 8개** → 그대로 둠
- [x] **exe/** ← .exe 51개 + .msi 3개(설치 파일) = 54개
- [x] **zip/** ← .zip 8개 + .tar.gz 3개 + .egg 2개(압축) = 13개
- [x] **images/** ← .png 10개 + .jpg 1개 + .HEIC 2개 = 13개
- [x] **docs/** ← .pdf 20 + .docx 3 + .xlsx 2 + .xls 1 + .pptx 1 + .txt 4 = 31개
- [x] **.html 8개** → docs 또는 misc (확인 필요)
- [x] **misc/** ← .war 16 + .scx 5 + .scm 3 + .rep 3 + .log 1 + 확장자 없음 2 = 30개
- [x] ⚠️ **.pem 2개** (`linux-start-key.pem`, `linux-start2-key.pem`): 서버 접속 열쇠로 보임 → 처리 방법 확인 필요
- [x] ⚠️ **desktop.ini 1개**: Windows가 폴더 표시용으로 쓰는 숨김 시스템 파일 → 그대로 두기 권장

### 실행 후 확인
- [x] 폴더별 파일 개수가 계획과 같은지 확인
- [x] 다운로드 맨 위에 남은 파일 확인
- [x] `tasks/progress.md`에 기록

## 2026-11-17 — 작업 환경 구축

> 상태: ✅ 1·3단계 + README 완료 / 2·4단계 대기 중

### 1단계: 작업 기록 파일 ✅
- [x] `tasks/todo.md` 만들기 (이 파일)
- [x] `tasks/progress.md` 만들기 (한 일을 쌓아두는 기록장)

### 2단계: 보안 기본 설정
- [ ] `.gitignore` 만들기: `.env`, `*.key`, `*.pem`, `id_rsa`, `credentials` 등이 Git에 올라가지 않도록 막기
- [ ] `.env.example` 만들기: 어떤 키가 필요한지만 적은 **빈 견본** (실제 키 없음)
- [ ] `.env` 만들기: 빈 칸만 있는 파일. 실제 키는 사용자가 직접 입력

### 3단계: 비상 매뉴얼 ✅
- [x] `SECURITY.md` 만들기: 키 노출 시 대응 순서 (OpenRouter / Oracle / WordPress별 폐기 → 재발급 → 교체 → 사용 이력 확인)

### 추가: 폴더 안내서 ✅
- [x] `README.md` 만들기: 폴더 구조와 파일별 용도 정리

### 4단계: 오라클 서버 SSH 연결 (⚠️ 사용자 확인 필요)
- [ ] `~/.ssh/oracle-server.key` 파일 준비: 현재 **없음**. 사용자가 키 파일을 가지고 있어야 함
- [ ] `~/.ssh/config`에 `oracle-server` 별칭 등록: 서버 IP 주소와 사용자 이름 필요
- [ ] 연결 테스트 (`ssh oracle-server`)

### 5단계: 확인 및 기록
- [ ] 만든 파일 목록과 `.gitignore` 동작 확인
- [ ] `tasks/progress.md`에 오늘 한 일 기록
