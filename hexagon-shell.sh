#!/bin/bash
# ============================================
# HexagonOS 0.1 - Hexagon Shell
# 命令逻辑与 0.0.1 的 kernel.c 一致
# ============================================

# 数据目录
HEX_DATA="$HOME/HexagonFiles"
mkdir -p "$HEX_DATA/docs/notes" "$HEX_DATA/system" "$HEX_DATA/home"

# ---- 显示欢迎语 ----
clear
echo "Welcome to HexagonOS 0.1"
echo "Type 'help' to see available commands."
echo ""

# ---- 主循环 ----
while true; do
    echo -n "> "
    read -r command

    case "$command" in
        "time")
            echo "Current time: $(date '+%Y-%m-%d %H:%M:%S')"
            ;;

        "Home page")
            echo "Files in root:"
            if [ -d "$HEX_DATA" ]; then
                find "$HEX_DATA" -type f | sed "s|$HEX_DATA|  |" | sed 's|^\(.*\)$|<\1>|'
            fi
            ;;

        "open "*)
            path="${command#open }"
            clean_path=$(echo "$path" | sed 's/^<//; s/>$//')
            full_path="$HEX_DATA/$clean_path"
            if [ -f "$full_path" ]; then
                echo "Opening: $path"
                echo "Content:"
                cat "$full_path"
            else
                echo "Error: File not found."
            fi
            ;;

        "Create document")
            echo "Entering edit mode."
            echo "Type content line by line."
            echo "Type 'save <file_path>' to save and exit."
            echo "--------------------------------------"
            content=""
            while true; do
                echo -n "| "
                read -r line
                if [[ "$line" == save* ]]; then
                    save_path="${line#save }"
                    clean_path=$(echo "$save_path" | sed 's/^<//; s/>$//')
                    full_path="$HEX_DATA/$clean_path"
                    mkdir -p "$(dirname "$full_path")"
                    echo "$content" > "$full_path"
                    echo "Saving to: $save_path"
                    echo "Saved."
                    echo "Exited edit mode."
                    break
                else
                    content="${content}${line}
"
                    echo "  [line recorded]"
                fi
            done
            ;;

        "rename "*)
            args="${command#rename }"
            old=$(echo "$args" | awk '{print $1}' | sed 's/^<//; s/>$//')
            new=$(echo "$args" | awk '{print $2}' | sed 's/^<//; s/>$//')
            if [ -z "$old" ] || [ -z "$new" ]; then
                echo "Usage: rename <old_path> <new_path>"
                echo "Example: rename <docs/a.txt> <docs/b.txt>"
            elif [ -f "$HEX_DATA/$old" ]; then
                mkdir -p "$(dirname "$HEX_DATA/$new")"
                mv "$HEX_DATA/$old" "$HEX_DATA/$new"
                echo "Renamed: <$old> -> <$new>"
            else
                echo "Error: File not found."
            fi
            ;;

        "Shut down")
            echo "Shutting down HexagonOS..."
            sleep 1
            sudo poweroff
            ;;

        "help")
            echo "Available commands:"
            echo "  time"
            echo "  Home page"
            echo "  open <file>"
            echo "  Create document"
            echo "  rename <old> <new>"
            echo "  Shut down"
            echo "  help"
            ;;

        "")
            ;;

        *)
            echo "Unknown command. Type 'help' for list."
            ;;
    esac
done