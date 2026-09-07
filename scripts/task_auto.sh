#!/bin/bash

# 1. Khởi chạy Antigravity với Profile và Project đúng
# Sử dụng fvm nếu dự án của bạn yêu cầu
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
antigravity --user-data-dir ~/antigravity-danhdue "$PROJECT_DIR"

echo "⏳ Waiting for Antigravity to initialize (10s)..."
sleep 10 # Tăng thời gian chờ để đảm bảo AI Engine đã load xong

# 2. Sử dụng AppleScript để Chọn Model và Bơm Prompt
osascript <<EOD
tell application "System Events"
    tell process "Antigravity"
        set frontmost to true
        delay 1
        
        -- BƯỚC CHỌN MODEL (Sử dụng tổ hợp phím để focus vào dropdown model)
        -- Thông thường là dùng Tab để di chuyển từ ô chat lên nút chọn Model
        -- Số lần nhấn Tab có thể điều chỉnh tùy theo UI thực tế của bạn
        repeat 2 times
            key code 48 -- Phím Tab (đi ngược)
            delay 0.3
        end repeat
        
        -- Nhấn Space để mở danh sách Model
        keystroke space
        delay 0.5
        
        -- Gõ tên Model mong muốn (ví dụ Claude) và nhấn Enter
        keystroke "Gemini 3.1 Pro (High)"
        delay 0.5
        key code 36 -- Enter để chọn
        delay 0.5

        -- QUAY LẠI Ô CHAT VÀ DÁN PROMPT
        -- Nhấn Tab để quay lại ô nhập liệu
        key code 48
        delay 0.5

        set thePrompt to "1. Analyze the getTransactionByOwner method in the TransactionRemoteDataSource(in the packages/transaction module), I want handle goup TransactionEntity list by the timestamp. This method should be adapt with refresh/loadmore freature. 2. Use pr_review skills to check and fix all problems infinitely."
        
        set the clipboard to thePrompt
        keystroke "v" using {command down}
        delay 1
        
        -- Nhấn Enter để thực thi
        key code 36
    end tell
end tell
EOD

echo "🚀 QA task sent to Antigravity Agent!"