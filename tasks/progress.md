# 작업 기록 (progress)

> 한 일을 날짜순으로 쌓아두는 기록장입니다. **내용을 지우지 않고 아래에 계속 추가만 합니다.** (append-only)

---

## 2026-11-17

- `tasks/` 폴더 생성
- `tasks/todo.md` 생성: 작업 환경 구축 계획(1~5단계) 작성
- `tasks/progress.md` 생성: 이 기록장
- `SECURITY.md` 생성: 키 노출 비상 매뉴얼 (OpenRouter / Oracle SSH / WordPress별 폐기 → 재발급 → 교체 → 이력 확인, Git 업로드 시 주의, 예방 체크리스트)
- `README.md` 생성: 폴더 구조, 파일별 용도, 하루 작업 흐름, 보안 규칙 요약
- 다운로드 폴더 정리: 파일 151개 분류 (exe 54 / zip 13 / images 13 / docs 31 / misc 40), 폴더 8개·desktop.ini는 그대로 둠. 덮어쓰기 0, 건너뜀 0
  - 이동 기록: `tasks/downloads-move-log.txt` (되돌리기용)
  - ⚠️ `misc/`에 서버 열쇠 파일(.pem) 2개 있음 → 오라클 서버 설정 때 `~/.ssh`로 옮길 예정
- `자기소개서_IT강의_초안.md` 생성: resume.pdf 기반 IT 강의 직무 자기소개서 초안 (성장과정·지원동기·입사 후 포부, 공백 포함 790자)
- `sample.csv` 분석 → `sample_분석결과.md` 생성: 월별 트렌드, Top 5, 이상치(ORD-2026-0059 매출 입력 오류 의심 등), 인사이트 3줄
- 고양시 날씨·미세먼지 자동 저장 구축
  - `scripts/goyang_weather.py` 생성 (Open-Meteo, API 키 없음, 고양시청 부근 좌표만 전송) → `weather.txt`에 날짜별로 아래에 쌓기
  - Windows 작업 스케줄러 `GoyangWeather` 등록: 매일 09:00, 놓치면 켜질 때 실행, 창 없이 실행(pythonw)
  - 확인: 작업 스케줄러로 직접 실행 → 결과 코드 0, weather.txt 정상 기록
  - 이슈: Claude Code 터미널(Bash)에서는 api.open-meteo.com 연결 시간 초과 → Windows/PowerShell에서는 정상. 실제 자동 실행에는 영향 없음
- 날씨 자동 실행 끔: 작업 스케줄러 `GoyangWeather` → 사용 안 함(Disabled). 삭제는 안 함, 스크립트·weather.txt 보관
- 포트폴리오 웹페이지 `portfolio/index.html` 생성
  - 정보 출처: resume.pdf (CLAUDE.md는 이름·경력·연락처 빈칸이라 사용자 확인 후 이력서 사용)
  - 구성: 소개(강의 분야·학력) / 경력 3곳(서울예술실용전문학교·강동대·아너스원격평생교육원) / 연락처(이메일·휴대폰)
  - 파일 하나, 외부 연결 없음, 반응형 + 다크 모드. PC(1280px)·모바일(390px) 캡처로 확인
  - 인터넷 공개 안 함 (연락처 포함)
- 포트폴리오 디자인 변경: 다크 에디토리얼
  - 이전 디자인은 `portfolio/index.html.bak`으로 백업
  - 딥 차콜 배경 + 브라스 골드 포인트. 글꼴: 제목 Cormorant Garamond + Noto Serif KR, 본문 DM Sans + Noto Sans KR (Google Fonts)
  - KPI 숫자 애니메이션 카운터: 28년 / 21곳 / 1998 / 2개. 최종값 확인, 최종값 보장 안전장치 추가
  - PC·모바일 캡처로 확인
- GitHub CLI(gh) 설치: winget 공식 패키지 GitHub.cli v2.104.0 → `C:\Program Files\GitHub CLI\gh.exe`, `gh --version` 동작 확인. 로그인(gh auth login)은 아직 안 함

## 2026-11-17
- GitHub CLI(gh 2.104.0) 로그인 완료: 계정 urmyheartforever, HTTPS, 토큰은 Windows 자격 증명 관리자에 저장
- 참고: 현재 터미널은 gh 경로를 몰라서 전체 경로로 실행함. 터미널을 재시작하면 `gh`만 입력해도 됨
- claude-workspace를 GitHub에 업로드: https://github.com/urmyheartforever/claude-workspace (**PRIVATE** 확인)
  - `.gitignore` 새로 만듦: 키·.env·.pem 등 + 개인 문서(resume.pdf, 자기소개서) + *.bak + downloads-move-log 제외
  - `README.md` 실제 구조로 정리 (원본은 README.md.bak, 업로드 안 됨)
  - 첫 커밋 `Initial setup` (b351ce7), 작성자 = GitHub 비공개 이메일 (이 폴더에만 설정)
  - `gh auth setup-git` 실행: git이 gh 로그인으로 push하도록 연결
- 포트폴리오 화이트모드: `portfolio-white` 브랜치에서 색 변경 → Edge 캡처로 확인 → main 머지 (046382a, af04e92)
  - 다크 버전 백업: `portfolio/index.html.dark.bak` (업로드 안 됨)
  - 모바일 캡처에서 오른쪽 글자 잘림 발견. 다크 버전도 동일 → 이번 변경과 무관. 원인 미확인 (추가 확인 필요)
- Vercel 배포 준비: `portfolio/vercel.json`(보안 헤더), `docs/vercel-배포가이드.md` 추가, README 구조 갱신 → GitHub 업로드
  - Vercel에서 **Root Directory = portfolio** 필수 (안 하면 CLAUDE.md 등 공개될 위험)
  - Import·Deploy 클릭은 사용자가 직접
