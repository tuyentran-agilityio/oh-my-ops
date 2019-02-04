
# Loads core libraries
src_files=(
    "os"
    "dir"
    "file"
    "string"
    "alias"
    "color"
    "print"
    "log"
    "error"
    "success"
    "alias"
    "hook"
    "plugin"
)

for src_file in "${src_files[@]}"; do 
    source "${DO_HOME}/src/${src_file}.sh"
done 

_do_log_level_debug "main"

if [ -z "${DO_PLUGINS}" ]; then 
    _do_log_debug "main" "load all plugins"

    # Loads all plugins.
    for plugin in $( ls ${DO_HOME}/plugin ); do 
        _do_plugin $(_do_file_name_without_ext $plugin)
    done

else
    _do_log_debug "main" "load just specified plugins"
    # Just loads the specified plugins.
    _do_plugin  "${DO_PLUGINS}"
fi 

# Initializes all plugins registered
_do_plugin_init
_do_print_banner
