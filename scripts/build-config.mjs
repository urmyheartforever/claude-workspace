// .env.local (또는 Vercel 환경변수) → portfolio/config.js 생성
// 사용: node scripts/build-config.mjs
// ⚠️ anon(공개용) 키만 넣으세요. service_role 키는 절대 금지.
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const envFile = join(root, ".env.local");

// 1) .env.local 읽기 (없으면 시스템 환경변수 사용 — Vercel 배포용)
const env = { ...process.env };
if (existsSync(envFile)) {
  for (const line of readFileSync(envFile, "utf8").split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
    if (m) env[m[1]] = m[2].replace(/^["']|["']$/g, "");
  }
}

const url = env.SUPABASE_URL;
const key = env.SUPABASE_ANON_KEY;
if (!url || !key) {
  console.error("SUPABASE_URL / SUPABASE_ANON_KEY 가 없습니다. .env.local 을 확인하세요.");
  process.exit(1);
}

// 2) 안전장치: service_role 키면 중단
try {
  const payload = JSON.parse(Buffer.from(key.split(".")[1], "base64url").toString());
  if (payload.role !== "anon") {
    console.error(`🚨 anon 키가 아닙니다 (role=${payload.role}). 중단합니다.`);
    process.exit(1);
  }
} catch {
  // 새 형식 키(sb_publishable_...)는 JWT가 아니므로 접두어로 확인
  if (key.startsWith("sb_secret_")) {
    console.error("🚨 secret 키입니다. 중단합니다.");
    process.exit(1);
  }
}

// 3) config.js 쓰기
const out = join(root, "portfolio", "config.js");
writeFileSync(
  out,
  `// 자동 생성 파일 (scripts/build-config.mjs) — 직접 수정·커밋하지 마세요\n` +
    `window.SUPABASE_CONFIG = ${JSON.stringify({ url, anonKey: key })};\n`,
);
console.log(`config.js 생성 완료 → ${url} (key: ${key.slice(0, 6)}***)`);
