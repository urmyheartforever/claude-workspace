# 📁 claude-workspace

Claude Code와 함께 작업하는 **메인 작업 폴더**입니다.
처음 열었다면 이 파일부터 읽으세요.

> 🔒 이 저장소는 **private**(나만 보기)입니다. 공개로 바꾸기 전에 개인정보가 없는지 꼭 확인하세요.

---

## 폴더 구조

```
claude-workspace/
├── README.md               ← 지금 보는 파일 (폴더 안내서)
├── CLAUDE.md               ← Claude Code가 지킬 규칙 (지침서)
├── SECURITY.md             ← 🚨 키 노출 시 비상 매뉴얼
├── .gitignore              ← GitHub에 올리지 않을 파일 목록
│
├── tasks/                  ← 작업 기록
│   ├── todo.md             ← 할 일 (계획 + 체크리스트)
│   └── progress.md         ← 한 일 기록 (지우지 않고 계속 추가)
│
├── portfolio/              ← 포트폴리오 웹페이지 (🌐 Vercel로 이 폴더만 공개)
│   ├── index.html          ← 브라우저로 바로 열리는 한 장짜리 페이지
│   └── vercel.json         ← Vercel 배포 설정 (보안 헤더)
│
├── docs/                   ← 안내서
│   └── vercel-배포가이드.md ← Vercel 배포 클릭 순서
│
├── scripts/                ← 자동화 스크립트
│   └── goyang_weather.py   ← 고양시 날씨·미세먼지 → weather.txt 저장
│
├── weather.txt             ← 날씨 스크립트가 쌓은 기록
├── sample.csv              ← 연습용 매출 샘플 데이터
└── sample_분석결과.md      ← sample.csv 분석 결과
```

---

## 각 파일 한눈에 보기

| 파일 | 누가 읽나? | 언제 보나? |
|---|---|---|
| `README.md` | 나 | 폴더 구조가 헷갈릴 때 |
| `CLAUDE.md` | Claude Code (자동) | 매 작업 시작 시 자동으로 읽힘. 규칙을 바꾸고 싶을 때 수정 |
| `SECURITY.md` | 나 + Claude Code | 키가 노출된 것 같을 때 **즉시** |
| `tasks/todo.md` | 나 + Claude Code | 작업 **시작할 때**. 할 일 확인 |
| `tasks/progress.md` | 나 + Claude Code | 작업 **끝날 때**. 한 일 기록 |
| `portfolio/index.html` | 나 | 포트폴리오를 볼 때 (더블클릭으로 열기) |
| `scripts/goyang_weather.py` | 컴퓨터 | 날씨 기록이 필요할 때 실행 (API 키 필요 없음) |

---

## 🙈 GitHub에 올라가지 않는 파일

`.gitignore`에 적혀 있어서 **내 컴퓨터에만** 남는 파일들입니다.

| 종류 | 파일 | 이유 |
|---|---|---|
| 🔒 비밀 | `.env`, `*.key`, `*.pem`, `id_rsa`, `credentials` | 키·비밀번호 보호 |
| 👤 개인 문서 | `resume.pdf`, `자기소개서_*.md` | 개인정보 |
| 📋 로그 | `tasks/downloads-move-log.txt` | 다운로드 폴더 파일 목록 |
| 💾 백업 | `*.bak` | 수정 전 백업본 (내 컴퓨터용) |
| 🪟 시스템 | `__pycache__/`, `desktop.ini`, `Thumbs.db` | 자동 생성 파일 |

> `.env.example`(키 **이름만** 적은 견본)은 올려도 됩니다.

---

## 하루 작업 흐름

```
1. 시작  →  tasks/todo.md 확인
2. 계획  →  3단계 이상 작업은 todo.md에 계획 먼저 적고 OK
3. 실행  →  한 단계씩, 확인하면서
4. 종료  →  tasks/progress.md에 한 일 기록
5. 저장  →  GitHub에 올리기 (git add → commit → push)
```

---

## 🔒 꼭 기억할 보안 규칙

- 키·비밀번호는 **`.env` 파일에만** 저장합니다
- 채팅·문서·스크린샷에 키를 붙여넣지 않습니다
- 노출이 의심되면 → **`SECURITY.md`** 를 열거나 Claude Code에 "키 노출 의심"이라고 말합니다

---

## 외부 연결

| 항목 | 위치 | 상태 |
|---|---|---|
| GitHub | `urmyheartforever/claude-workspace` (private) | ✅ 연결됨 |
| 오라클 서버 SSH 키 | `~/.ssh/oracle-server.key` | ⏳ 미설정 |
| 오라클 서버 별칭 | `~/.ssh/config` 의 `oracle-server` | ⏳ 미설정 |
