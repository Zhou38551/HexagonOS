#!/bin/bash
# ============================================
# HexagonOS 0.2 - Hexagon Shell
# ============================================

HEX_DATA="$HOME/HexagonFiles"
HEX_HISTORY="$HOME/.hex_history"
mkdir -p "$HEX_DATA/docs/notes" "$HEX_DATA/system" "$HEX_DATA/home"

CWD=""

hex_prompt() {
    if [ -z "$CWD" ]; then
        echo "/"
    else
        echo "/$CWD"
    fi
}

hex_resolve() {
    local p="$1"
    p=$(echo "$p" | sed 's/^<//; s/>$//')
    if [ -z "$CWD" ]; then
        echo "$HEX_DATA/$p"
    else
        echo "$HEX_DATA/$CWD/$p"
    fi
}

clear
echo "Welcome to HexagonOS 0.2"
echo "Type 'help' for available commands."
echo ""

while true; do
    echo -n "$(hex_prompt) > "
    read -r command
    echo "$command" >> "$HEX_HISTORY"

    case "$command" in
        "time"|"date")
            echo "Current time: $(date '+%Y-%m-%d %H:%M:%S')"
            ;;

        "ls")
            if [ -z "$CWD" ]; then
                ls -1 "$HEX_DATA" | sed 's|^|<&>|'
            else
                ls -1 "$HEX_DATA/$CWD" | sed 's|^|<&>|'
            fi
            ;;

        "cd "*)
            target=$(echo "${command#cd }" | sed 's/^<//; s/>$//; s|/$||')
            if [ "$target" == ".." ]; then
                CWD=$(dirname "$CWD" | sed 's|^\.$||')
            elif [ -d "$HEX_DATA/$CWD/$target" ]; then
                if [ -z "$CWD" ]; then
                    CWD="$target"
                else
                    CWD="$CWD/$target"
                fi
            else
                echo "Error: Directory not found."
            fi
            ;;

        "pwd")
            echo "$(hex_prompt)"
            ;;

        "mkdir "*)
            target=$(echo "${command#mkdir }" | sed 's/^<//; s/>$//')
            full=$(hex_resolve "$target")
            mkdir -p "$full"
            echo "Created directory: $target"
            ;;

        "rm "*)
            target=$(echo "${command#rm }" | sed 's/^<//; s/>$//')
            full=$(hex_resolve "$target")
            if [ -e "$full" ]; then
                rm -rf "$full"
                echo "Deleted: $target"
            else
                echo "Error: File not found."
            fi
            ;;

        "cat "*)
            target=$(echo "${command#cat }" | sed 's/^<//; s/>$//')
            full=$(hex_resolve "$target")
            if [ -f "$full" ]; then
                cat "$full"
            else
                echo "Error: File not found."
            fi
            ;;

        "echo "*)
            echo "${command#echo }"
            ;;

        "history")
            if [ -f "$HEX_HISTORY" ]; then
                nl "$HEX_HISTORY"
            fi
            ;;

        "version")
            echo "HexagonOS 0.2 (Build: $(date '+%Y%m%d'))"
            ;;

        "clear")
            clear
            ;;

        "Home page")
            echo "Files in root:"
            find "$HEX_DATA" -type f | sed "s|$HEX_DATA|  |" | sed 's|^\(.*\)$|<\1>|'
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
            echo "HexagonOS 0.2 commands:"
            echo "  time / date        Show current time"
            echo "  ls                 List files"
            echo "  cd <path>          Change directory"
            echo "  pwd                Show current path"
            echo "  mkdir <path>       Create directory"
            echo "  rm <path>          Delete file"
            echo "  cat <path>         Show file content"
            echo "  echo <text>        Print text"
            echo "  history            Command history"
            echo "  version            Show version"
            echo "  clear              Clear screen"
            echo ""
            echo "  Home page          List all files"
            echo "  open <file>        Open a file"
            echo "  Create document    Create a new document"
            echo "  rename <old> <new> Rename a file"
            echo "  Shut down          Shutdown"
            echo "  help               This help"
            ;;

        "")
            ;;

        *)
            echo "Unknown command. Type 'help' for list."
            ;;
    esac
done
