-- ─────────────────────────────────────────────────────────────
-- 포트폴리오 방명록: message 테이블 — Supabase / Postgres
-- 정책: 누구나 읽기 + 누구나 쓰기 / 수정·삭제는 불가
-- 실행: Supabase 대시보드 → SQL Editor → 이 파일 내용 전체 붙여넣기 → Run
-- ─────────────────────────────────────────────────────────────

-- 1) 테이블
create table if not exists public.message (
  id          bigint generated always as identity primary key,
  name        text        not null
              check (char_length(btrim(name)) between 1 and 30),
  content     text        not null
              check (char_length(btrim(content)) between 1 and 500),
  created_at  timestamptz not null default now()
);

comment on table  public.message            is '포트폴리오 방명록';
comment on column public.message.name       is '작성자 이름 (1~30자)';
comment on column public.message.content    is '메시지 내용 (1~500자)';
comment on column public.message.created_at is '작성시간 (서버 시간, 자동)';

-- 2) 최신순 조회용 색인
create index if not exists message_created_at_idx
  on public.message (created_at desc);

-- 3) RLS 켜기
alter table public.message enable row level security;

-- 4) 누구나 읽기
drop policy if exists "message_select_public" on public.message;
create policy "message_select_public"
  on public.message for select
  to anon, authenticated
  using (true);

-- 5) 누구나 쓰기
drop policy if exists "message_insert_public" on public.message;
create policy "message_insert_public"
  on public.message for insert
  to anon, authenticated
  with check (true);

-- update / delete 정책 없음 → 수정·삭제 불가 (관리자만 대시보드에서)

-- 6) 권한 좁히기: 방문자는 name, content 두 칸만 쓸 수 있음
revoke all on public.message from anon, authenticated;
grant select on public.message to anon, authenticated;
grant insert (name, content) on public.message to anon, authenticated;

-- 7) 확인용: 아래 결과에 정책 2개가 보이면 성공
select policyname, cmd from pg_policies where tablename = 'message';
