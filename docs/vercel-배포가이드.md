# 🚀 포트폴리오 Vercel 배포 가이드

`portfolio/` 폴더만 인터넷에 공개하는 방법입니다.
`claude-workspace` 레포는 **private 그대로** 둡니다.

---

## ⚠️ 가장 중요한 한 가지

> **Root Directory를 반드시 `portfolio` 로 지정하세요.**
>
> 지정하지 않으면 `CLAUDE.md`, `SECURITY.md`, `tasks/` 작업 기록까지
> 인터넷에 공개될 수 있습니다.

---

## 처음 배포하기 (한 번만)

1. https://vercel.com 접속 → **Continue with GitHub** 로 로그인
2. 오른쪽 위 **Add New… → Project**
3. **Import Git Repository** 목록에서 `claude-workspace` 옆 **Import**
   - 목록에 안 보이면 → **Adjust GitHub App Permissions** 를 눌러
     `claude-workspace` 레포 접근을 허용
4. **Configure Project** 화면에서:

   | 항목 | 입력값 |
   |---|---|
   | Project Name | 원하는 이름 (예: `portfolio`) → 주소가 `portfolio-xxx.vercel.app` 처럼 됨 |
   | Framework Preset | **Other** |
   | **Root Directory** | **Edit** 눌러서 → **`portfolio`** 선택 ⚠️ |
   | Build Command | 비워 두기 |
   | Output Directory | 비워 두기 |
   | Environment Variables | 없음 (키 필요 없음) |

5. **Deploy** 클릭 → 1분 안에 완료
6. 나온 주소(`https://….vercel.app`)를 열어 확인

---

## 배포 후 꼭 확인할 것 ✅

- [ ] 주소를 열면 포트폴리오가 **흰 배경**으로 보인다
- [ ] 주소 뒤에 `/CLAUDE.md` 를 붙여 열면 **404 (페이지 없음)** 가 나온다
  → 404면 정상. 내용이 보이면 Root Directory 설정이 잘못된 것이므로
    **즉시** Settings → General → Root Directory 를 `portfolio` 로 고치고 다시 배포
- [ ] 휴대폰으로도 열어 본다

---

## 수정하면 자동 반영

`main` 브랜치에 올리면(push) Vercel이 **자동으로 다시 배포**합니다.

```
포트폴리오 수정 → git commit → git push → 1분 뒤 사이트 반영
```

다른 브랜치에 올리면 **미리보기 주소**만 따로 생기고, 실제 사이트는 바뀌지 않습니다.

---

## 파일 설명

| 파일 | 역할 |
|---|---|
| `portfolio/index.html` | 포트폴리오 페이지 (공개됨) |
| `portfolio/vercel.json` | Vercel 설정. 다른 사이트에 몰래 끼워넣기 방지 등 보안 설정 |
| `docs/vercel-배포가이드.md` | 지금 보는 파일 (공개 안 됨) |

---

## 🔒 공개되는 개인정보

`portfolio/index.html`의 **이메일·휴대폰 번호**는 누구나 볼 수 있습니다.
빼고 싶으면 해당 줄을 지우고 다시 push 하세요.
