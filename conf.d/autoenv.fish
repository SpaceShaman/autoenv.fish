function autoenv --on-event fish_prompt
    if is_env_active && is_child_dir
        return
    end

    set project_dir (get_project_dir)

    if is_env_active && not is_child_dir
        deactivate_env
    end

    if is_env_file_exist $project_dir
        activate_env $project_dir
    end
end

function is_env_active
    test -n "$AUTOENV_OLD_PROJECT_DIR"
end

function is_child_dir
    if test -n "$AUTOENV_OLD_PROJECT_DIR"
        switch $PWD
            case $AUTOENV_OLD_PROJECT_DIR\*
                return 0
            case \*
                return 1
        end
    else
    end
end

function get_project_dir
    if is_git_repo
        command git rev-parse --show-toplevel
    else
        pwd
    end
end

function is_git_repo
    command git rev-parse --show-toplevel &>/dev/null
end

function is_env_file_exist -a project_dir
    test -e "$project_dir/.env"
end

function activate_env -a project_dir
    for line in (cat $project_dir/.env)
        if not string match -qr '^#|^$' $line
            set item (string split -m 1 "=" $line)
            set key $item[1]
            set value (string trim --chars '"\'' $item[2])
            # Replace ${VAR} patterns with environment variable values
            set value (expand_env_vars $value)
            set -gx $key $value
        end
    end
    set -gx AUTOENV_OLD_PROJECT_DIR $project_dir
end

function expand_env_vars -a value
    # Match ${VAR} or $VAR patterns and replace with env var values
    while string match -qr '\$\{[a-zA-Z_][a-zA-Z0-9_]*\}' $value
        set var_match (string match -r '\$\{([a-zA-Z_][a-zA-Z0-9_]*)\}' $value)
        set var_name $var_match[2]
        set var_value (eval echo \$$var_name)
        set value (string replace "\${$var_name}" "$var_value" $value)
    end
    # Also support $VAR syntax (without braces)
    while string match -qr '\$[a-zA-Z_][a-zA-Z0-9_]*' $value
        set var_match (string match -r '\$([a-zA-Z_][a-zA-Z0-9_]*)' $value)
        set var_name $var_match[2]
        set var_value (eval echo \$$var_name)
        set value (string replace "\$$var_name" "$var_value" $value)
    end
    echo $value
end

function deactivate_env
    for line in (cat $AUTOENV_OLD_PROJECT_DIR/.env)
        if not string match -qr '^#|^$' $line
            set item (string split -m 1 "=" $line)
            set -e $item[1]
        end
    end
    set -e AUTOENV_OLD_PROJECT_DIR
end
