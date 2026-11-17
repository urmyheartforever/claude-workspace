-- ─────────────────────────────────────────────────────────────
-- 방명록 수정 기능 (비밀번호 방식) — message.sql 다음에 실행
-- 실행: Supabase 대시보드 → SQL Editor → 이 파일 내용 전체 붙여넣기 → Run
--
-- 바뀌는 점
--  · 글 쓰기: 표에 직접 쓰기 금지 → create_message() 함수로만 (비밀번호 필수)
--  · 글 수정: update_message() 함수로만 (비밀번호가 맞을 때만)
--  · 비밀번호는 bcrypt로 암호화 저장, 방문자는 password_hash 칸을 읽을 수 없음
-- ─────────────────────────────────────────────────────────────

-- 0) 암호화 도구 (Supabase는 보통 이미 켜져 있음)
create extension if not exists pgcrypto with schema extensions;

-- 1) 칸 추가
alter table public.message add column if not exists password_hash text;
alter table public.message add column if not exists updated_at   timestamptz;

comment on column public.message.password_hash is '수정용 비밀번호 (bcrypt 암호화, 방문자 읽기 금지)';
comment on column public.message.updated_at    is '마지막 수정 시간 (수정한 적 없으면 비어 있음)';

-- 2) 방문자 권한 다시 정리
revoke all on public.message from anon, authenticated;
--    읽기: 비밀번호 칸을 뺀 나머지만
grant select (id, name, content, created_at, updated_at) on public.message to anon, authenticated;
--    직접 쓰기 정책은 더 이상 쓰지 않으므로 삭제 (쓰기는 아래 함수로만)
drop policy if exists "message_insert_public" on public.message;

-- 3) 글 쓰기 함수
create or replace function public.create_message(p_name text, p_content text, p_password text)
returns bigint
language plpgsql
security definer
set search_path = ''
as $$
declare
  new_id bigint;
begin
  if p_password is null or char_length(p_password) < 4 or octet_length(p_password) > 72 then
    raise exception '비밀번호는 4자 이상(최대 72바이트)으로 입력해 주세요.' using errcode = '22023';
  end if;

  insert into public.message (name, content, password_hash)
  values (btrim(p_name), btrim(p_content),
          extensions.crypt(p_password, extensions.gen_salt('bf', 10)))
  returning id into new_id;

  return new_id;
end;
$$;

-- 4) 글 수정 함수 — 비밀번호가 맞으면 true, 틀리거나 글이 없으면 false
create or replace function public.update_message(p_id bigint, p_password text, p_content text)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  h text;
begin
  select password_hash into h from public.message where id = p_id for update;

  if h is null or extensions.crypt(coalesce(p_password, ''), h) <> h then
    return false;
  end if;

  update public.message
     set content = btrim(p_content),
         updated_at = now()
   where id = p_id;

  return true;
end;
$$;

-- 5) 함수 실행 권한: 방문자(anon)와 로그인 사용자만
revoke all on function public.create_message(text, text, text)   from public, anon, authenticated;
revoke all on function public.update_message(bigint, text, text) from public, anon, authenticated;
grant execute on function public.create_message(text, text, text)   to anon, authenticated;
grant execute on function public.update_message(bigint, text, text) to anon, authenticated;

-- 6) API에 새 함수 바로 반영
notify pgrst, 'reload schema';

-- 7) 확인용: 함수 2개가 보이면 성공
select routine_name from information_schema.routines
 where routine_schema = 'public' and routine_name in ('create_message', 'update_message');
