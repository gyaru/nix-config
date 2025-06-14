#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [[ -z "${FLAKE_DIR:-}" ]]; then
    if [[ -f "flake.nix" ]]; then
        FLAKE_DIR="$(pwd)"
    elif command -v git &> /dev/null && git rev-parse --show-toplevel &> /dev/null; then
        FLAKE_DIR="$(git rev-parse --show-toplevel)"
    else
        # Fallback to home directory nix-config
        FLAKE_DIR="$HOME/projects/nix-config"
    fi
fi

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

get_current_host() {
    if [[ -f /etc/hostname ]]; then
        cat /etc/hostname
    else
        hostname
    fi
}

check_impermanence() {
    local limit=""
    local show_persisted=false
    
    if [[ $# -gt 0 ]]; then
        if [[ "$1" == "--show-persisted" ]]; then
            show_persisted=true
        elif [[ "$1" == "-n" && $# -gt 1 && "$2" =~ ^[0-9]+$ ]]; then
            limit=$2
        fi
    fi

    echo "checking for files that would be lost on reboot..."
    echo "reading persistence configuration from active mounts..."
    
    persist_dirs=()
    while IFS= read -r line; do
        mount_point=$(echo "$line" | awk '{print $3}')
        persist_dirs+=("$mount_point")
    done < <(mount | grep "^/persist" | grep -E "(type fuse|bind)")
    
    excludes="{tmp,sys,proc,dev,run,etc/passwd,etc/shadow,nix,persist,boot,efi"
    
    if [[ ${#persist_dirs[@]} -gt 0 ]]; then
        for dir in "${persist_dirs[@]}"; do
            excludes="$excludes,${dir#/}"
        done
    fi
    
    excludes="$excludes,var/lib/nixos,var/lib/systemd"
    
    excludes="$excludes}"
    
    echo "Found ${#persist_dirs[@]} persisted directories"
    echo "Excluding: $excludes"
    echo ""
    
    if $show_persisted; then
        echo "Currently persisted directories:"
        printf '%s\n' "${persist_dirs[@]}" | sort
        return
    fi
    
    group_files() {
        local threshold=5
        declare -A dir_counts
        local files=()
        
        while IFS= read -r file; do
            files+=("$file")
        done
        
        if [[ ${#files[@]} -gt 0 ]]; then
            for file in "${files[@]}"; do
                dir=$(dirname "$file")
                if [[ "$dir" =~ ^[^/]+/[^/]+ ]]; then
                    ((dir_counts["$dir"]=${dir_counts["$dir"]:-0}+1))
                fi
            done
        fi
        
        declare -A grouped_dirs
        if [[ ${#dir_counts[@]} -gt 0 ]]; then
            for dir in "${!dir_counts[@]}"; do
                if [ "${dir_counts[$dir]}" -ge "$threshold" ]; then
                    grouped_dirs["$dir"]=1
                fi
            done
        fi
        
        declare -A shown_dirs
        if [[ ${#files[@]} -gt 0 ]]; then
            for file in "${files[@]}"; do
                local show=1
                if [[ ${#grouped_dirs[@]} -gt 0 ]]; then
                    for grouped_dir in "${!grouped_dirs[@]}"; do
                        if [[ "$file" == "$grouped_dir"/* ]]; then
                            if [ -z "${shown_dirs[$grouped_dir]:-}" ]; then
                                echo "$grouped_dir/ [${dir_counts[$grouped_dir]} files]"
                                shown_dirs["$grouped_dir"]=1
                            fi
                            show=0
                            break
                        fi
                    done
                fi
                
                if [ "$show" -eq 1 ]; then
                    echo "$file"
                fi
            done
        fi
    }
    
    if [[ -n "$limit" ]]; then
        output=$(sudo fd --one-file-system --base-directory / --type f --hidden --exclude "$excludes" | group_files)
        line_count=$(echo "$output" | wc -l)
        
        if [ "$line_count" -gt "$limit" ]; then
            echo "$output" | head -"$limit"
            echo ""
            echo "Note: Showing first $limit entries (was $line_count total)."
        else
            echo "$output"
        fi
    else
        sudo fd --one-file-system --base-directory / --type f --hidden --exclude "$excludes" | group_files
    fi
}

pani() {
    local cmd="${1:-}"
    local host="${2:-$(get_current_host)}"
    
    if [[ -z "$cmd" ]]; then
        print_error "No command specified"
        echo "Usage: pani <command> [host]"
        echo ""
        echo "Commands:"
        echo "  switch        - Build and switch to new configuration"
        echo "  boot          - Build and set as boot configuration"
        echo "  test          - Build and activate configuration (without adding to bootloader)"
        echo "  build         - Build configuration only"
        echo "  dry-build     - Show what would be built"
        echo "  check         - Run flake checks"
        echo "  impermanence  - Check files that would be lost on reboot"
        echo ""
        echo "Current host: $(get_current_host)"
        return 1
    fi
    
    cd "$FLAKE_DIR"
    
    print_info "Running '$cmd' for host: $host"
    
    local exit_code=0
    
    case "$cmd" in
        switch|boot|test|build|dry-build)
            if sudo nixos-rebuild "$cmd" --flake ".#$host" --log-format internal-json |& nom --json; then
                print_success "Operation completed successfully!"
                
                # If we're in a devshell and just did a switch, reload it
                if [[ "$cmd" == "switch" ]] && [[ -n "${IN_NIX_SHELL:-}" ]]; then
                    print_info "Reloading development shell..."
                    exec nix develop "$FLAKE_DIR" -c "$SHELL"
                fi
            else
                exit_code=$?
                print_error "Operation failed!"
            fi
            ;;
        check)
            if nix flake check; then
                print_success "Flake check passed!"
            else
                exit_code=$?
                print_error "Flake check failed!"
            fi
            ;;
        impermanence)
            check_impermanence "${@:2}"
            exit_code=$?
            ;;
        *)
            print_error "Unknown command: $cmd"
            exit_code=1
            ;;
    esac
    
    return $exit_code
}

export -f pani

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    pani "$@"
fi
