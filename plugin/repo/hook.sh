
function _do_repo_hook_call() {
    local proj_dir=$1
    local repo=$2
    local cmd=$3
    shift 3

    _do_hook_call "_do_repo_${cmd}" "${proj_dir}" "${repo}" "$@"
    local hook=$(_do_string_to_dash ${repo})-$(_do_string_to_dash ${cmd})
    _do_hook_call "${hook}" "${proj_dir}" "${repo}" "$@"
}

function _do_repo_hook_before() {
    local repo=$1
    local cmd=$2
    local func=$3

    _do_hook_before "$(_do_string_to_dash ${repo})-$(_do_string_to_dash ${cmd})" "${func}"
}

function _do_repo_hook_after() {
    local repo=$1
    local cmd=$2
    local func=$3

    _do_hook_after "$(_do_string_to_dash ${repo})-$(_do_string_to_dash ${cmd})" "${func}"
}


# Registers repo-level command hooks. 
# Arguments:
#   1. plugin: The plugin name.
#   2: The space-delimited list of repo-level commands to add hook for. 
# 
# For example, 
#   _do_repo_cmd_hook_add "django" "clean build"
#   Will register "_do_django_repo_clean" function for the hook "_do_repo_clean"
# 
#
function _do_repo_cmd_hook_add() {
    local repo=$1
    local plugin=$2
    local cmds=$3
    
    _do_log_info "repo" "Register command hooks for plugin ${plugin}"

    local cmd
    for cmd in $cmds; do
        local func="_do_${plugin}_repo_$(_do_string_to_undercase $cmd)"
        _do_repo_hook_after "${repo}" "${cmd}" "${func}"
    done
}

function _do_repo_init_hook_add() {
    local plugin=$1
    local cmds=$2

    _do_log_info "repo" "Register global hooks for plugin ${plugin}"
    local cmd

    for cmd in $cmds; do
        local func="_do_${plugin}_repo_${cmd}"
        _do_hook_after "_do_repo_${cmd}" "${func}"    
    done
}