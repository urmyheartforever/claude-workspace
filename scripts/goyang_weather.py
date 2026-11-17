"""
경기도 고양시 날씨 + 미세먼지 정보를 가져와 weather.txt 아래에 추가 저장합니다.

- 데이터: Open-Meteo (https://open-meteo.com) — 무료, API 키 필요 없음
- 보내는 정보: 고양시청 부근 좌표(위도/경도)뿐
- 저장 위치: claude-workspace/weather.txt (매일 아래에 쌓기, 덮어쓰지 않음)
"""
import json
import sys
import time
import urllib.parse
import urllib.request
from datetime import datetime
from pathlib import Path

# ── 설정 ─────────────────────────────────────────────
LAT, LON = 37.6584, 126.8320  # 고양시청 부근
OUTPUT = Path(__file__).resolve().parent.parent / "weather.txt"
RETRY = 3          # 아침에 막 켜져서 인터넷이 늦게 잡힐 때를 대비해 재시도
RETRY_WAIT = 20    # 재시도 간격(초)

WEATHER_URL = "https://api.open-meteo.com/v1/forecast"
AIR_URL = "https://air-quality-api.open-meteo.com/v1/air-quality"

# 날씨 코드 → 한국어 (WMO 국제 표준 코드)
WEATHER_CODE = {
    0: "맑음", 1: "대체로 맑음", 2: "구름 조금", 3: "흐림",
    45: "안개", 48: "짙은 안개",
    51: "약한 이슬비", 53: "이슬비", 55: "강한 이슬비",
    56: "약한 어는 이슬비", 57: "어는 이슬비",
    61: "약한 비", 63: "비", 65: "강한 비",
    66: "약한 어는 비", 67: "어는 비",
    71: "약한 눈", 73: "눈", 75: "많은 눈", 77: "싸락눈",
    80: "약한 소나기", 81: "소나기", 82: "강한 소나기",
    85: "약한 눈 소나기", 86: "강한 눈 소나기",
    95: "뇌우", 96: "뇌우(우박)", 99: "강한 뇌우(우박)",
}
WEEKDAY = "월화수목금토일"


def grade_pm10(v):
    """한국 환경부 미세먼지(PM10) 등급"""
    if v is None: return "정보 없음"
    return "좋음" if v <= 30 else "보통" if v <= 80 else "나쁨" if v <= 150 else "매우나쁨"


def grade_pm25(v):
    """한국 환경부 초미세먼지(PM2.5) 등급"""
    if v is None: return "정보 없음"
    return "좋음" if v <= 15 else "보통" if v <= 35 else "나쁨" if v <= 75 else "매우나쁨"


def fetch(url, params):
    full = url + "?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(full, headers={"User-Agent": "weather-script/1.0"})
    with urllib.request.urlopen(req, timeout=15) as r:
        return json.load(r)


def get_data():
    weather = fetch(WEATHER_URL, {
        "latitude": LAT, "longitude": LON, "timezone": "Asia/Seoul",
        "current": "temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m",
        "daily": "temperature_2m_max,temperature_2m_min,precipitation_probability_max",
        "wind_speed_unit": "ms", "forecast_days": 1,
    })
    air = fetch(AIR_URL, {
        "latitude": LAT, "longitude": LON, "timezone": "Asia/Seoul",
        "current": "pm10,pm2_5",
    })
    return weather, air


def make_report(weather, air, now):
    c, d, a = weather["current"], weather["daily"], air["current"]
    sky = WEATHER_CODE.get(c["weather_code"], f"코드 {c['weather_code']}")
    pm10, pm25 = a.get("pm10"), a.get("pm2_5")
    fmt = lambda v: "-" if v is None else f"{v:.0f}"
    return (
        f"===== {now:%Y-%m-%d} ({WEEKDAY[now.weekday()]}) {now:%H:%M} · 경기도 고양시 =====\n"
        f"날씨      : {sky} / 현재 {c['temperature_2m']:.1f}℃ (체감 {c['apparent_temperature']:.1f}℃)\n"
        f"최저/최고 : {d['temperature_2m_min'][0]:.1f}℃ / {d['temperature_2m_max'][0]:.1f}℃\n"
        f"강수확률  : {d['precipitation_probability_max'][0]}%\n"
        f"습도/바람 : {c['relative_humidity_2m']}% / {c['wind_speed_10m']:.1f} m/s\n"
        f"미세먼지  : {fmt(pm10)} ㎍/㎥ ({grade_pm10(pm10)})\n"
        f"초미세먼지: {fmt(pm25)} ㎍/㎥ ({grade_pm25(pm25)})\n"
        f"\n"
    )


def main():
    now = datetime.now()
    last_error = None
    ok = False
    for attempt in range(1, RETRY + 1):
        try:
            weather, air = get_data()
            text = make_report(weather, air, now)
            ok = True
            break
        except Exception as e:  # 인터넷 끊김, 서비스 오류 등
            last_error = e
            if attempt < RETRY:
                time.sleep(RETRY_WAIT)
    else:
        text = (f"===== {now:%Y-%m-%d} ({WEEKDAY[now.weekday()]}) {now:%H:%M} · 경기도 고양시 =====\n"
                f"⚠️ 정보를 가져오지 못했습니다: {last_error}\n\n")

    with open(OUTPUT, "a", encoding="utf-8") as f:   # "a" = 아래에 추가 (덮어쓰기 아님)
        f.write(text)
    print(f"저장 완료: {OUTPUT}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
