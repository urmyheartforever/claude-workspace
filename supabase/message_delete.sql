-- ─────────────────────────────────────────────────────────────
-- 방명록 삭제 기능 (비밀번호 방식) — message_edit.sql 다음에 실행
-- 실행: Supabase 대시보드 → SQL Editor → 이 파일 내용 전체 붙여넣기 → Run
--
--  · delete_message(id, 비밀번호): 맞으면 삭제하고 true, 틀리거나 글이 없으면 false
--  · 표에서 직접 삭제(DELETE)는 계속 금지 — 이 함수로만 가능
-- ─────────────────────────────────────────────────────────────

create or replace function public.delete_message(p_id bigint, p_password text)
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

  delete from public.message where id = p_id;
  return true;
end;
$$;

-- 실행 권한: 방문자(anon)와 로그인 사용자만
revoke all on function public.delete_message(bigint, text) from public, anon, authenticated;
grant execute on function public.delete_message(bigint, text) to anon, authenticated;

-- API에 바로 반영
notify pgrst, 'reload schema';

-- 확인용: delete_message 한 줄이 보이면 성공
select routine_name from information_schema.routines
 where routine_schema = 'public' and routine_name = 'delete_message';
