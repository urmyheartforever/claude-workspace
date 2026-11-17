-- ─────────────────────────────────────────────────────────────
-- 방명록 (guestbook) — Supabase / Postgres
-- 정책: 누구나 읽기 + 누구나 작성 / 수정·삭제는 불가
-- 실행: Supabase 대시보드 → SQL Editor → 이 파일 내용 붙여넣기 → Run
-- ─────────────────────────────────────────────────────────────

-- 1) 테이블
create table if not exists public.guestbook (
  id          bigint generated always as identity primary key,  -- 자동 번호 (직접 넣을 수 없음)
  name        text        not null
              check (char_length(btrim(name)) between 1 and 30),     -- 이름: 공백 제외 1~30자
  message     text        not null
              check (char_length(btrim(message)) between 1 and 500), -- 메시지: 공백 제외 1~500자
  created_at  timestamptz not null default now()                     -- 작성시간: 서버가 자동 기록
);

comment on table  public.guestbook            is '포트폴리오 방명록';
comment on column public.guestbook.name       is '작성자 이름 (1~30자)';
comment on column public.guestbook.message    is '방명록 메시지 (1~500자)';
comment on column public.guestbook.created_at is '작성시간 (서버 시간, 자동)';

-- 2) 최신순 조회를 빠르게
create index if not exists guestbook_created_at_idx
  on public.guestbook (created_at desc);

-- 3) RLS(행 단위 보안) 켜기 — 켜면 "정책으로 허용한 것만" 가능
alter table public.guestbook enable row level security;

-- 4) 정책: 누구나 읽기
drop policy if exists "guestbook_select_public" on public.guestbook;
create policy "guestbook_select_public"
  on public.guestbook
  for select
  to anon, authenticated
  using (true);

-- 5) 정책: 누구나 작성
drop policy if exists "guestbook_insert_public" on public.guestbook;
create policy "guestbook_insert_public"
  on public.guestbook
  for insert
  to anon, authenticated
  with check (true);

-- ※ update / delete 정책은 일부러 만들지 않음 → 아무도 수정·삭제 불가
--    (삭제는 Supabase 대시보드에서 관리자만)

-- 6) 권한 좁히기 (이중 안전장치)
--    Supabase는 기본으로 모든 권한을 열어 두므로, 필요한 것만 다시 허용
revoke all on public.guestbook from anon, authenticated;
grant select on public.guestbook to anon, authenticated;
grant insert (name, message) on public.guestbook to anon, authenticated;
--    → 방문자는 name, message 두 칸만 쓸 수 있음
--    → created_at(작성시간)을 조작하거나 id를 지정할 수 없음
